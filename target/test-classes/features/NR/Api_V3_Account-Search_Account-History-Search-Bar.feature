Feature: Test Api end point - /v3/account-search/account-history-search-bar

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  #* call read('classpath:features/Set-Client_For_Api_End_Points.feature')



 Scenario: Positive Flow
 * def requestBody =
       """
    {
      "type": "Patient Account Number",
      "value": "1440401xx-xxx"
    }
       """
 Given path '/v3/account-search/account-history-search-bar'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
