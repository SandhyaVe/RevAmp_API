Feature: Test Api end point - /v3/work-queue/reworks-accounts

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * call read('classpath:features/Set-Client_For_Api_End_Points.feature')


 Scenario: Positive Flow
  * def requestBody =
      """
      {
        "pageId": 11
      }
      """
 Given path '/v3/work-queue/reworks-accounts'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response

 * match response.accountsData == '#[]' || response.accountsData.length > 0

 * match response.fieldConfig[0] ==
   """
   {
     field_name: 'evbv_tasklist_id',
     display_name: 'Evbv Tasklist Id',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[1] ==
   """
   {
     field_name: 'is_display_auth_fields',
     display_name: 'Is Display Auth Fields',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[2] ==
   """
   {
     field_name: 'is_display_evbv_fields',
     display_name: 'Is Display Evbv Fields',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[3] ==
   """
   {
     field_name: 'is_display_qa_fields',
     display_name: 'Is Display Qa Fields',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[4] ==
   """
   {
     field_name: 'is_lock',
     display_name: 'Is Lock',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[5] ==
   """
   {
     field_name: 'page_url',
     display_name: 'Page Url',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[6] ==
   """
   {
     field_name: 'action',
     display_name: 'Action',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[7] ==
   """
   {
     field_name: 'status',
     display_name: 'Status',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[8] ==
   """
   {
     field_name: 'workqueue_id',
     display_name: 'Work Queue Id',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[9] ==
   """
   {
     field_name: 'appointment_id',
     display_name: 'Appointment Id',
     order: '#number',
     sortable: '#boolean',
     filterable: '#boolean',
     minWidth: '#number',
     custom_fields: '#number',
     table_name: 'vw_ods_work_queue_monitor',
     is_visible: '#boolean'
   }
   """

   * match response.fieldConfig[10] ==
     """
     {
       field_name: 'workqueue_name',
       display_name: 'Work Queue Name',
       order: '#number',
       sortable: '#boolean',
       filterable: '#boolean',
       minWidth: '#number',
       custom_fields: '#number',
       table_name: 'vw_ods_work_queue_monitor',
       is_visible: '#boolean'
     }
     """

     * match response.fieldConfig[11] ==
       """
       {
         field_name: 'patient_account_number',
         display_name: 'Patient Account Number',
         order: '#number',
         sortable: '#boolean',
         filterable: '#boolean',
         minWidth: '#number',
         custom_fields: '#number',
         table_name: 'vw_ods_work_queue_monitor',
         is_visible: '#boolean'
       }
       """

       * match response.fieldConfig[12] ==
         """
         {
           field_name: 'patient_full_name',
           display_name: 'Patient Full Name',
           order: '#number',
           sortable: '#boolean',
           filterable: '#boolean',
           minWidth: '#number',
           custom_fields: '#number',
           table_name: 'vw_ods_work_queue_monitor',
           is_visible: '#boolean'
         }
         """

        * match response.fieldConfig[13] ==
                """
                {
                  field_name: 'appointment_created_date',
                  display_name: 'Appointment Created Date',
                  order: '#number',
                  sortable: '#boolean',
                  filterable: '#boolean',
                  minWidth: '#number',
                  custom_fields: '#number',
                  table_name: 'vw_ods_work_queue_monitor',
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
       Given path '/v3/work-queue/reworks-accounts'
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
         Given path '/v3/work-queue/reworks-accounts'
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
           Given path '/v3/work-queue/reworks-accounts'
           And request requestBody
           When method post
           Then status 401





          Scenario: Negative Flow - Empty request body
            * def requestBody = {}
            Given path '/v3/work-queue/reworks-accounts'
            And header Authorization = 'Bearer ' + mainToken
            And request requestBody
            When method post
            Then status 400
            * print response
            * match response == 'Valid page ID is required.'







