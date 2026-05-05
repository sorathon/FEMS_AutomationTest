*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/TMO/TMO_Logout.robot

Test Setup       Login As TMO User
Test Teardown    Close Web Application



*** Test Cases ***
TC_01: Login Success with Valid Credentials
    [Documentation]    ทดสอบกรณี logout ออกสู่ระบบสำเร็จ
    TMO_Logout
    Vertify Logout success
    
    






    
    
