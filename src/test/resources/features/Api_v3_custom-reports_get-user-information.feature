Feature: Test Api End Point - /v3/custom-reports/get-user-information

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
    "reportId": 3
   }
   """
 * string requestBodyStr = karate.toJson(requestBody)
 * def encryptedBody = crypto.encrypt(requestBodyStr)
 Given path '/report-service/v3/custom-reports/get-user-information'
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
 * match decryptedResponse.userInformation == '#[]'
 * match each decryptedResponse.userInformation ==
 """
  {
    "login_email": '#regex (^([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,})$|^[A-Za-z0-9_]+$)',
    "display_user_name": '#string',
    "user_id": '#number'
  }
 """
 * match decryptedResponse.selectedUsers == '#[]'

# Negative scenarios
 Scenario: 400 - Bad Request
  * def requestBody =
   """
   {
    "repor22": "Test"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)
  Given path '/report-service/v3/custom-reports/get-user-information'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method POST
  Then status 400

 Scenario: 405 - method not found
  * def requestBody =
   """
   {
    "reportId": 3
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)
  Given path '/report-service/v3/custom-reports/get-user-information'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method get
  Then status 405

 Scenario: 404 - Incorrect URL
  * def requestBody =
   """
   {
    "reportId": 3
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)
  Given path '/report-service/v2/custom-reports/get-user-informationeeee'
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
    "reportId": 3
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)
  Given path '/report-service/v3/custom-reports/get-user-information'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method POST
  Then status 401

 Scenario: 415 - Unsupported Media Type
  Given path '/report-service/v3/custom-reports/get-user-information'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'false'
  And header Content-Type = 'application/x-www-form-urlencoded'
  And request ''
  When method POST
  Then status 415