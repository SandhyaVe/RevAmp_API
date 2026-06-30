Feature: Test Api end point - /v3/reports/create-report

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  #* call read('classpath:features/Set-Client_For_Api_End_Points.feature')

Scenario: Positive Flow

    * def randomNum = java.lang.String.format('%05d', java.util.concurrent.ThreadLocalRandom.current().nextInt(0, 100000))
    * def requestBody =
    """
    {
      "collectionId": 73,
      "reportName": "",
      "reportDescriptions": "",
      "statement": "SELECT",
      "condition": "",
      "groupBy": "",
      "isUnique": false,
      "tableName": "vw_patient",
      "fieldId": "187"
    }
    """

    * set requestBody.reportName = 'api' + randomNum
    * set requestBody.reportDescriptions = 'API REPORT ' + randomNum

    Given path '/v3/reports/create-report'
    And header Authorization = 'Bearer ' + mainToken
    And request requestBody
    When method post
    Then status 200
    * print response