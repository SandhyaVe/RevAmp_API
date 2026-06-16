Feature: Test Api end point - /v3/work-queue/workqueue-summary

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * call read('classpath:features/Set-Client_For_Api_End_Points.feature')


 Scenario: Positive Flow
  * def requestBody =
      """
      {
        "pageId": 4
      }
      """
 Given path '/v3/work-queue/workqueue-summary'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
  * match response.taskCounts ==
  """
  {
    Open: '#number',
    Inprogress: '#number',
    Rework: '#number',
    Completed: '#number',
    Audited: '#number',
    'Accuracy %': '#number'
  }
  """

 * match response.workqueueData == '#[]' || response.workqueueData.length > 0

 * match response.fieldConfig contains
  """
  {
    field_name: 'action',
    display_name: 'Action',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_work_queue_summary',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig contains
  """
  {
    field_name: 'preference',
    display_name: 'Preference',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_work_queue_summary',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig contains
  """
  {
    field_name: 'workqueue_id',
    display_name: 'Work Queue Id',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_work_queue_summary',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig contains
  """
  {
    field_name: 'workqueue_name',
    display_name: 'Work Queue Name',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_work_queue_summary',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig contains
  """
  {
    field_name: 'open_accounts',
    display_name: 'Open ',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_work_queue_summary',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig contains
  """
  {
    field_name: 'in_progress_accounts',
    display_name: 'In Progress',
    order: '#number',
    sortable: '#boolean',
    filterable: '#boolean',
    minWidth: '#number',
    custom_fields: '#number',
    table_name: 'vw_ods_work_queue_summary',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig contains
    """
    {
      field_name: 'rework_accounts',
      display_name: 'Rework',
      order: '#number',
      sortable: '#boolean',
      filterable: '#boolean',
      minWidth: '#number',
      custom_fields: '#number',
      table_name: 'vw_ods_work_queue_summary',
      is_visible: '#boolean'
    }
    """

    * match response.fieldConfig contains
      """
      {
        field_name: 'total_accounts',
        display_name: 'Total In Queue',
        order: '#number',
        sortable: '#boolean',
        filterable: '#boolean',
        minWidth: '#number',
        custom_fields: '#number',
        table_name: 'vw_ods_work_queue_summary',
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
       Given path '/v3/work-queue/workqueue-summary'
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
         Given path '/v3/work-queue/workqueue-summary'
         And header Authorization = 'Bearer ' + mainToken
         And request requestBody
         When method post
         Then status 400
         * match response.title == 'One or more validation errors occurred.'



         Scenario: Negative Flow - Missing Authorization header
           * def requestBody =
             """
             { "pageId": 4 }
             """
           Given path '/v3/work-queue/workqueue-summary'
           And request requestBody
           When method post
           Then status 401




          Scenario: Negative Flow - Empty request body
            * def requestBody = {}
            Given path '/v3/work-queue/workqueue-summary'
            And header Authorization = 'Bearer ' + mainToken
            And request requestBody
            When method post
            Then status 400
            * print response
            * match response == 'Valid page ID is required.'







