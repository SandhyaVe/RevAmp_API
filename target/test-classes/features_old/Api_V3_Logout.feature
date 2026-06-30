Feature: Test Api End Point - /v3/logout

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')

Scenario: Positive Flow
  * def reqTemplate = "Logout"
  Given path '/auth-service/v3/logout'
  And header Authorization = 'Bearer ' + mainToken
  And header Content-Type = 'application/json'
  * def requestBody = reqTemplate
  And request requestBody
  When method post
  Then status 200
  And match response.message == 'You have successfully logged out.'
  * print response

#Scenario: Logout without Authorization header
#  Given path '/v3/logout'
#  And header Content-Type = 'application/json'
#  * def requestBody = '"Logout"'
#  And request requestBody
#  When method post
#  Then status 401

  # Negative Flows
  Scenario: Negative Flow - 400 bad req
    * def requestJson = {"email":"","tempToken":"#(tempToken)"}
    * print 'Login-Authorized Request JSON:', requestJson
    Given path '/auth-service/v3/logout'
    And header Authorization = 'Bearer ' + tempToken
    And header Content-Type = 'application/json'
    And request requestJson
    When method post
    Then status 400
    * print 'Login-Authorized Response:', response

  Scenario: Negative Flow - 405 Method not found
    * def requestJson = {"email":"Vuser_2@veehealthtek.com","tempToken":"#(tempToken)"}
    * print 'Login-Authorized Request JSON:', requestJson
    Given path '/auth-service/v3/login-authorized'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'text/plain'
    And request requestJson
    When method GET
    Then status 405
    * print response

  Scenario: Negative Flow - 415 unsupported file format
    * def requestTemplate = {"email":"Vuser_2@veehealthtek.com","tempToken":"#(tempToken)"}
    Given path '/auth-service/v3/login-authorized'
    And header Cookie = 'auth_token=' + authCookie
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'text/csv'
    And request requestTemplate
    When method POST
    Then status 415
    * print response

    Scenario: Negative Flow - 401 Unauthorized
      * def requestJson = {"email":"vuser_2@veehealthtek.com","tempToken":"#(tempToken)"}
      * print 'Login-Authorized Request JSON:', requestJson
      Given path '/auth-service/v3/login-authorized'
      #    And header Authorization = 'Bearer ' + tempToken
      And header X-ECDH-Session = ecdhSessionId
      And header Content-Type = 'application/json'
      And request requestJson
      When method post
      Then status 401
      * print 'Login-Authorized Response:', response

    Scenario: Negative Flow - 404 incorrect url
      * def requestTemplate = {"email":"Vuser_2@veehealthtek.com","tempToken":"#(tempToken)"}
      Given path '/auth-service/v2/login-authorized'
      And header Cookie = 'auth_token=' + authCookie
      And header X-ECDH-Session = ecdhSessionId
      And header Content-Type = 'text/plain'
      And request requestTemplate
      When method POST
      Then status 404
      * print response

