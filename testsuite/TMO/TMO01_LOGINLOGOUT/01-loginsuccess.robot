*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/TMO/TMO_Login.robot

Test Setup       Open Login TMO Web Application
Test Teardown    Close Web Application
Test Template    TMOLoginsuccess



*** Test Cases ***
TC_01: Login Success with Valid Credentials
    [Documentation]    ทดสอบกรณีกรอกรหัสผ่านและ Username ถูกต้อง ระบบต้องเข้าสู่ระบบสำเร็จ
#   username        password
    trainingtg      Netbay@123
    
    






    
    
