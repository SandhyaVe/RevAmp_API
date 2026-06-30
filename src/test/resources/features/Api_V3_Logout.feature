Feature: Test Api End Point - /v3/logout

  Background:
    * url gatewayBaseUrl
    * def crypto = karate.get('crypto')
    * def ecdhSessionId = karate.get('ecdhSessionId')
    * def authCookie = karate.get('authCookie')
    * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
    * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
    * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

  Scenario: Positive Flow
    Given path '/auth-service/v3/logout'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'text/plain'
    When method POST
    Then status 200
    * def decryptedResponseStr = crypto.decrypt(response)
    * print 'Decrypted Response:', decryptedResponseStr
    * def decryptedResponse = JSON.parse(decryptedResponseStr)
    And match decryptedResponse == { message: 'You have successfully logged out.' }

  Scenario: Negative Flow - 405 Method not found
    Given path '/auth-service/v3/logout'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'text/plain'
    When method GET
    Then status 405

  Scenario: Negative Flow - 401 Unauthorized
    Given path '/auth-service/v3/logout'
#    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'text/plain'
    When method POST
    Then status 401

  Scenario: Negative Flow - 404 incorrect url
    Given path '/auth-service/v2/log0ut'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'text/plain'
    When method POST
    Then status 404