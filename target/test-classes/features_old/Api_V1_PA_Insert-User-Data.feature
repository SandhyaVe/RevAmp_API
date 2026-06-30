Feature: Validating the Api end point o insert user data

Background:
 * url 'https://apiqa.revamprcm.com'
 * def mainToken = karate.get('authToken')


  # Call first feature to get dynamic values
  * def appointmentData = call read('classpath:features/Api_V1_PA_Patient-Details.feature')
  * def tasklistid = appointmentData.taskListId
  * def appointmentid = appointmentData.appointmentId

 * def requestBody =
   """
{
  "moduleId": 1,
  "processId": 1,
  "taskListId": #(tasklistid),
  "workqueueId": 1406,
  "appointmentId": #(appointmentid),
  "deductibleTotal": 1,
  "deductibleRemaining": 1,
  "moopTotal": 0,
  "moopRemaining": 0,
  "coInsurance": 0,
  "coPay": 0,
  "totalVisits": 0,
  "remainingVisits": 0,
  "policyNotes": "string",
  "otherComments": "string",
  "isCalendarYearPlan": true,
  "isRequiresAuthorization": true,
  "yearEndPlan": "2025-10-31T13:50:32.252Z",
  "createdBy": 0,
  "lastModifiedBy": 0,
  "startTime": "2025-10-31T13:50:32.253Z",
  "environmentId": "string",
  "submissionType": "Submit",
  "individualDd": 0,
  "individualDdRem": 0,
  "familyDd": 0,
  "familyDdRem": 0,
  "individualOop": 0,
  "individualOopRem": 0,
  "familyOop": 0,
  "familyOopRem": 0,
  "isRequiresPcp": true,
  "hra": "string",
  "hraRem": 0,
  "nonCoveredCptCodes": "string",
  "followUpDate": "2025-10-31T13:50:32.253Z",
  "qmb": "string",
  "actionIfany": "string",
  "isUnlimitedVisits": true,
  "ptYear": "string",
  "ptThresholdRemaining": 0,
  "ptLastVisitDate": "2025-10-31T13:50:32.253Z",
  "otYear": "string",
  "otThresholdRemaining": 0,
  "otLastVisitDate": "2025-10-31T13:50:32.253Z",
  "networkType": "string",
  "caseNote": "string",
  "oopMet": true,
  "effectiveDate": "2025-10-31T13:50:32.253Z",
  "nextVisitScheduledDate": "2025-10-31T13:50:32.253Z"
}
   """
 Scenario: Post request to insert data
 Given path '/v1/patient-appointments/insert-user-data'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response