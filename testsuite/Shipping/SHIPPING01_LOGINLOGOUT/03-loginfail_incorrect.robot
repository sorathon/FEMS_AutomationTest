*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_login_page.robot

Test Setup       Open Login Shipping Web Application
Test Teardown    Close Web Application
Test Template    LoginFail

*** Test Cases ***      username               password
TC_04: Login Fail when Username and Password are Incorrect
    [Documentation]    ทดสอบกรณีกรอกรหัสผ่านและ Username ผิด
                        tester_shipping         dfdfdfd




