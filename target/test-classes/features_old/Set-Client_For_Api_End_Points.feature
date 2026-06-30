Feature: Test Api end point - /v3/layout/set-client

Background:
 * url 'https://apiqa.revamprcm.com'
 * def mainToken = karate.get('authToken')
 * def requestBody =
   """
  {
    "clientId": 1,
    "moduleId": 1,
    "processId": 1
  }
   """

 Scenario: Positive Flow
 Given path '/v3/layout/set-client'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
 * match response.message == 'Client details set successfully.'