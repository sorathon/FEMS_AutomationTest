*** Settings ***
Library    Browser
Library    String
Resource   ../../pages/shipping/shipping_login_page.robot
Resource   ../../pages/shipping/shipping_createBooking_page.robot
Resource   ../../resoures/utils/data_generator.robot


*** Variables ***
#Login Page
${TXT_USERNAME}    xpath=//*[@id="login-username"]
${TXT_PASSWORD}    xpath=//*[@id="login-password"]
${BTN_LOGIN}       xpath=//*[@title="Login"]
${MSG_TOOLTIP}    css=.invalid-tooltip
${url_login}     https://uataotfems.netbay.co.th/fems/#/auth/shipping/login
${url_home}      https://uataotfems.netbay.co.th/fems/#/mainmenu/announcement

#Queue Booking
${MENU_QUEUE_BOOKING}    xpath=//*[@id="sidebar-menu-17"]
${MENU_CREATE_BOOKING}    xpath=//*[@id="queue-booking-tracking-btn-create"]



*** Keywords ***
Queue Booking
    [Arguments]     ${Booking Date}       ${status}       
    
       
    Fill Text    xpath=//input[@id="queue-booking-tracking-search-referenceNumber"]            ${GLOBAL_BOOKING_ID}
    Fill Text    xpath=//input[@id="queue-booking-tracking-search-submitDate"]    ${Booking Date}
    
    

    # 1. คลิกที่ช่องเพื่อให้ Focus
    Click    id=queue-booking-tracking-search-reserveDate
    
    # 2. กด Control + A เพื่อคลุมดำทั้งหมด และกด Backspace เพื่อลบ
    # (ใช้ได้ทั้ง Windows/Linux ถ้าเป็น Mac ให้เปลี่ยน Control เป็น Meta)
    Press Keys    id=queue-booking-tracking-search-reserveDate    Control+A    Backspace
    
    # 3. พิมพ์ค่าใหม่ลงไป
    Fill Text     id=queue-booking-tracking-search-reserveDate        ${RAND_DATE_NUM}
    #Press Keys    id=queue-booking-tracking-search-reserveDate    Enter
    Select Options By       xpath=//select[@id="queue-booking-tracking-search-statusId"]  text   ${status}
    Sleep   3 seconds
    Click  xpath=//*[@id="queue-booking-tracking-btn-search"]  

    Sleep     5  seconds


    

Search Auto By Booking ID
    [Arguments]    ${target_booking_id}
    
    # รอให้เลข Booking ตัวที่เราระบุ ปรากฏขึ้นบนหน้าจอ
    Wait For Elements State    xpath=//span[contains(@class, "reference-number") and text()="${target_booking_id}"]    visible    timeout=7s
    
    # นับจำนวนว่าเจอ ID นี้กี่อัน
    ${count}=    Get Element Count    xpath=//span[contains(@class, "reference-number") and text()="${target_booking_id}"]
    
    Log To Console    \n[INFO] Found Booking ID ${target_booking_id}: ${count} record(s)
    [Return]    ${count}


Search Auto By Date To TMO
    [Arguments]    ${target_date_num}    # รับค่าแบบ 2026-06-14
    
    # 1. แปลงวันที่ให้เป็น Format หน้าจอ (14/06/2026)
    ${ui_date}=    Convert Date    ${target_date_num}    
    ...    date_format=%Y-%m-%d    
    ...    result_format=%d/%m/%Y

    # 2. รอให้ Element ปรากฏ
    Wait For Elements State    xpath=//span[text()="Date To TMO"]    visible    timeout=7s

    # 3. นับจำนวน
    ${count}=    Get Element Count    xpath=//div[contains(@class, "card-content") and span[text()="Date To TMO"] and contains(normalize-space(.), "${ui_date}")]
    
    Log To Console    \n[DEBUG] UI Date: ${ui_date} | Found: ${count}
    [Return]    ${count}
    


    


