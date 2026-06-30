function fn() {
  // Disable SSL certificate verification for all Karate HTTP calls (fixes PKIX path building error)
  karate.configure('ssl', true);

  // Step 1: Cookie Extraction via Selenium (for downstream APIs like login-tracker)
  var TokenExtractor = Java.type('org.Token_Extraction.TokenExtractorUtil');
  var authCookie = TokenExtractor.getAuthCookie('Vuser_2@veehealthtek.com', 'Cloud@1234');
  if (authCookie == null || authCookie == '') {
    karate.log('AUTH_COOKIE_MISSING: auth_token was not extracted. Check target/token-extractor-debug.log');
  } else {
    var maskedCookie = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8);
    karate.log('AUTH_COOKIE_EXTRACTED:', maskedCookie, 'length:', authCookie.length);
  }

  // Step 2: Initialize ECDH Encryption (for encrypted request/response bodies)
  var ECDHCryptoUtil = Java.type('org.encryption.ECDHCryptoUtil');
  var crypto = new ECDHCryptoUtil();
  crypto.initialize();

  var ecdhSessionId = crypto.getSessionId();
  karate.log('ECDH Session ID:', ecdhSessionId);

  return {
    authCookie: authCookie,
    crypto: crypto,
    ecdhSessionId: ecdhSessionId,
    gatewayBaseUrl: 'https://mttd2k3khk.execute-api.us-east-1.amazonaws.com/qa'
  };
}
