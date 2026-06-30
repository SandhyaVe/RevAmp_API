Feature: Test Api End Point - v3/patient-appointments/insert-user-data

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
 [
  {
   "moduleId":1,
   "processId":1,
   "taskListId":17376,
   "workqueueId":1404,
   "appointmentId":70936,
   "deductibleTotal":null,
   "deductibleRemaining":null,
   "moopTotal":null,
   "moopRemaining":null,
   "coInsurance":null,
   "coPay":null,
   "totalVisits":null,
   "remainingVisits":null,
   "policyNotes":"",
   "otherComments":"",
   "isCalendarYearPlan":false,
   "isRequiresAuthorization":false,
   "yearEndPlan":null,
   "createdBy":0,
   "lastModifiedBy":0,
   "startTime":"2026-06-23T13:35:39.283",
   "environmentId":"",
   "actionIfany":"Do Not verify",
   "individualDd":null,
   "individualDdRem":null,
   "familyDd":null,
   "familyDdRem":null,
   "individualOop":null,
   "individualOopRem":null,
   "familyOop":null,
   "familyOopRem":null,
   "isRequiresPcp":false,
   "hra":"",
   "hraRem":null,
   "nonCoveredCptCodes":"",
   "followUpDate":null,
   "submissionType":"SUBMIT",
   "qmb":"",
   "isUnlimitedVisits":false,
   "ptYear":"",
   "ptThresholdRemaining":null,
   "ptLastVisitDate":null,
   "otYear":"",
   "otThresholdRemaining":null,
   "otLastVisitDate":null,
   "networkType":"In",
   "caseNote":"",
   "oopMet":false,
   "effectiveDate":null,
   "nextVisitScheduledDate":null,
   "veestatId":10517,
   "insuranceType":"S",
   "patientInsuranceId":74130,
   "inventoryTrackingId":24457,
   "modeMasterId":1,
   "originalFileName":[

   ],
   "fileName":[

   ],
   "filePath":[

   ]
  }
 ]
 """
 * string requestBodyStr = karate.toJson(requestBody)
 * def encryptedBody = crypto.encrypt(requestBodyStr)

 Given path '/evbv-service/v3/patient-appointments/insert-user-data'
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

 # Response validation
 * match decryptedResponse.message == '#regex User data inserted successfully\\.'

# Negative scenarios
 Scenario: 400 - Bad Request
  * def requestBody =
   """
   [
    {
     "moduleId22222":"test",
     "originalFileName":[

     ],
     "fileName":[

     ],
     "filePath":[

     ]
    }
   ]
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/evbv-service/v3/patient-appointments/insert-user-data'
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
   [
    {
     "moduleId":1,
     "processId":1,
     "taskListId":17376,
     "workqueueId":1404,
     "appointmentId":70936,
     "deductibleTotal":null,
     "deductibleRemaining":null,
     "moopTotal":null,
     "moopRemaining":null,
     "coInsurance":null,
     "coPay":null,
     "totalVisits":null,
     "remainingVisits":null,
     "policyNotes":"",
     "otherComments":"",
     "isCalendarYearPlan":false,
     "isRequiresAuthorization":false,
     "yearEndPlan":null,
     "createdBy":0,
     "lastModifiedBy":0,
     "startTime":"2026-06-23T13:35:39.283",
     "environmentId":"",
     "actionIfany":"Do Not verify",
     "individualDd":null,
     "individualDdRem":null,
     "familyDd":null,
     "familyDdRem":null,
     "individualOop":null,
     "individualOopRem":null,
     "familyOop":null,
     "familyOopRem":null,
     "isRequiresPcp":false,
     "hra":"",
     "hraRem":null,
     "nonCoveredCptCodes":"",
     "followUpDate":null,
     "submissionType":"SUBMIT",
     "qmb":"",
     "isUnlimitedVisits":false,
     "ptYear":"",
     "ptThresholdRemaining":null,
     "ptLastVisitDate":null,
     "otYear":"",
     "otThresholdRemaining":null,
     "otLastVisitDate":null,
     "networkType":"In",
     "caseNote":"",
     "oopMet":false,
     "effectiveDate":null,
     "nextVisitScheduledDate":null,
     "veestatId":10517,
     "insuranceType":"S",
     "patientInsuranceId":74130,
     "inventoryTrackingId":24457,
     "modeMasterId":1,
     "originalFileName":[

     ],
     "fileName":[

     ],
     "filePath":[

     ]
    }
   ]
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/evbv-service/v3/patient-appointments/insert-user-data'
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
   [
    {
     "moduleId":1,
     "processId":1,
     "taskListId":17376,
     "workqueueId":1404,
     "appointmentId":70936,
     "deductibleTotal":null,
     "deductibleRemaining":null,
     "moopTotal":null,
     "moopRemaining":null,
     "coInsurance":null,
     "coPay":null,
     "totalVisits":null,
     "remainingVisits":null,
     "policyNotes":"",
     "otherComments":"",
     "isCalendarYearPlan":false,
     "isRequiresAuthorization":false,
     "yearEndPlan":null,
     "createdBy":0,
     "lastModifiedBy":0,
     "startTime":"2026-06-23T13:35:39.283",
     "environmentId":"",
     "actionIfany":"Do Not verify",
     "individualDd":null,
     "individualDdRem":null,
     "familyDd":null,
     "familyDdRem":null,
     "individualOop":null,
     "individualOopRem":null,
     "familyOop":null,
     "familyOopRem":null,
     "isRequiresPcp":false,
     "hra":"",
     "hraRem":null,
     "nonCoveredCptCodes":"",
     "followUpDate":null,
     "submissionType":"SUBMIT",
     "qmb":"",
     "isUnlimitedVisits":false,
     "ptYear":"",
     "ptThresholdRemaining":null,
     "ptLastVisitDate":null,
     "otYear":"",
     "otThresholdRemaining":null,
     "otLastVisitDate":null,
     "networkType":"In",
     "caseNote":"",
     "oopMet":false,
     "effectiveDate":null,
     "nextVisitScheduledDate":null,
     "veestatId":10517,
     "insuranceType":"S",
     "patientInsuranceId":74130,
     "inventoryTrackingId":24457,
     "modeMasterId":1,
     "originalFileName":[

     ],
     "fileName":[

     ],
     "filePath":[

     ]
    }
   ]
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/evbv-service/v2/patient-appointments/insert-user-datadddd'
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
   [
    {
     "moduleId":1,
     "processId":1,
     "taskListId":17376,
     "workqueueId":1404,
     "appointmentId":70936,
     "deductibleTotal":null,
     "deductibleRemaining":null,
     "moopTotal":null,
     "moopRemaining":null,
     "coInsurance":null,
     "coPay":null,
     "totalVisits":null,
     "remainingVisits":null,
     "policyNotes":"",
     "otherComments":"",
     "isCalendarYearPlan":false,
     "isRequiresAuthorization":false,
     "yearEndPlan":null,
     "createdBy":0,
     "lastModifiedBy":0,
     "startTime":"2026-06-23T13:35:39.283",
     "environmentId":"",
     "actionIfany":"Do Not verify",
     "individualDd":null,
     "individualDdRem":null,
     "familyDd":null,
     "familyDdRem":null,
     "individualOop":null,
     "individualOopRem":null,
     "familyOop":null,
     "familyOopRem":null,
     "isRequiresPcp":false,
     "hra":"",
     "hraRem":null,
     "nonCoveredCptCodes":"",
     "followUpDate":null,
     "submissionType":"SUBMIT",
     "qmb":"",
     "isUnlimitedVisits":false,
     "ptYear":"",
     "ptThresholdRemaining":null,
     "ptLastVisitDate":null,
     "otYear":"",
     "otThresholdRemaining":null,
     "otLastVisitDate":null,
     "networkType":"In",
     "caseNote":"",
     "oopMet":false,
     "effectiveDate":null,
     "nextVisitScheduledDate":null,
     "veestatId":10517,
     "insuranceType":"S",
     "patientInsuranceId":74130,
     "inventoryTrackingId":24457,
     "modeMasterId":1,
     "originalFileName":[

     ],
     "fileName":[

     ],
     "filePath":[

     ]
    }
   ]
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/evbv-service/v3/patient-appointments/insert-user-data'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 401

 Scenario: 415 - Unsupported Media Type
  Given path '/evbv-service/v3/patient-appointments/insert-user-data'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'false'
  And header Content-Type = 'application/x-www-form-urlencoded'
  And request ''
  When method post
  Then status 415
