Feature: Test Api end point - /v3/layout/current-client

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')



 Scenario: Positive Flow
 Given path '/v3/layout/current-client'
 And header Authorization = 'Bearer ' + mainToken
 When method get
 Then status 200
 * print response
 * match response contains { clientData: '#object' }



 Scenario: Negative Flow - Without Authorization header
    Given path '/v3/layout/current-client'
    When method get
    Then status 401
    * print response


  Scenario: Negative Flow - Invalid request type
  Given path '/v3/layout/current-client'
  And header Authorization = 'Bearer ' + mainToken
  When method post
  Then status 411
  * print response
