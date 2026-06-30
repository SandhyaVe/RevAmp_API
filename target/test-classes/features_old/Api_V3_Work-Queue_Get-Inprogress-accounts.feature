Feature: Test Api end point - /v3/work-queue/get-inprogress-accounts

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')


 Scenario: Positive Flow
  * def requestBody =
      """
      {
        "pageId": 9
      }
      """
 Given path '/v3/work-queue/get-inprogress-accounts'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response