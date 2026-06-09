Feature: Test Api end point - /v3/reports/get-tables

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')



 Scenario: Positive Flow
 * def requestBody =
       """
      {}
       """
 Given path '/v3/reports/get-tables'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
