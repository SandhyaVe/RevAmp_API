Feature: Test Api end point - /v3/reports/insert-collection

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  #* call read('classpath:features/Set-Client_For_Api_End_Points.feature')

Scenario: Positive Flow

    * def randomNum = java.lang.String.format('%05d', java.util.concurrent.ThreadLocalRandom.current().nextInt(0, 100000))
    * def requestBody =
    """
   {
     "collectionName": "",
     "collectionType": "custom",
     "descriptions": "No comments"
   }
    """

    * set requestBody.CollectionName = 'Api Collection' + randomNum


    Given path '/v3/reports/insert-collection'
    And header Authorization = 'Bearer ' + mainToken
    And request requestBody
    When method post
    Then status 200
    * print response
    * match response.message contains 'Collection inserted successfully.'