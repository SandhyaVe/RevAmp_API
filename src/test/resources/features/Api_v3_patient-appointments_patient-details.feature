Feature: Test Api End Point - v3/patient-appointments/patient-details

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
  "workQueueId":1404,
  "modeId":1,
  "taskListId":17376,
  "status":"INPROGRESS",
  "page":"",
  "accountSearchAppointmentId":70936
 }
 """
 * string requestBodyStr = karate.toJson(requestBody)
 * def encryptedBody = crypto.encrypt(requestBodyStr)

 Given path '/evbv-service/v3/patient-appointments/patient-details'
 And header Cookie = 'auth_token=' + authCookie
 And header X-ECDH-Session = ecdhSessionId
 And header X-Encrypted-Payload = 'true'
 And header Content-Type = 'text/plain'
 And request encryptedBody
 When method post
 Then status 200
 * def decryptedResponseStr = crypto.decrypt(response)
 * print 'Decrypted Response:', decryptedResponseStr

 * def decryptedResponse = JSON.parse(decryptedResponseStr)
 * print decryptedResponse

 # Response Validation
 * match decryptedResponse ==
 """
 {
  "appointmentDetails": '##string',
  "userData": '##string',
  "authData": '##string',
  "qaData": '##string',
  "summaryLog": '##string',
  "errorMessage": '##string'
 }
 """

# Negative scenarios
 Scenario: 400 - Bad Request
  * def requestBody =
   """
   {
    "workQueueIdrrrr":"test"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/evbv-service/v3/patient-appointments/patient-details'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 400

 Scenario: 405 - method not found
  * def requestBody =
   """
   {
    "workQueueId":1404,
    "modeId":1,
    "taskListId":17376,
    "status":"INPROGRESS",
    "page":"",
    "accountSearchAppointmentId":70936
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/evbv-service/v3/patient-appointments/patient-details'
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
    "workQueueId":1404,
    "modeId":1,
    "taskListId":17376,
    "status":"INPROGRESS",
    "page":"",
    "accountSearchAppointmentId":70936
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/evbv-service/v2/patient-appointments/patient-detailsssss'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 404

 Scenario: 401 - Unauthorized
  * def requestBody =
   """
   {
    "workQueueId":1404,
    "modeId":1,
    "taskListId":17376,
    "status":"INPROGRESS",
    "page":"",
    "accountSearchAppointmentId":70936
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/evbv-service/v3/patient-appointments/patient-details'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 401

 Scenario: 415 - Unsupported Media Type
  Given path '/evbv-service/v3/patient-appointments/patient-details'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'false'
  And header Content-Type = 'application/x-www-form-urlencoded'
  And request ''
  When method post
  Then status 415