Feature: Test Api End Point - /v3/custom-reports/get-tables

 Background:
  * url gatewayBaseUrl
  * def crypto = karate.get('crypto')
  * def ecdhSessionId = karate.get('ecdhSessionId')
  * def authCookie = karate.get('authCookie')
  * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
  * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
  * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

 Scenario: Positive Flow
 Given path '/report-service/v3/custom-reports/get-tables'
 And header Cookie = 'auth_token=' + authCookie
 And header X-ECDH-Session = ecdhSessionId
 And header X-Encrypted-Payload = 'true'
 And header Content-Type = 'text/plain'
 When method post
 Then status 200
 * def decryptedResponseStr = crypto.decrypt(response)
 * print 'Decrypted Response:', decryptedResponseStr

 * def decryptedResponse = JSON.parse(decryptedResponseStr)
 * print decryptedResponse

 # Response Validation
 * match decryptedResponse.tableNames == '#[]'
 * match each decryptedResponse.tableNames ==
  """
  {
   tableName: "#string",
   displayTableName: "#string"
  }
  """

  * match decryptedResponse.collections == '#[]'
  * match each decryptedResponse.collections ==
  """
  {
    collection_id: '#number',
    collection_name: '#string'
  }
  """

# Negative Scenarios
 Scenario: 405 - method not found
  Given path '/report-service/v3/custom-reports/get-tables'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  When method GET
  Then status 405

 Scenario: 404 - url incorrect
  Given path '/report-service/v2/custom-reports/get-tableseee'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  When method post
  Then status 404

 Scenario: 401 - unauthoriZed
  Given path '/report-service/v3/custom-reports/get-tables'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  When method post
  Then status 401

