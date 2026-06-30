Feature: Test Api End Point - /v3/work-queue/open-work-queue

 Background:
  * url gatewayBaseUrl
  * def crypto = karate.get('crypto')
  * def ecdhSessionId = karate.get('ecdhSessionId')
  * def authCookie = karate.get('authCookie')
  * if (authCookie == null || authCookie == '') karate.fail('authCookie is null/empty. Check target/token-extractor-debug.log and the Karate log line AUTH_COOKIE_MISSING.')
  * def authCookiePreview = authCookie.substring(0, 12) + '...' + authCookie.substring(authCookie.length - 8)
  * print 'Using auth_token cookie:', authCookiePreview, 'length:', authCookie.length

 Scenario: Positive Flow
  * def requestBody =
 """
 {
  "pageId":3
 }
 """
 * string requestBodyStr = karate.toJson(requestBody)
 * def encryptedBody = crypto.encrypt(requestBodyStr)

 Given path '/work-queue-service/v3/work-queue/open-work-queue'
 And header Cookie = 'auth_token=' + authCookie
 And header X-ECDH-Session = ecdhSessionId
 And header X-Encrypted-Payload = 'true'
 And header Content-Type = 'text/plain'
 And request encryptedBody
 When method post
 Then status 200
 * def decryptedResponseStr = crypto.decrypt(response)
 * print 'Decrypted Response:', decryptedResponseStr

 * def decryptedResponse = JSON.parse(decryptedResponseStr)
 * print decryptedResponse

 * match decryptedResponse.taskCounts ==
  """
  {
    Open: '#number',
    Completed: '#number',
    Audited: '#number',
    "Accuracy %": '#number'
  }
  """

  * match decryptedResponse.workqueueData == '#[]'
  * match each decryptedResponse.workqueueData ==
   """
   {
    "row_number": '#number',
    "action": '#string',
    "is_display_auth_fields": '#boolean',
    "is_display_evbv_fields": '#boolean',
    "is_display_qa_fields": '#boolean',
    "page_url": '#string',
    "preference": '#string',
    "workqueue_id": '#number',
    "workqueue_priority": '#string',
    "workqueue_name": '#string',
    "open_accounts": '#number'
   }
   """

  * match decryptedResponse.fieldConfig == '#[]'
  * match each decryptedResponse.fieldConfig ==
   """
   {
    "field_name": '#string',
    "display_name": '#string',
    "order": '#number',
    "sortable": '#boolean',
    "filterable": '#boolean',
    "minWidth": '#number',
    "custom_fields": '#number',
    "table_name": '#string',
    "is_visible": '#boolean'
   }
   """

# Negative scenarios
 Scenario: 400 - Bad Request
  * def requestBody =
   """
   {
    "pag111": "test"
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/work-queue-service/v3/work-queue/open-work-queue'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 400

 Scenario: 405 - method not found
  * def requestBody =
   """
   {
    "pageId":3
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/work-queue-service/v3/work-queue/open-work-queue'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'application/unknown'
  And request encryptedBody
  When method GET
  Then status 405

  Scenario: 404 - Incorrect URL
   * def requestBody =
   """
   {
    "pageId":3
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/work-queue-service/v2/work-queue/open-work-queueeeee'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 404

 Scenario: 401 - Unauthorized
  * def requestBody =
   """
   {
    "pageId":3
   }
   """
  * string requestBodyStr = karate.toJson(requestBody)
  * def encryptedBody = crypto.encrypt(requestBodyStr)

  Given path '/work-queue-service/v3/work-queue/open-work-queue'
#  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'true'
  And header Content-Type = 'text/plain'
  And request encryptedBody
  When method post
  Then status 401

 Scenario: 415 - Unsupported Media Type
  Given path '/work-queue-service/v3/work-queue/open-work-queue'
  And header Cookie = 'auth_token=' + authCookie
  And header X-ECDH-Session = ecdhSessionId
  And header X-Encrypted-Payload = 'false'
  And header Content-Type = 'application/x-www-form-urlencoded'
  And request ''
  When method post
  Then status 415
  * print response