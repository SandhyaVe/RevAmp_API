Feature: Test API endpoint - POST /v3/user-on-board/get-user-page-permissions
  # API 92: POST /v3/user-on-board/get-user-page-permissions
  # Purpose: To retrieve the page permissions assigned to a user, including both group-based permissions and custom permissions.

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
        "userEmail": "Vuser_16@veehealthtek.com"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/admin-service/v3/user-on-board/get-user-page-permissions'
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
      permission_group_name: '#string',
      permission_group_id: '#number'
    }
    """

    * eval
      """
      if (decryptedResponse.customPermissions.length > 0) {
        karate.matchEach(decryptedResponse.customPermissions, {
          permission_group_name: '#string',
          menu_name: '#string',
          menu_master_id: '#number'
        });
      }
      """

    # Negative Flows
  Scenario: Negative Flow - User mail id not found in token.
    * def email = 'Vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "Vuser_16@veehealthtek.com"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/get-user-page-permissions'
#    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 401
    * print response

  Scenario: Negative Flow - Failed to retrieve client mapping details.
    * def email = 'Vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": ""
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/get-user-page-permissions'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 400
    * print response