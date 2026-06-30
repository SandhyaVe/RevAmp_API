Feature: Test API endpoint - POST /v3/user-on-board/get-page-permissions-details
  #API 93: GET / v3/user-on-board/get-page-permissions-details
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

    Given path '/admin-service/v3/user-on-board/get-page-permissions-details'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method GET
    Then status 200
    * def decryptedResponseStr = crypto.decrypt(response)
    * print 'Decrypted Response:', decryptedResponseStr

    * def decryptedResponse = JSON.parse(decryptedResponseStr)
    * match decryptedResponse ==
    """
    {
      userPermissions: '#[]',
      customPermissions: '#[]'
    }
    """

    * match each decryptedResponse.userPermissions ==
    """
    {
      permission_type: '#string',
      permission_group_id: '#number',
      permission_name:'#string',
      page_name:'#string',
      page_id:'#number'
    }
    """

    * match each decryptedResponse.customPermissions ==
      """
      {
        PermissionType: '#string',
        PermissionName: '#string',
        menu_name:'#string',
        menu_master_id:'#number'
      }
      """

  # Negative Flows
  Scenario: Negative Flow - Unauthorised token.
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
    Given path '/admin-service/v3/user-on-board/get-page-permissions-details'
#    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method GET
    Then status 401
    * print response

  #  Scenario: Negative Flow - Bad request.
  #    We cannot simulate a bad request for this endpoint since it is a GET method, and it does not require passing even the email in the request body.

  Scenario: Negative Flow - Method not found.
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
    Given path '/admin-service/v3/user-on-board/get-page-permissions-details'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 405
    * print response