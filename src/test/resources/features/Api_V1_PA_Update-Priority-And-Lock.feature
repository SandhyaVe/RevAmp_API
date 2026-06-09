Feature: Test Api end point - /v1/patient-appointments/update-priority-and-lock

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')



 Scenario: Positive Flow - Lock
 * def requestBody =
       """
      {
        "lockType": "Lock",
        "type": "PREFERENCE",
        "workqueueId": 1406
      }
       """
 Given path '/v1/patient-appointments/update-priority-and-lock'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
 * match response.message == 'Work queue updated successfully.'



 Scenario: Positive Flow - Open
  * def requestBody =
        """
       {
         "lockType": "Open",
         "type": "PREFERENCE",
         "workqueueId": 1406
       }
        """
  Given path '/v1/patient-appointments/update-priority-and-lock'
  And header Authorization = 'Bearer ' + mainToken
  And request requestBody
  When method post
  Then status 200
  * print response
  * match response.message == 'Work queue updated successfully.'