Feature: Test Api end point - /v3/users/permissions

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * def requestBody =
  """
  {
    "userId": 31
  }

  """

Scenario: Positive Flow
  Given path 'v3/users/permissions'
  And header Authorization = 'Bearer ' + mainToken
  And request requestBody
  When method post
  Then status 200
  * print response
  * match response contains { permissions: '#[]' }



Scenario: Negative Flow - Missing userId field in request body
  * def requestBody = {}
  Given path 'v3/users/permissions'
  And header Authorization = 'Bearer ' + mainToken
  And request requestBody
  When method post
  Then status 400
  * print response
  * match response == 'Invalid user ID provided.'

 Scenario: Negative Flow - Empty userId in request body
   * def requestBody =
   """
   {
     "userId": ""
   }
   """
   Given path 'v3/users/permissions'
   And header Authorization = 'Bearer ' + mainToken
   And request requestBody
   When method post
   Then status 400
   * print response
   * match response.title == 'One or more validation errors occurred.'



   Scenario: Negative Flow - Missing Authorization header
     Given path 'v3/users/permissions'
     And request requestBody
     When method post
     Then status 401
     * print response



   Scenario: Negative Flow - Non existent userId
     * def requestBody =
     """
     {
       "userId": 9999
     }
     """
     Given path 'v3/users/permissions'
     And header Authorization = 'Bearer ' + mainToken
     And request requestBody
     When method post
     Then status 400
     * match response == 'No permissions or landing page data found for this user.'