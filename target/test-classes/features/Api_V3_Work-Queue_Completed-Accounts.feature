Feature: Test Api end point - /v3/work-queue/completed-accounts

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * call read('classpath:features/Set-Client_For_Api_End_Points.feature')


 Scenario: Positive Flow
  * def requestBody =
      """
      {
        "pageId": 10
      }
      """
 Given path '/v3/work-queue/completed-accounts'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response

 * match response.accountsData == '#[]' || response.accountsData.length > 0

 * match response.fieldConfig[0] ==
  """
  {
    field_name: 'appointment_id',
    display_name: 'Appointment Id',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_completed_accounts',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig[1] ==
  """
  {
    field_name: 'workqueue_name',
    display_name: 'Work Queue Name',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_completed_accounts',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig[2] ==
  """
  {
    field_name: 'patient_account_number',
    display_name: 'Patient Account Number',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_completed_accounts',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig[3] ==
  """
  {
    field_name: 'patient_full_name',
    display_name: 'Patient Full Name',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_completed_accounts',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig[4] ==
  """
  {
    field_name: 'appointment_created_date',
    display_name: 'Appointment Created Date',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_completed_accounts',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig[5] ==
  """
  {
    field_name: 'status',
    display_name: 'Status',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_completed_accounts',
    is_visible: '#boolean'
  }
  """



   Scenario: Negative Flow - Request with non existent id

      * def requestBody =
            """
            {
              "pageId": 100
            }
            """
       Given path '/v3/work-queue/completed-accounts'
       And header Authorization = 'Bearer ' + mainToken
       And request requestBody
       When method post
       Then status 400
       * print response
       * match response == 'No in-progress accounts data found.'




       Scenario: Negative Flow - Missing pageId
         * def requestBody =
          """
            {
              "pageId": null
            }
          """
         Given path '/v3/work-queue/completed-accounts'
         And header Authorization = 'Bearer ' + mainToken
         And request requestBody
         When method post
         Then status 400
         * match response.title == 'One or more validation errors occurred.'



         Scenario: Negative Flow - Missing Authorization header
           * def requestBody =
             """
             { "pageId": 10 }
             """
           Given path '/v3/work-queue/completed-accounts'
           And request requestBody
           When method post
           Then status 401





          Scenario: Negative Flow - Empty request body
            * def requestBody = {}
            Given path '/v3/work-queue/completed-accounts'
            And header Authorization = 'Bearer ' + mainToken
            And request requestBody
            When method post
            Then status 400
            * print response
            * match response == 'Valid page ID is required.'







