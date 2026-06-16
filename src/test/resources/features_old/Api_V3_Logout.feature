Feature: Test Api End Point - /v3/logout

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')

Scenario: Positive Flow
  Given path '/v3/logout'
  And header Authorization = 'Bearer ' + mainToken
  And header Content-Type = 'application/json'
  * def requestBody = '"Logout"'
  And request requestBody
  When method post
  Then status 200
  And match response.message == 'You have successfully logged out.'
  * print response
  * match response == { message: 'You have successfully logged out.' }



Scenario: Logout without Authorization header
  Given path '/v3/logout'
  And header Content-Type = 'application/json'
  * def requestBody = '"Logout"'
  And request requestBody
  When method post
  Then status 401

