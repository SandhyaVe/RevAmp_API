Feature: Test Api end point - /v3/patient-appointments/get-field-configuration

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * call read('classpath:features/Set-Client_For_Api_End_Points.feature')



 Scenario: Positive Flow
 Given path '/v3/patient-appointments/get-field-configuration'
 And header Authorization = 'Bearer ' + mainToken
 When method get
 Then status 200
 * print response
 * match response contains { fieldConfig: '#[]' }



  Scenario: Negative Flow - Without Authorization Header
  Given path '/v3/patient-appointments/get-field-configuration'
  And header Authorization = 'Bearer ' + mainToken
  When method get
  Then status 200
  * print response


   Scenario: Negative Flow - With wrong request type
    Given path '/v3/patient-appointments/get-field-configuration'
    And header Authorization = 'Bearer ' + mainToken
    When method get
    Then status 200
    * print response

