Feature: Test Api end point -/V3/login-tracker

Background:
  * url gatewayBaseUrl
  * def crypto = karate.get('crypto')
  * def ecdhSessionId = karate.get('ecdhSessionId')
  * def authCookie = karate.get('authCookie')
  * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
  * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
  * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

Scenario: Positive Flow
  * def requestJson = '{}'
  * def encryptedBody = crypto.encrypt(requestJson)
  Given path '/auth-service/v3/login-tracker'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 200
  * def decryptedResponse = crypto.decrypt(response)
  * print 'Decrypted Response:', decryptedResponse


Scenario: Negative Flow - sent request using GET method
  * def requestJson = '{}'
  * def encryptedBody = crypto.encrypt(requestJson)
  Given path '/auth-service/v3/login-tracker'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method get
  Then status 405
  * print response