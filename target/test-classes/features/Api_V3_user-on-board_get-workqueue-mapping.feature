Feature: Test API endpoint - POST /v3/user-on-board/get-workqueue-mapping
  # API 85: POST/v3/user-on-board/get-workqueue-mapping
  # Purpose: To display the Work queue mapping in admin screen

  Background:
    * url gatewayBaseUrl
    * def crypto = karate.get('crypto')
    * def ecdhSessionId = karate.get('ecdhSessionId')
    * def authCookie = karate.get('authCookie')
    * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
    * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
    * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

  Scenario: Positive Flow
    * def email = 'Vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "Vuser_16@veehealthtek.com",
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

    Given path '/admin-service/v3/user-on-board/get-workqueue-mapping'
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

    # Step 1: validate top-level array
    * match decryptedResponse.workQueueMappings == '#[]'

    # Step 2: validate each client
    * match each decryptedResponse.workQueueMappings ==
      """
      {
        clientId: '#number',
        clientName: '#string',
        moduleGroup: '#[]'
      }
      """

    # Step 3: validate moduleGroup
    * match each decryptedResponse.workQueueMappings[*].moduleGroup[*] ==
      """
      {
        moduleId: '#number',
        moduleName: '#string',
        processGroup: '#[]'
      }
      """

    # Step 4: validate processGroup
    * match each decryptedResponse.workQueueMappings[*].moduleGroup[*].processGroup[*] ==
      """
      {
        processId: '#number',
        processName: '#string',
        workQueueGroup: '#[]'
      }
      """

    # Step 5: validate workQueueGroup (deep level)
    * match each decryptedResponse.workQueueMappings[*].moduleGroup[*].processGroup[*].workQueueGroup[*] ==
      """
      {
        workQueueId: '#number',
        workQueueName: '#string',
        workQueueDescription: '#string',
        isAssigned: '#number'
      }
      """

    # Negative Flows
  Scenario: Negative Flow - Unauthorized.
    * def email = 'Vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "Vuser_16@veehealthtek.com"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/get-workqueue-mapping'
#    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 401
    * print response

  Scenario: Negative Flow - Bad Request.
    * def email = 'Vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": ""
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/get-workqueue-mapping'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 400
    * print response
