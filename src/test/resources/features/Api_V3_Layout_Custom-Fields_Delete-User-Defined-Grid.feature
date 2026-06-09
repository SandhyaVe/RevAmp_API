Feature: Test Api end point - /v3/layout/custom-fields/delete-user-defined-grid

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')


 Scenario: Positive Flow
  * def requestBody =
        """
        {
          "pageId": 2
        }
        """
  Given path '/v3/layout/custom-fields/delete-user-defined-grid'
  And header Authorization = 'Bearer ' + mainToken
  And request requestBody
  When method post
  Then status 200
  * print response
