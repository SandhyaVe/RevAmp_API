Feature: Testing Api End point - /v3/work-queue/open-work-queue

Background:
 * url 'https://apiqa.revamprcm.com'
 * def mainToken = karate.get('authToken')
 * def requestBody =
   """
  {
    "pageId": 3
  }
   """

 Scenario: Positive Flow
 Given path '/v3/work-queue/open-work-queue'
 And header Authorization = 'Bearer ' + mainToken
 And request requestBody
 When method post
 Then status 200
 * print response
 * match response.taskCounts ==
 """
 {
   Open: '#number',
   Completed: '#number',
   Audited: '#number',
   'Accuracy %': '#number'
 }
 """
 * match response.workqueueData[0] ==
 """
 {
   row_number: '#number',
   action: 'Start',
   is_display_auth_fields: '#boolean',
   is_display_evbv_fields: '#boolean',
   is_display_qa_fields: '#boolean',
   page_url: '/layout/user-entry',
   preference: '#string',
   workqueue_id: '#number',
   workqueue_priority: '#string',
   workqueue_name: '#string',
   open_accounts: '#number',
 }
 """

 * match response.fieldConfig[0] ==
 """
 {
   field_name: 'action',
   display_name: 'Action',
   order: '#number',
   sortable: '#boolean',
   filterable: '#boolean',
   minWidth: '#number',
   custom_fields: '#number',
   table_name: 'vw_ods_open_work_queue',
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
   table_name: 'vw_ods_open_work_queue',
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
   table_name: 'vw_ods_open_work_queue',
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
   table_name: 'vw_ods_open_work_queue',
   is_visible: '#boolean'
 }
 """

 * match response.fieldConfig[4] ==
 """
 {
   field_name: 'page_url',
   display_name: 'Pageurl',
   order: '#number',
   sortable: '#boolean',
   filterable: '#boolean',
   minWidth: '#number',
   custom_fields: '#number',
   table_name: 'vw_ods_open_work_queue',
   is_visible: '#boolean'
 }
 """

 * match response.fieldConfig[5] ==
 """
 {
   field_name: 'preference',
   display_name: 'Preference',
   order: '#number',
   sortable: '#boolean',
   filterable: '#boolean',
   minWidth: '#number',
   custom_fields: '#number',
   table_name: 'vw_ods_open_work_queue',
   is_visible: '#boolean'
 }
 """

 * match response.fieldConfig[6] ==
 """
 {
   field_name: 'workqueue_id',
   display_name: 'Work Queue Id',
   order: '#number',
   sortable: '#boolean',
   filterable: '#boolean',
   minWidth: '#number',
   custom_fields: '#number',
   table_name: 'vw_ods_open_work_queue',
   is_visible: '#boolean'
 }
 """

 * match response.fieldConfig[7] ==
 """
 {
   field_name: 'workqueue_priority',
   display_name: 'Priority',
   order: '#number',
   sortable: '#boolean',
   filterable: '#boolean',
   minWidth: '#number',
   custom_fields: '#number',
   table_name: 'vw_ods_open_work_queue',
   is_visible: '#boolean'
 }
 """

 * match response.fieldConfig[8] ==
 """
 {
   field_name: 'workqueue_name',
   display_name: 'Work Queue Name',
   order: '#number',
   sortable: '#boolean',
   filterable: '#boolean',
   minWidth: '#number',
   custom_fields: '#number',
   table_name: 'vw_ods_open_work_queue',
   is_visible: '#boolean'
 }
 """

 * match response.fieldConfig[9] ==
 """
 {
   field_name: 'open_accounts',
   display_name: 'No Of Acc',
   order: '#number',
   sortable: '#boolean',
   filterable: '#boolean',
   minWidth: '#number',
   custom_fields: '#number',
   table_name: 'vw_ods_open_work_queue',
   is_visible: '#boolean'
 }
 """



