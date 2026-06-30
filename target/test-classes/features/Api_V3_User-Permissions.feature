Feature: Test Api end point - /v3/users/permissions

  Background:
  * url gatewayBaseUrl
  * def crypto = karate.get('crypto')
  * def ecdhSessionId = karate.get('ecdhSessionId')
  * def authCookie = karate.get('authCookie')
  * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
  * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
  * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

  Scenario: Positive Flow
    * def requestBody =
      """
      {
        "userId":43
      }
      """
    * string requestBodyStr = karate.toJson(requestBody)
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/auth-service/v3/users/permissions'
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
    * print decryptedResponse

    # Response Validation
    * match decryptedResponse.permissions == '#[]'
    * match each decryptedResponse.permissions ==
    """
    {
      page_id: '#number',
      permission_group_id: '##number',
      permission_group_name: '##string',
      descriptions: '##string',
      page_name: '#string',
      page_url: '#string',
      menu_master_id: '##number',
      menu_name: '##string',
      parent_menu_master_id: '##number',
      menu_type: '##string',
      icon: '##string',
      display_order: '##number'
    }
    """

    # 2nd
    * match decryptedResponse.landingPages == '#[]'
    * match each decryptedResponse.landingPages ==
      """
      {
        page_id: '#number',
        page_name: '#string',
        page_url: '#string'
      }
      """

    # 3rd
    * match decryptedResponse.isPermissionGroup == '#boolean'

# Negative Scenarios
  Scenario: 400 bad request
    * def requestBody =
      """
      {
        "userIdddd":43
      }
      """
    * string requestBodyStr = karate.toJson(requestBody)
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/auth-service/v3/users/permissions'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 400

  Scenario: 405 method not found
    * def requestBody =
      """
      {
        "userId":43
      }
      """
    * string requestBodyStr = karate.toJson(requestBody)
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/auth-service/v3/users/permissions'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method GET
    Then status 405

  Scenario: 404 incorrect url
    * def requestBody =
      """
      {
        "userId":43
      }
      """
    * string requestBodyStr = karate.toJson(requestBody)
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/auth-service/v2/users/permissionssss'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 404

  Scenario: 401 - unautorised
    * def requestBody =
      """
      {
        "userId":43
      }
      """
    * string requestBodyStr = karate.toJson(requestBody)
    * def encryptedBody = crypto.encrypt(requestBodyStr)

    Given path '/auth-service/v3/users/permissions'
#    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method POST
    Then status 401

  Scenario: 415 Unsupported Media Type
    Given path '/auth-service/v3/users/permissions'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'false'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And request ''
    When method POST
    Then status 415
    * print response