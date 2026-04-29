*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_login_page.robot

Test Setup       Open Login Shipping Web Application
Test Teardown    Close Web Application

*** Test Cases ***
TC_04: Login Fail when Username and Password are Incorrect
    [Documentation]    ทดสอบกรณีกรอกรหัสผ่านและ Username ผิด
    
    Input Login Credentials     tester_shipping    dfdfdfd
    
    Click Login Button
    
    Verify Login Failed



