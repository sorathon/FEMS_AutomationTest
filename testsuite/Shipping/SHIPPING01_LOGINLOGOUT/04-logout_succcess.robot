*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_logout_page.robot

Test Setup       Login As shipping User
Test Teardown    Close Web Application



*** Test Cases ***
TC_01: Login Success with Valid Credentials
    [Documentation]    ทดสอบกรณีกรอกรหัสผ่านและ Username ถูกต้อง ระบบต้องเข้าสู่ระบบสำเร็จ
    Check Logout
    Vertify Logout success
  
      
    

    

