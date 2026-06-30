Feature: Test Api end point - /v1/work-queue-engine/columns

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * call read('classpath:features/Set-Client_For_Api_End_Points.feature')



 Scenario: Positive Flow - Account Search Tab
 * def requestBody =
       """
      {
        "pageId": 15
      }
       """
 Given path '/v1/work-queue-engine/columns'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
 * match response.message == 'Column configuration retrieved successfully.'



 Scenario: Positive Flow - Workqueue Summary Tab
  * def requestBody =
        """
       {
         "pageId": 4
       }
        """
  Given path '/v1/work-queue-engine/columns'
  And header Authorization = 'Bearer ' + mainToken
  And request requestBody
  When method post
  Then status 200
  * print response
  * match response.message == 'Column configuration retrieved successfully.'



  Scenario: Positive Flow - Workqueue Rule Engine Tab
    * def requestBody =
          """
         {
           "pageId": 13
         }
          """
    Given path '/v1/work-queue-engine/columns'
    And header Authorization = 'Bearer ' + mainToken
    And request requestBody
    When method post
    Then status 200
    * print response
    * match response.message == 'Column configuration retrieved successfully.'



   Scenario: Positive Flow - My Task Tab
     * def requestBody =
           """
          {
            "pageId": 2
          }
           """
     Given path '/v1/work-queue-engine/columns'
     And header Authorization = 'Bearer ' + mainToken
     And request requestBody
     When method post
     Then status 200
     * print response
     * match response.message == 'Column configuration retrieved successfully.'



    Scenario: Positive Flow - Report Tab
         * def requestBody =
               """
              {
                "pageId": 14
              }
               """
      Given path '/v1/work-queue-engine/columns'
      And header Authorization = 'Bearer ' + mainToken
      And request requestBody
      When method post
      Then status 200
      * print response
      * match response.message == 'Column configuration retrieved successfully.'




     Scenario: Positive Flow - Production Report Tab
          * def requestBody =
             """
           {
              "pageId": 12
            }
             """
        Given path '/v1/work-queue-engine/columns'
        And header Authorization = 'Bearer ' + mainToken
        And request requestBody
        When method post
        Then status 200
        * print response
        * match response.message == 'Column configuration retrieved successfully.'