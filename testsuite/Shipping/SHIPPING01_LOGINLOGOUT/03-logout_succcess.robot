*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_logout_page.robot

Test Setup       Login As shipping User
Test Teardown    Close Web Application



*** Test Cases ***
TC_06: Logout Success with Valid Credentials
    [Documentation]    ทดสอบระบบ Logout โดยต้องกลับสู่หน้า login ใหม่อีกครั้ง 
    Check Logout
    Vertify Logout success
  
      
    

    

