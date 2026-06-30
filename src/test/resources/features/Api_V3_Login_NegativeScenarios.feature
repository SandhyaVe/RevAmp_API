Feature: Test Api End Point - /V3/login

Background:
  * url gatewayBaseUrl
  * def ecdhSessionId = karate.get('ecdhSessionId')

# We should include these negative scenarios in a seperate feature file, otherwise script will fail as this response is utilised in "Api_V3_Login-Authorized.feature" file Working
# Negative Flows
# 401 Unauthorized -> this is not a valid scenario because it is just a login, here we don't send authentication details as we get auth details after login

#  Negative Flows -> 405, 404, 415, 400
 Scenario: Negative Flow - 405 Method not found
  * def requestTemplate = {"email": "Vuser_2@veehealthtek.com"}
  Given path '/auth-service/v3/login'
  And header Content-Type = 'application/json'
  And request requestTemplate
  When method GET
  Then status 405
  * print response

 Scenario: Negative Flow - 404 Incorrect url
  * def requestTemplate = {"email": "Vuser_2@veehealthtek.com"}
  Given path '/auth-service/v2/loginnn'
  And header Content-Type = 'application/json'
  And request requestTemplate
  When method POST
  Then status 404
  * print response

 Scenario: Negative Flow - 415 Unsupported file format
  Given path '/auth-service/v3/login'
  And header Content-Type = 'application/x-www-form-urlencoded'
  And request ''
  When method POST
  Then status 415
  * print response

  Scenario: Negative Flow - 400 bad req
   * def requestTemplate = {"email":""}
   Given path '/auth-service/v3/login'
   And header Content-Type = 'application/json'
   And request requestTemplate
   When method post
   Then status 400
   * print 'Response: ', response
