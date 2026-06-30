Feature: Test API endpoint - GET /v3/user-on-board/get-user-summary-details
  # API 89: GET /v3/user-on-board/get-user-summary-details
  # Purpose: To fetch user summary statistics along with detailed user information for the User Onboarding module.

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

    Given path '/admin-service/v3/user-on-board/get-user-summary-details'
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

    # Validate UserSummaryCount (OBJECT)
    * match decryptedResponse.userSummaryCount ==
      """
      {
        TotalUsers: '#number',
        ActiveUsers: '#number',
        IdleUsers_30Days: '#number',
        InactiveUsers: '#number'
      }
      """

    # Validate UserDetails (ARRAY)
    * match decryptedResponse.userDetails == '#[]'
    * match each decryptedResponse.userDetails ==
      """
      {
        UserId: '#number',
        UserName: '#string',
        UserDesignation: '##string',
        UserEmail: '#string',
        ReportingToName: '##string',
        ReportingToDesignation: '##string',
        CreatedDate: '#string',
        LastActivityDate: '##string',
        IsActive: '#boolean',
        UserProfile:'##string'
      }
      """

  # Negative Flows
  Scenario: Negative Flow - Unauthorised.
    * def email = 'Vuser_16@veehealthtek.com'
    * def requestTemplate =
      """
      {
        "userEmail": "Vuser_16@veehealthtek.com"
      }
      """
    * string requestBodyStr = requestTemplate
    * def encryptedBody = crypto.encrypt(requestBodyStr)
    Given path '/admin-service/v3/user-on-board/get-user-summary-details'
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