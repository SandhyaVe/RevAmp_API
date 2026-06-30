Feature: Test Api End Point - /v3/custom-reports/execute-custom-report

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

 Given path '/report-service/v3/custom-reports/execute-custom-report'
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

  * match decryptedResponse.reportData == '#[]'
  * match each decryptedResponse.reportData ==
   """
   {
    row_number: '#number',
    appointment_id: '#number',
    Patient_Account_Number: '#string',
    Patient_Number: '#string',
    Member_ID: '##string',
    DOB: '#regex \\d{2}\\/\\d{2}\\/\\d{4}',
    Case_Title: '#string',
    Primary_Insurance_Name: '##string',
    Vee_Policy_Notes: '##string',
    Exception_Comments: '##string',
    Case_Notes: '##string',
    Status: '##string',
    Clinic_Name: '#string',
    Patient_Last_Name: '##string',
    User: '#string',
    Email_ID: '#regex ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$',
    Process_Date: '##regex \\d{2}/\\d{2}/\\d{4}',
    Next_Visit_Date: '##regex \\d{2}/\\d{2}/\\d{4}',
    Audited: '#string',
    Audit_Comments: '##string',
    Error: '#string',
    Error_Type: '##string',
    Error_Category: '##string',
    Error_Subcategory: '##string',
    Rework_Required: '##boolean',
    Audit_Date: '##regex \\d{2}/\\d{2}/\\d{4}',
    Auditor_Name: '##string',
    qa_login_email: '##regex ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$',
    feedback_status: '##boolean',
    feedback_date: '##regex \\d{2}/\\d{2}/\\d{4}',
    EMR_Address: '##string',
    PortalAddress: '##string',
    module_name: '#string',
    process_name: '#string',
    inventory_date: '##regex \\d{2}/\\d{2}/\\d{4}'
   }
   """

 Scenario: 400 - Bad Request
  * def requestBody =
   """
   {
    "repor222": "test"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v3/custom-reports/execute-custom-report'
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
    "reportId": 3
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v3/custom-reports/execute-custom-report'
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
    "reportId": 3
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v2/custom-reports/execute-custom-report333'
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
    "reportId": 3
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/report-service/v3/custom-reports/execute-custom-report'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 401

 Scenario: 415 - Unsupported Media Type
  Given path '/report-service/v3/custom-reports/execute-custom-report'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'false'
  And header Content-Type = 'application/x-www-form-urlencoded'
  And request ''
  When method post
  Then status 415