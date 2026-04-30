*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_login_page.robot

Test Setup       Login As shipping User
Test Teardown    Close Web Application



*** Test Cases ***
TC_05: create booking success
    [Documentation]    ทดสอบกรณีสร้าง booking สำเร็จ
    
    Open Queue Booking Menu

    Open Create Booking Page

    Fill Date to TMO    2026-July-01

    Select Driver By id    7-7777-77777-77-7

    Fill Vehicle infomation  กข888   กระบี่   รถยนต์ 4 ที่นั่ง

    Fill infomation request Booking

    Fill Product list     GH587333777777          VG778777777
    
    check booking success

    Sleep    30  seconds





