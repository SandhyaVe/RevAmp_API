Feature: Test Api end point - /v3/layout/get-page-routes

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')


 Scenario: Positive Flow
 Given path '/v3/layout/get-page-routes'
 And header Authorization = 'Bearer ' + mainToken
 When method get
 Then status 200
 * print response
