*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_login_page.robot

Test Setup       Open Login Shipping Web Application
Test Teardown    Close Web Application
Test Template    LoginSuccess



*** Test Cases ***    username              password
TC_01: Login Success with Valid Credentials
    [Documentation]    ทดสอบกรณีกรอกรหัสผ่านและ Username ถูกต้อง ระบบต้องเข้าสู่ระบบสำเร็จ   
                      trainingship          Netbay@123
    
   

