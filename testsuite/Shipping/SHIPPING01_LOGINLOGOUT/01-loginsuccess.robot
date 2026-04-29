*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_login_page.robot

Test Setup       Open Shipping Web Application
Test Teardown    Close Web Application

*** Test Cases ***
TC_03: Login Fail when Password is Empty
    [Documentation]    ทดสอบกรณีไม่กรอกรหัสผ่าน ระบบต้องแสดง Tooltip แจ้งเตือนสีแดง
    
    # 1. กรอกแค่ Username แต่ส่งค่าว่าง (${EMPTY}) ไปที่ Password
    Input Login Credentials    tester_shipping    ${EMPTY}
    
    # 2. กดปุ่ม Login
    Click Login Button
    
    # 3. ตรวจสอบข้อความใน Tooltip (ก๊อปปี้คำจากหน้าเว็บมาใส่ได้เลย)
    Verify Validation Tooltip    กรุณาระบุรหัสผ่าน