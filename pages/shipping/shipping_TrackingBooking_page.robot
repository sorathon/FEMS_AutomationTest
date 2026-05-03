*** Settings ***
Library    Browser
Library    String
Resource   ../../pages/shipping/shipping_login_page.robot
Resource   ../../pages/shipping/shipping_createBooking_page.robot
Resource   ../../pages/shipping/shipping_QueueBooking_page.robot
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
Tracking Booking
    [Arguments]     ${BOOKING_ID}         ${Declaration_No}          ${Date_To_TMO}
   
    Click    xpath=//*[@id="sidebar-menu-19"]

    # --- 1. กรอก Booking ID ---
    IF    '${BOOKING_ID}' != '${EMPTY}'
        Fill Text    xpath=//*[@id="tracking-search-search-bookingReferenceNumber"]    ${BOOKING_ID}
    ELSE
        Clear Text    xpath=//*[@id="tracking-search-search-bookingReferenceNumber"]
    END

    # --- 2. กรอก Declaration No ---
    IF    '${Declaration_No}' != '${EMPTY}'
        Fill Text    xpath=//*[@id="tracking-search-search-declarationNumber"]    ${Declaration_No}
        Log To Console    \n[INFO] Searching with Declaration No: ${Declaration_No}
    ELSE
        Clear Text    xpath=//*[@id="tracking-search-search-declarationNumber"]
        Log To Console    \n[INFO] Searching with Declaration No is EMPTY
    END

    
    Fill Date to TMO Tracking    ${Date_To_TMO}
    

    Click    xpath=//button[@id="tracking-search-btn-search"]

    # --- 4. ตรวจสอบผลการค้นหา (Verification) ---
    IF    '${BOOKING_ID}' != '${EMPTY}'
        Count Search Result By Booking ID    ${BOOKING_ID}
    END    
    IF    '${Declaration_No}' != '${EMPTY}'
        Count Search Result By Declaration No    ${Declaration_No}
    END

    IF    '${Date_To_TMO}' != '${EMPTY}'
        ${date_for_verify} =    Convert Date    ${RAND_DATE_NUM}     result_format=%d/%m/%y
        Verify Date in Search Result    ${date_for_verify}   
    END

    # รอให้เห็นผลลัพธ์ด้วยตา (ลดเวลาลงจาก 20s เป็น 5s เพื่อความรวดเร็ว)
    Sleep    5 seconds  


Fill Date to TMO Tracking
    [Arguments]    ${date_full}
    
    # 1. แยกค่าจาก 2026-May-03
    ${year}    ${month_name}    ${day}=    Split String    ${date_full}    -

    # 2. เปิดปฏิทิน (ใช้ input[@id=...] เพื่อแก้ปัญหา Strict Mode)
    Sleep  3 seconds  # รอให้ปุ่มพร้อมก่อนคลิก (ถ้าเจอปัญหาเรื่อง Element Not Interactable)
    Click    xpath=//input[@id="tracking-search-search-reserveDate"]
    Wait For Elements State    .bs-datepicker-container    visible    timeout=10s

    # 3. คลิกที่ส่วนหัวปฏิทินเพื่อเลือกปี
    # คลิกครั้งแรก (ที่ชื่อเดือน) เพื่อถอยไปหน้าเลือกเดือน
    Click    xpath=(//div[@class="bs-datepicker-head"]//button[contains(@class, "current")])[1]
    # คลิกครั้งที่สอง (ที่ปี) เพื่อถอยไปหน้าเลือกปี
    Click    xpath=(//div[@class="bs-datepicker-head"]//button[contains(@class, "current")])[1]

    # 4. เลือกปี (เช่น 2026)
    Wait For Elements State    xpath=//span[normalize-space()="${year}"]    visible
    Click    xpath=//span[normalize-space()="${year}"]

    # 5. เลือกเดือน (ใช้ชื่อเดือนที่ได้จาก date_full เช่น May)
    Wait For Elements State    xpath=//span[text()="${month_name}"]    visible
    Click    xpath=//span[text()="${month_name}"]

    # 6. เลือกวัน (แปลงจาก 03 เป็น 3 เพื่อความแม่นยำ)
    ${day_int}=    Convert To Integer    ${day}
    # ใช้ XPath ที่กันไม่ให้ไปคลิกโดนวันที่ของเดือนอื่น (is-other-month)
    ${target_day_xpath}=    Set Variable    xpath=//div[@class="bs-datepicker-body"]//span[text()="${day_int}" and not(contains(@class, "is-other-month"))]
    
    Wait For Elements State    ${target_day_xpath}    visible
    Click    ${target_day_xpath}

    # 7. รอจนปฏิทินปิดตัวลง
    Wait For Elements State    .bs-datepicker-container    hidden    timeout=3s


Count Search Result By Booking ID
    [Arguments]    ${target_booking_id}

    IF    '${target_booking_id}' == '${EMPTY}'
        Log    [SKIP] Booking ID is empty, skipping count.
        [Return]    ${0}
    END
    
    # 1. สร้าง XPath ให้เจาะจงที่แท็ก <a> ที่มี ID หรือ Class ที่ระบุ และมีข้อความตรงกับ ID ที่ต้องการ
    ${locator}=    Set Variable    xpath=//a[@id="tracking-card-column-goToBooking" and text()="${target_booking_id}"]
    
    # 2. รอให้เลข Booking ปรากฏ (ช่วยให้เทสเสถียรขึ้น)
    Wait For Elements State    ${locator}    visible    timeout=10s
    
    # 3. นับจำนวนว่าเจอ ID นี้กี่รายการในหน้านั้น
    ${count}=    Get Element Count    ${locator}
    
    Log To Console    \n[INFO] Found Booking ID ${target_booking_id}: ${count} record(s)
    
    # ส่งค่าจำนวนกลับไป (เผื่อเอาไปใช้ Check: Should Be Equal As Integers  ${count}  1)
    [Return]    ${count}


Count Search Result By Declaration No
    [Arguments]    ${target_dec_no}
    
    # 1. เช็คถ้าเป็นค่าว่าง (ตามวิธีที่เราตกลงกันว่าให้ยืดหยุ่น)
    IF    '${target_dec_no}' == '${EMPTY}'
        Log    [SKIP] Declaration No is empty, skipping verification.
        [Return]    ${0}
    END

    # 2. สร้าง XPath โดยอ้างอิงจาก Tag span (ถ้าไม่มี ID ให้ใช้ข้อความที่ตรงกันเป๊ะๆ)
    # หรือถ้ามีคลาสเฉพาะให้ใส่เพิ่ม เช่น //span[@class="dec-no" and text()="${target_dec_no}"]
    ${locator}=    Set Variable    xpath=//span[text()="${target_dec_no}"]
    
    # 3. รอให้เลขปรากฏบนหน้าจอ
    Wait For Elements State    ${locator}    visible    timeout=10s
    
    # 4. นับจำนวนที่พบ
    ${count}=    Get Element Count    ${locator}
    
    Log To Console    \n[INFO] Found Dec No ${target_dec_no}: ${count} record(s)
    [Return]    ${count}



Verify Date in Search Result
    [Arguments]    ${expected_date}
    
    # 1. เช็คถ้าไม่ได้ส่งวันที่มาเทส ก็ให้ข้ามไป
    IF    '${expected_date}' == '${EMPTY}'
        Log    [SKIP] Expected date is empty.
        [Return]    ${0}
    END

    # 2. สร้าง XPath เพื่อหา <span> ที่มีคำว่า Date to TMO 
    # แล้วใช้ /following-sibling::text() หรือเช็ค text รวมใน div
    # วิธีที่เสถียรที่สุดคือหา div ที่มี card-title นี้อยู่ แล้วเช็คว่ามีวันที่ที่เราต้องการไหม
    ${locator}=    Set Variable    xpath=//div[contains(@class, "card-content") and ./span[text()="Date to TMO"] and contains(., "${expected_date}")]

    # 3. รอให้ข้อมูลปรากฏ
    Wait For Elements State    ${locator}    visible    timeout=10s
    
    # 4. นับจำนวนการ์ดที่เจอวันที่นี้
    ${count}=    Get Element Count    ${locator}
    
    Log To Console    \n[INFO] Found Cards with Date ${expected_date}: ${count} record(s)
    
    # ถ้าคาดหวังว่าต้องเจออย่างน้อย 1 รายการ
    Should Be True    ${count} > 0    msg=Expected to find at least 1 card with Date to TMO ${expected_date}, but found ${count}.  
    [Return]    ${count}