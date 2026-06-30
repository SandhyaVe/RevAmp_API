Feature: Test API endpoint - POST /v3/user-on-board/user-client-mapping
  #API 93: GET / v3/user-on-board/user-group-permission
  # Purpose: To retrieve all available page permission configurations in
  # the system, including both permission group mappings and custom
  # permission menu definitions. This API is primarily used to build permission configuration screens.

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
        "clientIds": "1,4",
        "moduleIds": "1,2",
        "processIds": "1,20",
        "isActive": "1,1"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/admin-service/v3/user-on-board/user-client-mapping'
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
    * match decryptedResponse.message == 'User client mapping inserted successfully'

  # Negative Flows
  Scenario: Negative Flow - Unauthorised.
    * def email = 'vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "LoginEmail": "vuser_16@veehealthtek.com",
        "ClientIds": "1",
        "ModuleIds": "10",
        "ProcessIds": "100",
        "IsActive": "1"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/user-client-mapping'
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
        "LoginEmail": "",
        "ClientIds": "",
        "ModuleIds": "",
        "ProcessIds": "",
        "IsActive": ""
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/user-client-mapping'
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
        "userEmail": "saravanan.sek@veehealthtek.com",
        "workQueueDataRequestModel": [
          {
            "clientId": 1,
            "moduleId": 1,
            "processId": 1
          }
        ]
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/user-client-mapping'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method GET
    Then status 405
    * print response