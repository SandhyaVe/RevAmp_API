Feature: Test Api end point - /v3/get-profile

  Background:
    * url gatewayBaseUrl
    * def crypto = karate.get('crypto')
    * def ecdhSessionId = karate.get('ecdhSessionId')
    * def authCookie = karate.get('authCookie')
    * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
    * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
    * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

 Scenario: Positive Flow
   * def requestTemplate =
     """
     {
       "userEmail": "Vuser_2@veehealthtek.com"
     }
     """
   * string requestBodyStr = requestTemplate
   * def encryptedBody = crypto.encrypt(requestBodyStr)

   Given path '/auth-service/v3/get-profile'
   And header Cookie = 'auth_token=' + authCookie
   And header X-ECDH-Session = ecdhSessionId
   And header X-Encrypted-Payload = 'true'
   And header Content-Type = 'text/plain'
   And request encryptedBody
   When method GET
   Then status 200
   * def decryptedResponseStr = crypto.decrypt(response)
   * print 'Decrypted Response:', decryptedResponseStr
   * def decryptedRes = JSON.parse(decryptedResponseStr)

   * match decryptedRes.userProfileDetails ==
     """
     {
       first_name: '#string',
       last_name: '##string',
       designation: '##string'
     }
     """

    #Negative scenarios
  Scenario: 405 - method not found
    * def requestTemplate =
      """
      {
        "userEmail": "Vuser_2@veehealthtek.com"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/auth-service/v3/get-profile'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 405

  Scenario: 404 - incorrect url
    * def requestTemplate =
      """
      {
        "userEmail": "Vuser_2@veehealthtek.com"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/auth-service/v2/get-profileeeee'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method GET
    Then status 404

  Scenario: 401 - unauthorized
    * def requestTemplate =
      """
      {
        "userEmail": "Vuser_2@veehealthtek.com"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/auth-service/v3/get-profile'
#    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method GET
    Then status 401
