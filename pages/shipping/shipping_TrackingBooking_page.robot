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
    [Arguments]    ${BOOKING_ID}=${EMPTY}    ${Declaration_No}=${EMPTY}    ${Date_To_TMO}=${EMPTY}
    
    # เข้าสู่หน้า Tracking
    Click    xpath=//*[@id="sidebar-menu-19"]
    
    # --- STEP 1: กรอกข้อมูล (กรอกเฉพาะที่มีค่า) ---
    Run Keyword If    '${BOOKING_ID}' != '${EMPTY}'         Fill Text    xpath=//*[@id="tracking-search-search-bookingReferenceNumber"]    ${BOOKING_ID}
    Run Keyword If    '${Declaration_No}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-declarationNumber"]       ${Declaration_No}
    
    IF    '${Date_To_TMO}' != '${EMPTY}'
        Fill Date to TMO Tracking    ${Date_To_TMO}
    END

    # --- STEP 2: กดค้นหาและรอ Spinner ---
    Click    xpath=//button[@id="tracking-search-btn-search"]
    # แนะนำให้เพิ่มการรอ Loading Spinner หายไปตรงนี้ (ถ้าหน้าเว็บมี)
    Sleep    2s    # ให้เวลาระบบ Render ผลลัพธ์ใหม่

    # --- STEP 3: ตรวจสอบผลการค้นหา (Smart Verification) ---
    # 1. ตรวจสอบ Booking ID (ถ้ามีการระบุ)
    IF    '${BOOKING_ID}' != '${EMPTY}'
        Count Search Result By Booking ID    ${BOOKING_ID}
    END

    # 2. ตรวจสอบ Declaration No (ถ้ามีการระบุ)
    IF    '${Declaration_No}' != '${EMPTY}'
        Count Search Result By Declaration No    ${Declaration_No}
    END

    # 3. ตรวจสอบ Date to TMO (ถ้ามีการระบุ) 
    # พิเศษ: ถ้ามี Booking ID ด้วย เราจะเช็คว่า "ID นี้ มีวันที่ตรงไหม" ในใบเดียวกัน
    IF    '${Date_To_TMO}' != '${EMPTY}'
        # แปลงวันที่สำหรับการ Verify (เช่น 2026-05-03 -> 03/05/26)
        # หมายเหตุ: ควรใช้ ${RAND_DATE_NUM} ที่เป็น format YYYY-MM-DD เพื่อความแม่นยำของ Convert Date
        ${date_for_verify}=    Convert Date    ${RAND_DATE_NUM}    result_format=%d/%m/%y
        Verify Date in Search Result    ${date_for_verify}    ${BOOKING_ID}
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
    [Arguments]    ${expected_date}    ${target_booking_id}=${EMPTY}
    
    IF    '${expected_date}' == '${EMPTY}'    [Return]    ${0}

    # --- กลยุทธ์ XPath ระดับสูง ---
    IF    '${target_booking_id}' != '${EMPTY}'
        # หาการ์ดที่มี Booking ID นี้ แล้วมุดไปหาวันที่ใน Card Body เดียวกัน
        ${locator}=    Set Variable    xpath=//a[text()="${target_booking_id}"]/ancestor::div[contains(@class, "card")]//span[text()="Date to TMO"]/following-sibling::text()[contains(., "${expected_date}")]/..
    ELSE
        # ถ้าค้นหาด้วยวันที่อย่างเดียว ให้เอาตัวแรกที่พบ
        ${locator}=    Set Variable    xpath=(//div[contains(@class, "card-content") and ./span[text()="Date to TMO"] and contains(., "${expected_date}")])[1]
    END

    # รอให้ Element ปรากฏและเช็คจำนวน
    Wait For Elements State    ${locator}    visible    timeout=10s
    ${count}=    Get Element Count    ${locator}
    
    Log To Console    \n[INFO] Verified Date ${expected_date} for Booking ${target_booking_id}: Found ${count} record(s)
    Should Be True    ${count} > 0    msg=❌ ข้อมูลวันที่ไม่ถูกต้อง หรือไม่พบข้อมูลที่ตรงตามเงื่อนไข
    [Return]    ${count}