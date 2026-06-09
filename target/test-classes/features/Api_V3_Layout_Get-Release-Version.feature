Feature: Test Api end point - /v3/layout/get-release-version

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * call read('classpath:features/Set-Client_For_Api_End_Points.feature')



 Scenario: Positive Flow
 Given path '/v3/layout/get-release-version'
 And header Authorization = 'Bearer ' + mainToken
 When method get
 Then status 200
 * print response


 Scenario: Negative Flow - With invalid http request type
  Given path '/v3/layout/get-release-version'
  And header Authorization = 'Bearer ' + mainToken
  When method post
  Then status 411
  * print response


Scenario: Negative Flow - Without Authorization Header
  Given path '/v3/layout/get-release-version'
  When method post
  Then status 411
  * print response