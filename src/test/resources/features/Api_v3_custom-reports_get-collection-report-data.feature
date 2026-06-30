Feature: Test Api End Point - /v3/custom-reports/get-collection-report-data

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
   "type": "custom"
  }
  """
 * string requestBodyStr = karate.toJson(requestBody)
 * def encryptedBody = crypto.encrypt(requestBodyStr)

 Given path '/report-service/v3/custom-reports/get-collection-report-data'
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
 * match decryptedResponse.collections == '#[]'
 * match each decryptedResponse.collections ==
  """
  {
   collection_id: '#number',
   "collection_name": '#string',
   "descriptions": '##string',
   "created_by": '#string',
   "created_on": '#regex \\d{2}/\\d{2}/\\d{4}'
  }
  """

  * match decryptedResponse.reports == '#[]'
  * match each decryptedResponse.reports ==
  """
  {
   collection_id: '#number',
   report_id: '#number',
   report_name: '#string',
   report_descriptions: '##string',
   group_by: '##number',
   is_unique: '#boolean',
   created_by: '#string',
   created_on: '#regex \\d{2}/\\d{2}/\\d{4}'
  }
  """

 #  Negative Scenarios
 Scenario: 400 - Bad Request
  * def requestBody = '{ "ty11": '
  * def encryptedBody = crypto.encrypt(requestBody)

  Given path '/report-service/v3/custom-reports/get-collection-report-data'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method POST
  Then status 400
  * print response
  * match response contains 'The request field is required'

 Scenario: 405 - method not found
  * def requestBody =
   """
   {
    "type": "custom"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v3/custom-reports/get-collection-report-data'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method GET
  Then status 405

 Scenario: 404 - Incorrect URL
  * def requestBody =
   """
   {
    "type": "custom"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v2/custom-reports/get-collection-report-datasss'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method POST
  Then status 404

 Scenario: 401 - Unauthorized
  * def requestBody =
   """
   {
    "type": "custom"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v3/custom-reports/get-collection-report-data'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method POST
  Then status 401

 Scenario: 415 - Unsupported Media Type
  Given path '/report-service/v3/custom-reports/get-collection-report-data'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'false'
  And header Content-Type = 'application/x-www-form-urlencoded'
  And request ''
  When method POST
  Then status 415