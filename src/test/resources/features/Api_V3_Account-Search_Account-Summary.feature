Feature: Test Api end point - /v3/account-search/account-summary

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  #* call read('classpath:features/Set-Client_For_Api_End_Points.feature')



 Scenario: Positive Flow
 * def requestBody =
       """
    {
      "appointmentId": 51284,
       "patientAccountNumber": "1440524xxxxxx-xxx"
    }
       """
 Given path '/v3/account-search/account-summary'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
 * match response contains {accountSummary :'#[]'}
