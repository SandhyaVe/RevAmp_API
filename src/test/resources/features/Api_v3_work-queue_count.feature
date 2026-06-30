Feature: Test Api End Point - /v3/work-queue/count

 Background:
  * url gatewayBaseUrl
  * def crypto = karate.get('crypto')
  * def ecdhSessionId = karate.get('ecdhSessionId')
  * def authCookie = karate.get('authCookie')
  * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
  * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
  * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

 Scenario: Positive Flow
 Given path '/work-queue-service/v3/work-queue/count'
 And header Cookie = 'auth_token=' + authCookie
 And header X-ECDH-Session = ecdhSessionId
 And header X-Encrypted-Payload = 'true'
 And header Content-Type = 'text/plain'
 When method GET
 Then status 200
 * def decryptedResponseStr = crypto.decrypt(response)
 * print 'Decrypted Response:', decryptedResponseStr

 * def decryptedResponse = JSON.parse(decryptedResponseStr)
 * print decryptedResponse

 # Response validation
 * match decryptedResponse.appointmentCounts == '#[]'
 * match each decryptedResponse.appointmentCounts ==
  """
  {
   client_id: '#number',
   module_id: '#number',
   process_id: '#number',
   client_code: '#string',
   client_name: '#string',
   module_name: '#string',
   module_header: '#string',
   descriptions: '#string',
   task_date: '#regex \\d{2}/\\d{2}/\\d{4}',
   no_of_accounts: '#number',
   status: '#string'
  }
  """

# Negative scenarios
 Scenario: 405 - method not found
  Given path '/work-queue-service/v3/work-queue/count'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  When method POST
  Then status 405

 Scenario: 404 - url incorrect
  Given path '/work-queue-service/v2/work-queue/count222'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  When method GET
  Then status 404

 Scenario: 401 - unauthorized
  Given path '/work-queue-service/v3/work-queue/count'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  When method GET
  Then status 401

