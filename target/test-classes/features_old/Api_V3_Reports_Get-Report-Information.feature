Feature: Test Api end point - /v3/reports/get-report-information

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  #* call read('classpath:features/Set-Client_For_Api_End_Points.feature')


 Scenario: Positive Flow
 * def requestBody =
       """
       {
         "reportId": 164
       }
       """
 Given path '/v3/reports/get-report-information'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
