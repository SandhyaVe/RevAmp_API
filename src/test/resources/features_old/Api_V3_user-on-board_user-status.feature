Feature: Test API endpoint - POST /v3/user-on-board/user-status
  # POST /v3/user-on-board/user-status -> Got from Source code
  # Purpose: To Check the user exist or new user.

  Background:
    * url gatewayBaseUrl
    * def crypto = karate.get('crypto')
    * def ecdhSessionId = karate.get('ecdhSessionId')
    * def authCookie = karate.get('authCookie')
    * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
    * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
    * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

  Scenario: Positive Flow
    * def email = 'vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "vuser_16@veehealthtek.com",
        "IsActive": true
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/admin-service/v3/user-on-board/user-status'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 200
    * def decryptedResponseStr = crypto.decrypt(response)
    * print 'Decrypted Response:', decryptedResponseStr

    # Convert string → JSON
    * def decryptedResponse = JSON.parse(decryptedResponseStr)
    * match decryptedResponse.message == 'User status updated successfully'

  # Negative Flows
  Scenario: Negative Flow - Unauthorised.
    * def email = 'vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "vuser_16@veehealthtek.com",
        "IsActive": "Yes"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/user-status'
#    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 401
    * print response

  Scenario: Negative Flow - Bad request.
    * def email = 'vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "",
        "IsActive": ""
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/user-status'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 400
    * print response


  Scenario: Negative Flow - Method not found.
    * def email = 'vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "vuser_16@veehealthtek.com",
        "IsActive": "Yes"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/user-status'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method GET
    Then status 405
    * print response