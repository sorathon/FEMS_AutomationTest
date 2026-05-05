*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_login_page.robot

Test Setup       Open Login Shipping Web Application
Test Teardown    Close Web Application
Test Template    Verify Login Empty

*** Test Cases ***     username            password         expected_message     
TC_02: Login Fail when Password is Empty
    [Documentation]    ทดสอบกรณีไม่กรอกรหัสผ่าน ระบบต้องแสดง Tooltip แจ้งเตือนสีแดง
                       tester_shipping     ${EMPTY}          กรุณาระบุรหัสผ่าน
    
TC_03: Login Fail when Username is Empty
    [Documentation]    ทดสอบกรณีไม่กรอกรหัสผ่าน ระบบต้องแสดง Tooltip แจ้งเตือนสีแดง
                       ${EMPTY}            tester_shipping   กรุณาระบุชื่อผู้ใช้งาน
    
    
       

