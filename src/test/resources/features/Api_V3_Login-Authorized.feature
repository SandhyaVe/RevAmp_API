Feature: Test Api End Point - /V3/login-authorized

  Background:
    * url gatewayBaseUrl
    * def ecdhSessionId = karate.get('ecdhSessionId')
    # Call the first login feature to get the temp token
    * def loginResult = call read('classpath:features/Api_V3_Login.feature')
    * def loginDecrypted = loginResult.responseReturned
    * print 'Login Decrypted:', loginDecrypted
    * json loginJson = loginDecrypted
    * def tempToken = loginJson.tempToken
    * print 'Temp Token:', tempToken

  Scenario: Positive Flow
    * def requestJson = {"email":"Vuser_2@veehealthtek.com","tempToken":"#(tempToken)"}
    * print 'Login-Authorized Request JSON:', requestJson
    Given path '/auth-service/v3/login-authorized'
    And header Authorization = 'Bearer ' + tempToken
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'application/json'
    And request requestJson
    When method post
    Then status 200
    * print 'Login-Authorized Response:', response
    * match response ==
      """
      {
        "redirectUrl": "#string",
        "hostname": "#string"
      }
      """

  #  Negative Flows -> 400, 405, 404, 401, 415
  Scenario: Negative Flow - 400 bad req
    * def requestJson = {"email":"","tempToken":"#(tempToken)"}
    * print 'Login-Authorized Request JSON:', requestJson
    Given path '/auth-service/v3/login-authorized'
    And header Authorization = 'Bearer ' + tempToken
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'application/json'
    And request requestJson
    When method post
    Then status 400
    * print 'Login-Authorized Response:', response

  Scenario: 405 - method not found
    * def requestJson = {"email":"Vuser_2@veehealthtek.com","tempToken":"#(tempToken)"}
    * print 'Login-Authorized Request JSON:', requestJson
    Given path '/auth-service/v3/login-authorized'
    And header Authorization = 'Bearer ' + tempToken
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'application/json'
    And request requestJson
    When method GET
    Then status 405
    * print 'Login-Authorized Response:', response

  Scenario: 404 - incorrect url
    * def requestJson = {"email":"Vuser_2@veehealthtek.com","tempToken":"#(tempToken)"}
    * print 'Login-Authorized Request JSON:', requestJson
    Given path '/auth-service/v2/login-authorizeddddd'
    And header Authorization = 'Bearer ' + tempToken
#    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'application/json'
    And request requestJson
    When method post
    Then status 404
    * print 'Login-Authorized Response:', response

#  Scenario: 401 - Unauthorized
#    * def requestJson = {"email":"Vuser_1@veehealthtek.com","tempToken":"#(tempToken)"}
#    * print 'Login-Authorized Request JSON:', requestJson
#    Given path '/auth-service/v3/login-authorized'
#    # And header Authorization = 'Bearer ' + tempToken
#    And header X-ECDH-Session = ecdhSessionId
#    And header Content-Type = 'application/json'
#    And request requestJson
#    When method post
#    Then status 401

  Scenario: 415 - unsupported
    Given path '/auth-service/v3/login-authorized'
    And header Authorization = 'Bearer ' + tempToken
    And header X-ECDH-Session = ecdhSessionId
    And header Content-Type = 'application/x-www-form-urlencoded'
    And request ''
    When method post
    Then status 415
    * print response
