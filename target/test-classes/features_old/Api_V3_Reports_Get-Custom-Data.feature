Feature: Test Api end point - /v3/reports/get-custom-data

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  #* call read('classpath:features/Set-Client_For_Api_End_Points.feature')


 Scenario: Positive Flow
 * def requestBody =
       """
   {
     "tableName": "vw_patient",
     "columns": "address_1,city,date_of_birth,address_2",
     "conditions": "string",
     "isUnique": false,
     "type": "SAMPLE",
     "collectionType": "create"
   }
       """
 Given path '/v3/reports/get-custom-data'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
