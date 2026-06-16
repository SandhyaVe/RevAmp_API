Feature: Test API endpoint - POST /v3/user-on-board/insert-new-user
  # API 90: POST /v3/user-on-board/insert-new-user
  # Purpose: To insert a new user into the system or return an existing
  # active user if already present. Also assigns the user to a permission
  # group (Admin/User).

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
        "loginEmail": "vuser_16@veehealthtek.com",
        "displayUserName": "vuser_16 Doe123",
        "userDesignation": "Associate Manager",
        "reportingTo": "Jane12 Smith",
        "reportingToDesignation": "Senior Manager",
        "permissionGroup": "Admin"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/admin-service/v3/user-on-board/insert-new-user'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 200
    * def decryptedResponseStr = crypto.decrypt(response)
    * print 'Decrypted Response:', decryptedResponseStr

    * def decryptedResponse = JSON.parse(decryptedResponseStr)
    * match decryptedResponse.message == '#regex User processed successfully\\. UserId: \\d+'

  # Negative Flows
  Scenario: Negative Flow - Unauthorised token.
    * def email = 'vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "vuser_16@veehealthtek.com"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/insert-new-user'
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
        "loginEmail": "",
        "displayUserName": "",
        "userDesignation": "",
        "reportingTo": "",
        "reportingToDesignation": "",
        "permissionGroup": ""
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/insert-new-user'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 400
    * print response