Feature: Test API endpoint - POST /v3/user-on-board/get-client-mapping
# API 86: POST/v3/user-on-board/get-client-mapping
  ##############** POST Method **###################
# Purpose: Returns a user mapping details successfully - Low Complexicity API.

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
    "userEmail": "vuser_16@veehealthtek.com"
  }
  """
  * string requestBodyStr = requestTemplate
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/admin-service/v3/user-on-board/get-client-mapping'
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

  * match decryptedResponse.userMappingsDetails == '#[]'

  * match each decryptedResponse.userMappingsDetails ==
    """
    {
      clientId: '#number',
      clientName: '#string',
      description: '#string',
      databaseName: '#string',
      clientLogo: '#string',
      clientCode: '#string',
      moduleGroup: '#[]'
    }
    """

  * match each decryptedResponse.userMappingsDetails[*].moduleGroup[*] ==
    """
    {
      moduleId: '#number',
      moduleName: '#string',
      processGroup: '#[]'
    }
    """

  * match each decryptedResponse.userMappingsDetails[*].moduleGroup[*].processGroup[*] ==
    """
    {
      processId: '#number',
      processName: '#string',
      isAssigned: '#number'
    }
    """


    # Negative Flows
  Scenario: Negative Flow - Unauthorized
#    * def email = 'Vuser1112@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "vuser_16@veehealthtek.com"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/get-client-mapping'
#    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method post
    Then status 401
    * print response

  Scenario: Negative Flow - Bad request.
   # * def email = 'Vuser111@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": ""
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/get-client-mapping'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header X-Encrypted-Payload = 'true'
    And header Content-Type = 'text/plain'
    And request encryptedBody
    When method post
    Then status 400
    * print response