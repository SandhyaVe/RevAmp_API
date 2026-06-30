Feature: Test Api end point - /v3/layout/client

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')


 Scenario: Positive Flow
 Given path '/v3/layout/client'
 And header Authorization = 'Bearer ' + mainToken
 When method get
 Then status 200
 * print response
 * match response contains { clients: '#[]' }


  Scenario: Negative Flow - Sent Request using Post method
  Given path '/v3/layout/client'
  And header Authorization = 'Bearer ' + mainToken
  And request {}
  When method post
  Then status 405
  * print response



