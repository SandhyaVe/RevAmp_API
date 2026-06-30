Feature: Test Api End Point - /v3/work-queue/assign-task

 Background:
  * url gatewayBaseUrl
  * def crypto = karate.get('crypto')
  * def ecdhSessionId = karate.get('ecdhSessionId')
  * def authCookie = karate.get('authCookie')
  * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
  * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
  * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

 Scenario: Positive Flow
 # generate timestamp and random numer for unique reportname
 * def now = new java.text.SimpleDateFormat("ddMMyyyy_HHmmss").format(new java.util.Date())
 * def randomNum = Math.floor(Math.random() * 10000)
 * def uniqueReportName = 'report3_' + now + '_' + randomNum

  * def requestBody =
  """
  {
   "taskListId":2186,
   "userId":43
  }
  """
 * string requestBodyStr = karate.toJson(requestBody)
 * def encryptedBody = crypto.encrypt(requestBodyStr)

 Given path '/work-queue-service/v3/work-queue/assign-task'
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

 * match decryptedResponse.message == '#regex Task assigned successfully\\.'

# Negative scenarios
 Scenario: 400 - Bad Request
  # generate timestamp and random numer for unique reportname
  * def now = new java.text.SimpleDateFormat("ddMMyyyy_HHmmss").format(new java.util.Date())
  * def randomNum = Math.floor(Math.random() * 10000)
  * def uniqueReportName = 'report3_' + now + '_' + randomNum

  * def requestBody =
   """
   {
    "useeeee":"test"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/work-queue-service/v3/work-queue/assign-task'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 400

 Scenario: 405 - method not found
  # generate timestamp and random numer for unique reportname
  * def now = new java.text.SimpleDateFormat("ddMMyyyy_HHmmss").format(new java.util.Date())
  * def randomNum = Math.floor(Math.random() * 10000)
  * def uniqueReportName = 'report3_' + now + '_' + randomNum

  * def requestBody =
   """
   {
    "taskListId":2186,
    "userId":43
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/work-queue-service/v3/work-queue/assign-task'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method get
  Then status 405


 Scenario: 404 - Incorrect URL
  # generate timestamp and random numer for unique reportname
  * def now = new java.text.SimpleDateFormat("ddMMyyyy_HHmmss").format(new java.util.Date())
  * def randomNum = Math.floor(Math.random() * 10000)
  * def uniqueReportName = 'report3_' + now + '_' + randomNum

  * def requestBody =
   """
   {
    "taskListId":2186,
    "userId":43
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/work-queue-service/v2/work-queue/assign-taskrrr'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 404


 Scenario: 401 - Unauthorized
  # generate timestamp and random numer for unique reportname
  * def now = new java.text.SimpleDateFormat("ddMMyyyy_HHmmss").format(new java.util.Date())
  * def randomNum = Math.floor(Math.random() * 10000)
  * def uniqueReportName = 'report3_' + now + '_' + randomNum

  * def requestBody =
   """
   {
    "taskListId":2186,
    "userId":43
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/work-queue-service/v3/work-queue/assign-task'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 401

 Scenario: 415 - Unsupported Media Type
  Given path '/work-queue-service/v3/work-queue/assign-task'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'false'
  And header Content-Type = 'application/x-www-form-urlencoded'
  And request ''
  When method post
  Then status 415