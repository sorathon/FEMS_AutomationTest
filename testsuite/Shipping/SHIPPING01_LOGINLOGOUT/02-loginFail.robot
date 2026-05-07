*** Settings ***
Resource     ../../../resoures/config.robot
Resource     ../../../pages/shipping/shipping_login_page.robot

Test Setup      Open Login Shipping Web Application
Test Teardown   Close Web Application
Test Template   Login Failure Template

*** Test Cases ***                            USERNAME              PASSWORD        EXPECTED_MESSAGE
TC_02:Login Fail - Empty Username             ${EMPTY}              secret          กรุณาระบุชื่อผู้ใช้งาน
TC_03:Login Fail - Empty Password             TEST                  ${EMPTY}        กรุณาระบุรหัสผ่าน
TC_04:Login Fail - Incorrect Password         trainingship          123456          Login Failed
TC_05:Login Fail - Incorrect Username         Username_wrong        Netbay@123      Login Failed

