import com.intuit.karate.junit5.Karate;

class ApiTestRunner {

    @Karate.Test
   Karate runAllTests() {

        return Karate.run(
//                TASK-2
//            ########################## /auth-service - 7 APIs ##########################
               "classpath:features/Api_V3_Login.feature",
               "classpath:features/Api_V3_Login_NegativeScenarios.feature",
                "classpath:features/Api_V3_Login-Authorized.feature",
                "classpath:features/Api_V3_Logout.feature",
                "classpath:features/Api_V3_Login-Tracker.feature",
                "classpath:features/Api_V3_User-Permissions.feature",
                "classpath:features/Api_V3_Get-Profile.feature",
                "classpath:features/Api_V3_Get-Profile-Image.feature",

//            ########################## /report-service - 12 APIs##########################
                "classpath:features/Api_v3_custom-reports_get-tables.feature",
                "classpath:features/Api_v3_custom-reports_get-columns.feature",
                "classpath:features/Api_v3_custom-reports_get-custom-data.feature",
                "classpath:features/Api_v3_custom-reports_get-collections.feature",
                "classpath:features/Api_v3_custom-reports_get-collection-report-data.feature",
                "classpath:features/Api_v3_custom-reports_delete-report-data.feature",
                "classpath:features/Api_v3_custom-reports_execute-custom-report.feature",
                "classpath:features/Api_v3_custom-reports_get-report-information.feature",
                "classpath:features/Api_v3_custom-reports_create-report.feature",
                "classpath:features/Api_v3_custom-reports_update-custom-report.feature",
                "classpath:features/Api_v3_custom-reports_insert-collection.feature",
                "classpath:features/Api_v3_custom-reports_get-user-information.feature",

//            ########################## /workqueue-service ##########################
                "classpath:features/Api_v3_work-queue_workqueue-summary.feature",
                "classpath:features/Api_v3_work-queue_assign-task.feature",
                "classpath:features/Api_v3_work-queue_update-priority-and-lock.feature",
                "classpath:features/Api_v3_work-queue_count.feature",
                "classpath:features/Api_v3_work-queue_global-task-list.feature",
                "classpath:features/Api_v3_work-queue_release-user-queue.feature",
                "classpath:features/Api_v3_work-queue_retrieve-users-to-assign.feature",
                "classpath:features/Api_v3_work-queue_open-work-queue.feature",
////                "classpath:features/Api_v3_work-queue_details.feature" //api got removed - confirmed with developer
                "classpath:features/Api_v3_work-queue_get-inprogress-accounts.feature",
                "classpath:features/Api_v3_work-queue_completed-accounts.feature",

//              ##############/evbv-service - patient-appointments###################
                "classpath:features/Api_v3_patient-appointments_patient-details.feature",
                "classpath:features/Api_v3_patient-appointments_insert-user-data.feature",

//                TASK-1
//             ##############/admin-service - USER ON BOARDING####################
                "classpath:features/Api_V3_user-on-board_get-client-mapping.feature",
                "classpath:features/Api_v3_user-on-board_get-workqueue-mapping.feature",
                "classpath:features/Api_v3_user-on-board_get-user-summary-details.feature",
                "classpath:features/Api_v3_user-on-board_get-user-page-permissions.feature",
                "classpath:features/Api_v3_user-on-board_get-page-permissions-details.feature",
                "classpath:features/Api_v3_user-on-board_insert-new-user.feature",
                "classpath:features/Api_v3_user-on-board_user-group-permission.feature",
                "classpath:features/Api_v3_user-on-board_user-status.feature",
                "classpath:features/Api_v3_user-on-board_user-client-mapping.feature",
                "classpath:features/Api_v3_user-on-board_insert-user-client-workqueue.feature",
                "classpath:features/Api_v3_user-on-board_update-user-client-workqueue-mapping.feature"
               );
   }


}