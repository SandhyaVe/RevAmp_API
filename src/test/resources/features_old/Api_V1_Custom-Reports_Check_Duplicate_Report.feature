Feature: Test Api end point - /v1/custom-reports/check-duplicate-report

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  #* call read('classpath:features/Set-Client_For_Api_End_Points.feature')


 Scenario: Positive Flow
 * def requestBody =
       """
       {
         "reportName": "api 1"
       }
       """
 Given path '/v1/custom-reports/check-duplicate-report'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
