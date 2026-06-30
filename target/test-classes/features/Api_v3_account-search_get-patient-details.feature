Feature: Test Api End Point - v3/account-search/get-patient-details

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
  "workQueueId":1401,
  "modeId":1,
  "taskListId":0,
  "status":"OPEN QUEUE","page":""
 }
 """
 * string requestBodyStr = karate.toJson(requestBody)
 * def encryptedBody = crypto.encrypt(requestBodyStr)

 Given path '/v3/account-search/get-patient-details'
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

