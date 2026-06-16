Feature: Test Api end point - /v1/custom-reports/check-duplicate-collection

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  #* call read('classpath:features/Set-Client_For_Api_End_Points.feature')


 Scenario: Positive Flow
 * def requestBody =
       """
      {
        "collectionName": "API Report"
      }
       """
 Given path '/v1/custom-reports/check-duplicate-collection'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
 * match response.isDuplicate == true

 Scenario: Negative Flow - With wrong collection name
 * def requestBody =
        """
       {
         "collectionName": "Wrong Report"
       }
        """
  Given path '/v1/custom-reports/check-duplicate-collection'
  And header Authorization = 'Bearer ' + mainToken
  And request requestBody
  When method post
  Then status 200
  * print response
  * match response.isDuplicate == false


  Scenario: Negative Flow - With empty request
   * def requestBody =
          """
         {
           "collectionName": ""
         }
          """
    Given path '/v1/custom-reports/check-duplicate-collection'
    And header Authorization = 'Bearer ' + mainToken
    And request requestBody
    When method post
    Then status 400
    * print response


   Scenario: Negative Flow - Without request body
      * def requestBody =
                """

                """
       Given path '/v1/custom-reports/check-duplicate-collection'
       And header Authorization = 'Bearer ' + mainToken
       And request requestBody
       When method post
       Then status 411
       * print response



