package org.encryption;

import javax.crypto.Cipher;
import javax.crypto.KeyAgreement;
import javax.crypto.Mac;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.OutputStream;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.security.interfaces.ECPublicKey;
import java.security.spec.*;
import java.util.Arrays;
import java.util.Base64;
import java.util.Scanner;
import java.util.UUID;

/**
 * ECDH + AES-256-GCM Encryption/Decryption Utility for RevAmp API Automation.
 *
 * Flow:
 * 1. Generate ephemeral ECDH P-256 keypair
 * 2. Exchange public keys with server via /v3/ecdh-exchange
 * 3. Derive shared secret using ECDH
 * 4. Derive AES-256 key using HKDF-SHA-256
 * 5. Encrypt request body / Decrypt response body using AES-256-GCM
 */
public class ECDHCryptoUtil {

    private static final String GATEWAY_BASE_URL = "https://mttd2k3khk.execute-api.us-east-1.amazonaws.com/qa";
    private static final String ECDH_EXCHANGE_PATH = "/auth-service/v3/ecdh-exchange";
    private static final String HKDF_SALT = "RevAmp-ECDH-v1";
    private static final String HKDF_INFO = "AES-256-GCM-KEY";
    private static final int AES_KEY_LENGTH = 32; // 256 bits
    private static final int GCM_IV_LENGTH = 12;
    private static final int GCM_TAG_LENGTH = 16;
    private static final int GCM_TAG_BITS = 128;

    private String ecdhSessionId;
    private byte[] aesKey;
    private KeyPair clientKeyPair;

    /**
     * Initialize the crypto session: generate keys, perform handshake, derive AES key.
     */
    public void initialize() throws Exception {
        // Step 1: Generate session ID
        this.ecdhSessionId = UUID.randomUUID().toString();
        System.out.println("ECDH Session ID: " + ecdhSessionId);

        // Step 2: Generate ephemeral ECDH keypair (P-256)
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("EC");
        keyPairGenerator.initialize(new ECGenParameterSpec("secp256r1"));
        this.clientKeyPair = keyPairGenerator.generateKeyPair();

        // Step 3: Export client public key as JWK
        String clientPublicKeyJwk = exportPublicKeyAsJwk((ECPublicKey) clientKeyPair.getPublic());
        System.out.println("Client Public Key JWK: " + clientPublicKeyJwk);

        // Step 4: Perform ECDH exchange with server
        String serverPublicKeyJwk = performEcdhExchange(clientPublicKeyJwk);
        System.out.println("Server Public Key JWK: " + serverPublicKeyJwk);

        // Step 5: Import server public key from JWK
        ECPublicKey serverPublicKey = importPublicKeyFromJwk(serverPublicKeyJwk);

        // Step 6: Perform ECDH key agreement to get shared secret
        KeyAgreement keyAgreement = KeyAgreement.getInstance("ECDH");
        keyAgreement.init(clientKeyPair.getPrivate());
        keyAgreement.doPhase(serverPublicKey, true);
        byte[] sharedSecret = keyAgreement.generateSecret();
        System.out.println("Shared secret derived (" + sharedSecret.length + " bytes)");

        // Step 7: Derive AES-256 key using HKDF-SHA-256
        this.aesKey = hkdfSha256(
                sharedSecret,
                HKDF_SALT.getBytes(StandardCharsets.UTF_8),
                HKDF_INFO.getBytes(StandardCharsets.UTF_8),
                AES_KEY_LENGTH
        );
        System.out.println("AES-256 key derived successfully.");
    }

    /**
     * Get the ECDH session ID for use in request headers.
     */
    public String getSessionId() {
        return ecdhSessionId;
    }

    /**
     * Encrypt a plaintext JSON string into Base64URL-encoded ciphertext.
     * Layout: [IV(12 bytes) | ciphertext(n bytes) | tag(16 bytes)]
     */
    public String encrypt(String plaintext) throws Exception {
        byte[] iv = new byte[GCM_IV_LENGTH];
        SecureRandom random = new SecureRandom();
        random.nextBytes(iv);

        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_BITS, iv);
        SecretKeySpec keySpec = new SecretKeySpec(aesKey, "AES");
        cipher.init(Cipher.ENCRYPT_MODE, keySpec, gcmSpec);

        byte[] ciphertextWithTag = cipher.doFinal(plaintext.getBytes(StandardCharsets.UTF_8));

        // Java's GCM appends tag to ciphertext: [ciphertext | tag]
        // Final layout: [IV | ciphertext | tag]
        byte[] payload = new byte[GCM_IV_LENGTH + ciphertextWithTag.length];
        System.arraycopy(iv, 0, payload, 0, GCM_IV_LENGTH);
        System.arraycopy(ciphertextWithTag, 0, payload, GCM_IV_LENGTH, ciphertextWithTag.length);

        // Encode as Base64URL without padding
        return Base64.getUrlEncoder().withoutPadding().encodeToString(payload);
    }

    /**
     * Decrypt a Base64URL-encoded ciphertext string into plaintext JSON.
     * Expected layout: [IV(12 bytes) | ciphertext(n bytes) | tag(16 bytes)]
     */
    public String decrypt(String ciphertextBase64Url) throws Exception {
        byte[] payload = Base64.getUrlDecoder().decode(ciphertextBase64Url);

        // Extract IV (first 12 bytes)
        byte[] iv = Arrays.copyOfRange(payload, 0, GCM_IV_LENGTH);

        // Extract ciphertext + tag (remaining bytes)
        byte[] ciphertextWithTag = Arrays.copyOfRange(payload, GCM_IV_LENGTH, payload.length);

        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_BITS, iv);
        SecretKeySpec keySpec = new SecretKeySpec(aesKey, "AES");
        cipher.init(Cipher.DECRYPT_MODE, keySpec, gcmSpec);

        byte[] plaintext = cipher.doFinal(ciphertextWithTag);
        return new String(plaintext, StandardCharsets.UTF_8);
    }

    // ==================== Private Helper Methods ====================

    /**
     * Export EC public key as JWK JSON string.
     */
    private String exportPublicKeyAsJwk(ECPublicKey publicKey) {
        ECPoint point = publicKey.getW();
        byte[] xBytes = bigIntToFixedBytes(point.getAffineX(), 32);
        byte[] yBytes = bigIntToFixedBytes(point.getAffineY(), 32);

        String x = Base64.getUrlEncoder().withoutPadding().encodeToString(xBytes);
        String y = Base64.getUrlEncoder().withoutPadding().encodeToString(yBytes);

        return "{\"kty\":\"EC\",\"crv\":\"P-256\",\"x\":\"" + x + "\",\"y\":\"" + y + "\"}";
    }

    /**
     * Import EC public key from JWK JSON string.
     */
    private ECPublicKey importPublicKeyFromJwk(String jwkJson) throws Exception {
        // Parse x and y from JWK JSON
        String x = extractJsonValue(jwkJson, "x");
        String y = extractJsonValue(jwkJson, "y");

        byte[] xBytes = Base64.getUrlDecoder().decode(x);
        byte[] yBytes = Base64.getUrlDecoder().decode(y);

        BigInteger xInt = new BigInteger(1, xBytes);
        BigInteger yInt = new BigInteger(1, yBytes);

        ECPoint point = new ECPoint(xInt, yInt);

        // Get P-256 curve parameters
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC");
        kpg.initialize(new ECGenParameterSpec("secp256r1"));
        ECPublicKey tempKey = (ECPublicKey) kpg.generateKeyPair().getPublic();
        ECParameterSpec ecSpec = tempKey.getParams();

        ECPublicKeySpec pubKeySpec = new ECPublicKeySpec(point, ecSpec);
        KeyFactory keyFactory = KeyFactory.getInstance("EC");
        return (ECPublicKey) keyFactory.generatePublic(pubKeySpec);
    }

    /**
     * Perform ECDH key exchange with server.
     */
    private String performEcdhExchange(String clientPublicKeyJwk) throws Exception {
        URL url = new URL(GATEWAY_BASE_URL + ECDH_EXCHANGE_PATH);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("X-ECDH-Session", ecdhSessionId);
        conn.setDoOutput(true);
        conn.setConnectTimeout(30000);
        conn.setReadTimeout(30000);

        // Request body: { "clientPublicKeyJwk": "<stringified JWK JSON>" }
        String requestBody = "{\"clientPublicKeyJwk\":\"" + escapeJson(clientPublicKeyJwk) + "\"}";
        System.out.println("ECDH Exchange Request: " + requestBody);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(requestBody.getBytes(StandardCharsets.UTF_8));
        }

        int responseCode = conn.getResponseCode();
        System.out.println("ECDH Exchange Response Code: " + responseCode);

        String responseBody;
        if (responseCode >= 200 && responseCode < 300) {
            try (Scanner scanner = new Scanner(conn.getInputStream(), "UTF-8")) {
                responseBody = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
            }
        } else {
            try (Scanner scanner = new Scanner(conn.getErrorStream(), "UTF-8")) {
                responseBody = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
            }
            throw new RuntimeException("ECDH exchange failed with status " + responseCode + ": " + responseBody);
        }

        System.out.println("ECDH Exchange Response: " + responseBody);

        // Extract serverPublicKeyJwk from response
        String serverJwk = extractJsonValue(responseBody, "serverPublicKeyJwk");
        // The serverPublicKeyJwk value might be a stringified JSON, so unescape it
        serverJwk = serverJwk.replace("\\\"", "\"").replace("\\\\", "\\");
        return serverJwk;
    }

    /**
     * HKDF-SHA-256 key derivation (RFC 5869).
     */
    private byte[] hkdfSha256(byte[] ikm, byte[] salt, byte[] info, int outputLength) throws Exception {
        // Step 1: Extract - HMAC-SHA-256(salt, ikm) = PRK
        Mac hmac = Mac.getInstance("HmacSHA256");
        SecretKeySpec saltKey = new SecretKeySpec(salt, "HmacSHA256");
        hmac.init(saltKey);
        byte[] prk = hmac.doFinal(ikm);

        // Step 2: Expand - generate output key material
        int hashLen = 32; // SHA-256 output length
        int n = (int) Math.ceil((double) outputLength / hashLen);
        byte[] okm = new byte[outputLength];
        byte[] t = new byte[0];

        for (int i = 1; i <= n; i++) {
            hmac = Mac.getInstance("HmacSHA256");
            hmac.init(new SecretKeySpec(prk, "HmacSHA256"));
            hmac.update(t);
            hmac.update(info);
            hmac.update((byte) i);
            t = hmac.doFinal();
            System.arraycopy(t, 0, okm, (i - 1) * hashLen, Math.min(hashLen, outputLength - (i - 1) * hashLen));
        }

        return okm;
    }

    /**
     * Convert BigInteger to fixed-length byte array (pad with leading zeros if needed).
     */
    private byte[] bigIntToFixedBytes(BigInteger value, int length) {
        byte[] bytes = value.toByteArray();
        if (bytes.length == length) {
            return bytes;
        } else if (bytes.length > length) {
            // Remove leading zero byte (sign bit)
            return Arrays.copyOfRange(bytes, bytes.length - length, bytes.length);
        } else {
            // Pad with leading zeros
            byte[] padded = new byte[length];
            System.arraycopy(bytes, 0, padded, length - bytes.length, bytes.length);
            return padded;
        }
    }

    /**
     * Simple JSON value extractor (for flat JSON objects).
     */
    private String extractJsonValue(String json, String key) {
        String searchKey = "\"" + key + "\"";
        int keyIndex = json.indexOf(searchKey);
        if (keyIndex == -1) {
            throw new RuntimeException("Key '" + key + "' not found in JSON: " + json);
        }
        int colonIndex = json.indexOf(":", keyIndex + searchKey.length());
        int valueStart = json.indexOf("\"", colonIndex + 1) + 1;
        int valueEnd = findClosingQuote(json, valueStart);
        return json.substring(valueStart, valueEnd);
    }

    /**
     * Find closing quote, handling escaped quotes.
     */
    private int findClosingQuote(String json, int startIndex) {
        for (int i = startIndex; i < json.length(); i++) {
            if (json.charAt(i) == '"' && json.charAt(i - 1) != '\\') {
                return i;
            }
        }
        return json.length();
    }

    /**
     * Escape a string for JSON embedding.
     */
    private String escapeJson(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}

