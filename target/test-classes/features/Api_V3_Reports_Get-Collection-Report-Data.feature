Feature: Test Api end point - /v3/reports/get-collection-report-data

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  #* call read('classpath:features/Set-Client_For_Api_End_Points.feature')



 Scenario: Positive Flow - Fetch Custom Report
     Given path '/v3/reports/get-collection-report-data'
     And header Authorization = 'Bearer ' + mainToken
     And param type = 'Custom'
     When method get
     Then status 200
     * print response


 Scenario: Positive Flow - Fetch Custom Report
      Given path '/v3/reports/get-collection-report-data'
      And header Authorization = 'Bearer ' + mainToken
      And param type = 'Standard'
      When method get
      Then status 200
      * print response
