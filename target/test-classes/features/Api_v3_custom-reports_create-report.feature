Feature: Test Api End Point - /v3/custom-reports/create-report

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
  "collectionId":233,
  "reportName":"#(uniqueReportName)",
  "reportDescriptions":"#(uniqueReportName)_C",
  "statement":"SELECT",
  "condition":"",
  "groupBy":"",
  "tableName":"vw_patient",
  "fieldId":"175,176,177,178,179,193,191,192"
 }
 """
 * string requestBodyStr = karate.toJson(requestBody)
 * def encryptedBody = crypto.encrypt(requestBodyStr)

 Given path '/report-service/v3/custom-reports/create-report'
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

 * match decryptedResponse.reportId == '#number'
 * match decryptedResponse.message == '#regex Custom report created successfully\\.'

# Negative scenarios
 Scenario: 400 - Bad Request
  # generate timestamp and random numer for unique reportname
  * def now = new java.text.SimpleDateFormat("ddMMyyyy_HHmmss").format(new java.util.Date())
  * def randomNum = Math.floor(Math.random() * 10000)
  * def uniqueReportName = 'report3_' + now + '_' + randomNum

  * def requestBody =
   """
   {
    "collectionId":233,
    "reportName":"#(uniqueReportName)",
    "reportDescriptions":"#(uniqueReportName)_C",
    "statement":"SELECT",
    "condition":"",
    "groupBy":"",
    "tableNameeeee": 2233
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v3/custom-reports/create-report'
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
    "collectionId":233,
    "reportName":"#(uniqueReportName)",
    "reportDescriptions":"#(uniqueReportName)_C",
    "statement":"SELECT",
    "condition":"",
    "groupBy":"",
    "tableName":"vw_patient",
    "fieldId":"175,176,177,178,179,193,191,192"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v3/custom-reports/create-report'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method GET
  Then status 405

 Scenario: 404 - Incorrect URL
  # generate timestamp and random numer for unique reportname
  * def now = new java.text.SimpleDateFormat("ddMMyyyy_HHmmss").format(new java.util.Date())
  * def randomNum = Math.floor(Math.random() * 10000)
  * def uniqueReportName = 'report3_' + now + '_' + randomNum

  * def requestBody =
   """
   {
    "collectionId":233,
    "reportName":"#(uniqueReportName)",
    "reportDescriptions":"#(uniqueReportName)_C",
    "statement":"SELECT",
    "condition":"",
    "groupBy":"",
    "tableName":"vw_patient",
    "fieldId":"175,176,177,178,179,193,191,192"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v2/custom-reports/create-report22211'
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
    "collectionId":233,
    "reportName":"#(uniqueReportName)",
    "reportDescriptions":"#(uniqueReportName)_C",
    "statement":"SELECT",
    "condition":"",
    "groupBy":"",
    "tableName":"vw_patient",
    "fieldId":"175,176,177,178,179,193,191,192"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v3/custom-reports/create-report'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 401

 Scenario: 415 - Unsupported Media Type
  Given path '/report-service/v3/custom-reports/create-report'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'false'
  And header Content-Type = 'application/x-www-form-urlencoded'
  And request ''
  When method post
  Then status 415