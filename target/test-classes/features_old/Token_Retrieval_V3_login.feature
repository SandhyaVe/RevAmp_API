Feature: Token Retrieval

Background:
  * url 'https://apiqa.revamprcm.com'
  * def requestBody =
  """
  {
    "email": "Vuser_1@veehealthtek.com"
  }
  """
 Scenario: Positive Flow
 Given path '/auth-service/v3/login'
 And  request requestBody
 When method post
 Then status 200
 * print response
 * def temToken = response