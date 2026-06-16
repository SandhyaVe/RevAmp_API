Feature: Test Api End Point - /V3/login-authorized

Background:
  * url gatewayBaseUrl
  * def ecdhSessionId = karate.get('ecdhSessionId')
  # Call the first login feature to get the temp token
  * def loginResult = call read('classpath:features/Api_V3_Login.feature')
  * def loginDecrypted = loginResult.decryptedResponse
  * print 'Login Decrypted:', loginDecrypted
  * json loginJson = loginDecrypted
  * def tempToken = loginJson.tempToken
  * print 'Temp Token:', tempToken

  Scenario: Positive Flow
  * def requestJson = {"email":"Vuser_1@veehealthtek.com","tempToken":"#(tempToken)"}
  * print 'Login-Authorized Request JSON:', requestJson
  Given path '/auth-service/v3/login-authorized'
  And header Authorization = 'Bearer ' + tempToken
  And header X-ECDH-Session = ecdhSessionId
  And header Content-Type = 'application/json'
  And request requestJson
  When method post
  Then status 200
  * print 'Login-Authorized Response:', response
