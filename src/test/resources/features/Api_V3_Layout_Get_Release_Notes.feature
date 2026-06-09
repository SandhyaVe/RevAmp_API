Feature: Test Api end point - /v3/layout/get-release-notes
Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * call read('classpath:features/Set-Client_For_Api_End_Points.feature')



 Scenario: Positive Flow
 Given path '/v3/layout/get-release-notes'
 And header Authorization = 'Bearer ' + mainToken
 When method get
 Then status 200
 * print response