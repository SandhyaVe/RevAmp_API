Feature: Test API endpoint - POST /v3/user-on-board/update-user-client-workqueue-mapping
  #API 93: GET / v3/user-on-board/update-user-client-workqueue-mapping
  # Purpose:

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
        "userUpdatedWorkQueueMappingList": [
          {
            "updatedClient": 1,
            "updatedWorkQueues": "1100",
            "userEmail": "vuser_55@veehealthtek.com"
          }
        ],
        "userWorkQueueMappingData": [
          {
            "clientId": 1,
            "moduleId": 1,
            "processId": 1,
            "workqueueIds": "1101,1102",
            "userEmail": "vuser_55@veehealthtek.com"
          }
        ]
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/admin-service/v3/user-on-board/update-user-client-workqueue-mapping'
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
    * match decryptedResponse.message == '#regex User client workqueue inerted successfully\\.'

  # Negative Flows
  Scenario: Negative Flow - Unauthorised.
    * def email = 'vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "loginEmail": "vuser_16@veehealthtek.com",
        "permissionGroupIds": "0,1,1",
        "isActives": "0,1,0",
        "permissionType": ["Group","Custom"],
        "menuID": [1,2],
        "menuIsActive": [TRUE,FALSE]
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/user-group-permission'
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
        "permissionGroupIds": "",
        "isActives": "",
        "permissionType": [],
        "menuID": [],
        "menuIsActive": []
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/user-group-permission'
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
    Given path '/admin-service/v3/user-on-board/user-group-permission'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method GET
    Then status 405
    * print response