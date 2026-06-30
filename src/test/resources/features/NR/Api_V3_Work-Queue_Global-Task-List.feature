Feature: Test Api end point - /v3/work-queue/global-task-list

Background:
  * url 'https://apiqa.revamprcm.com'
  * def mainToken = karate.get('authToken')
  * call read('classpath:features/Set-Client_For_Api_End_Points.feature')



 Scenario: Positive Flow
 * def requestBody =
       """
       {
         "workQueueId":1406,
         "PageId": 5
       }
       """
 Given path '/v3/work-queue/global-task-list'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
 * match response contains { taskListDetails: '#[]' }

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
    table_name: 'vw_ods_work_queue_monitor',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig contains
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

  * match response.fieldConfig contains
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
    table_name: 'vw_ods_work_queue_monitor',
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
    table_name: 'vw_ods_work_queue_monitor',
    is_visible: '#boolean'
  }
  """

  * match response.fieldConfig contains
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

  * match response.fieldConfig contains
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

    * match response.fieldConfig contains
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


     * match response.fieldConfig contains
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
