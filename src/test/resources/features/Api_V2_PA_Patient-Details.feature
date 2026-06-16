Feature: Validating the Api end point openWQ

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * def requestBody =
  """
  {
    "workqueueId": 1406,
    "modeId": 1,
    "taskListId": 0,
    "status": "Open Queue"
  }
  """

Scenario: Post request to set the client
  Given path '/v2/patient-appointments/patient-details'
  And header Authorization = 'Bearer ' + mainToken
  And request requestBody
  When method post
  Then status 200
  * print response
  * def taskListId = response.appointmentDetails.task_list_id
  * def appointmentId = response.appointmentDetails.appointment_id
  * def result = { taskListId: #(taskListId), appointmentId: #(appointmentId) }
  * print 'Returning:', result
  * match result == { taskListId: '#number', appointmentId: '#number' }