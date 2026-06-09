Feature: Test Api end point - /v3/layout/set-client

Background:
 * url 'https://apiqa.revamprcm.com'
 * def mainToken = karate.get('authToken')
 * def requestBody =
   """
  {
    "clientId": 1,
    "moduleId": 1,
    "processId": 1
  }
   """

 Scenario: Positive Flow
 Given path '/v3/layout/set-client'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
 * match response.message == 'Client details set successfully.'



 Scenario: Negative Flow - Without Authorization header
   Given path '/v3/layout/set-client'
   And request requestBody
   When method post
   Then status 401
   * print response



  Scenario: Negative Flow - Missing request body
    Given path '/v3/layout/set-client'
    And header Authorization = 'Bearer ' + mainToken
    And request {}
    When method post
    Then status 400
    * print response
    * match response == 'Client ID must be a positive integer.'




  Scenario: Negative Flow - Invalid client ID format
    * def requestBody =
    """
    {
      "clientId": abc,
      "moduleId": 1,
      "processId": 1
    }
    """
    Given path '/v3/layout/set-client'
    And header Authorization = 'Bearer ' + mainToken
    And request requestBody
    When method post
    Then status 400
    * print response
    * match response.title == 'One or more validation errors occurred.'



  Scenario: Negative Flow - Non-existent client ID
    * def requestBody =
    """
    {
      "clientId": 99,
      "moduleId": 99,
      "processId": 99
    }
    """
    Given path '/v3/layout/set-client'
    And header Authorization = 'Bearer ' + mainToken
    And request requestBody
    When method post
    Then status 400
    * print response
    * match response == 'Invalid client, module, or process ID, or no client code found.'



   Scenario: Negative Flow - Sent request using GET method
     Given path '/v3/layout/set-client'
     And header Authorization = 'Bearer ' + mainToken
     When method get
     Then status 405
     * print response