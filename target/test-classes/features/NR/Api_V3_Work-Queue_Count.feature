Feature: Test Api end point - /v3/work-queue/count

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')



 Scenario: Positive Flow
 Given path '/v3/work-queue/count'
 And header Authorization = 'Bearer ' + mainToken
 When method get
 Then status 200
 * print response
 * match response contains { appointmentCounts: '#[]' }


  Scenario: Negative Flow - With wrong request type
  Given path '/v3/work-queue/count'
  And header Authorization = 'Bearer ' + mainToken
  When method post
  Then status 411
  * print response


   Scenario: Negative Flow - Without Authorization header
   Given path '/v3/work-queue/count'
   When method get
   Then status 401
   * print response