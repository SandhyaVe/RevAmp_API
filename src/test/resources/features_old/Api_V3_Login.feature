Feature: Test Api End Point - /V3/login

Background:
  * url gatewayBaseUrl
  * def ecdhSessionId = karate.get('ecdhSessionId')

 Scenario: Positive Flow
 * def requestJson = {"email":"Vuser_1@veehealthtek.com"}
 Given path '/auth-service/v3/login'
 And header X-ECDH-Session = ecdhSessionId
 And header Content-Type = 'application/json'
 And request requestJson
 When method post
 Then status 200
 * def decryptedResponse = response
 * print 'Login Response:', decryptedResponse
