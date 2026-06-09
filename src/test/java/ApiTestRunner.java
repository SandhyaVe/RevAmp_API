import com.intuit.karate.junit5.Karate;

class ApiTestRunner {

    @Karate.Test
   Karate runAllTests() {

        return Karate.run(
//               "classpath:features/Api_V3_Login.feature",
//                "classpath:features/Api_V3_Login-Authorized.feature",
//                "classpath:features/Api_V3_Login-Tracker.feature",

//                ##############USER ON BOARDING####################
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