*** Settings ***
Library    Browser
Library    String
Resource   ../../pages/shipping/shipping_login_page.robot
Resource   ../../pages/shipping/shipping_createBooking_page.robot
Resource   ../../pages/shipping/shipping_QueueBooking_page.robot
Resource   ../../resoures/utils/data_generator.robot

*** Variables ***
${Fill_BookingID}     xpath=//*[@id="tracking-search-search-bookingReferenceNumber"]
${Fill_DeclarationNo.}    xpath=//*[@id="tracking-search-search-declarationNumber"] 
${Fill_HAWD}    xpath=//*[@id="tracking-search-search-hawb"]
${Fill_Licensid}    xpath=//*[@id="tracking-search-search-vehicleNumber"]


*** Keywords ***
#function ใหญ่สุด
Tracking Booking
    [Arguments]    ${BOOKING_ID}=${EMPTY}    ${Declaration_No}=${EMPTY}    ${Date_To_TMO}=${EMPTY}    ${HAWD_NO}=${EMPTY}       ${Licens_id}=${EMPTY}        ${Status_Tracking}=${EMPTY}
    
    # เข้าสู่หน้า Tracking
    Click    xpath=//*[@id="sidebar-menu-19"]
    
    Run Keyword If    '${BOOKING_ID}' != '${EMPTY}'         Fill Text    ${Fill_BookingID}    ${BOOKING_ID}
    Run Keyword If    '${Declaration_No}' != '${EMPTY}'    Fill Text    ${Fill_DeclarationNo.}       ${Declaration_No}
    Run Keyword If    '${HAWD_NO}' != '${EMPTY}'    Fill Text    ${Fill_HAWD}    ${HAWD_NO}
    

    Select Origin Agency        origin_value=${EMPTY}

    Select Destination Agency    destination_value=${EMPTY}

    Select Goods Type    goods_type_value=${EMPTY}

    Select Status           status_value=${Status_Tracking}

    Fill Text   ${Fill_Licensid}    ${Licens_id}

    IF    '${Date_To_TMO}' != '${EMPTY}'
        Fill Date to TMO Tracking    ${Date_To_TMO}
    END

    Click    xpath=//button[@id="tracking-search-btn-search"]
    # แนะนำให้เพิ่มการรอ Loading Spinner หายไปตรงนี้ (ถ้าหน้าเว็บมี)
    Sleep    2s    # ให้เวลาระบบ Render ผลลัพธ์ใหม่


    Vertify And Count Search Result    ${BOOKING_ID}    ${Declaration_No}    ${Date_To_TMO}    ${HAWD_NO}       ${Licens_id}        ${Status_Tracking}

    # --- STEP 3: ตรวจสอบผลการค้นหา (Smart Verification) ---
    # 1. ตรวจสอบ Booking ID (ถ้ามีการระบุ)
    # IF    '${BOOKING_ID}' != '${EMPTY}'
    #     Count Search Result By Booking ID    ${BOOKING_ID}
    # END
    # # 2. ตรวจสอบ Declaration No (ถ้ามีการระบุ)
    # IF    '${Declaration_No}' != '${EMPTY}'
    #     Vertify and Count Search Result By Declaration No    ${Declaration_No}
    # END
    
    # # 3. ตรวจสอบ Date to TMO (ถ้ามีการระบุ) 
    # # พิเศษ: ถ้ามี Booking ID ด้วย เราจะเช็คว่า "ID นี้ มีวันที่ตรงไหม" ในใบเดียวกัน
    # IF    '${Date_To_TMO}' != '${EMPTY}'
    #     # แปลงวันที่สำหรับการ Verify (เช่น 2026-05-03 -> 03/05/26)
    #     # หมายเหตุ: ควรใช้ ${RAND_DATE_NUM} ที่เป็น format YYYY-MM-DD เพื่อความแม่นยำของ Convert Date
    #     ${date_for_verify}=    Convert Date    ${RAND_DATE_NUM}    result_format=%d/%m/%y
    #     Verify Date in Search Result    ${date_for_verify}    ${BOOKING_ID}
    # END
    # IF   '${HAWD_NO}' != '${EMPTY}'
    #     Vertify and Count Search Result By HAWB     ${HAWD_NO}        
    # END
    # IF     '${Licens_id}' != '${EMPTY}'
    #     Vertify and Count Search Result By Vehicle Plate    ${Licens_id}
    # END
    # รอให้เห็นผลลัพธ์ด้วยตา (ลดเวลาลงจาก 20s เป็น 5s เพื่อความรวดเร็ว)
    ${ACTUAL_HAWB}=    Set Global Variable     ${SINGLE_PRODUCT_LIST[0]['hawb']}
    ${ACTUAL_DEC}=    Set Global Variable      ${SINGLE_PRODUCT_LIST[0]['dec_no']}
    Sleep    5 seconds  


Vertify And Count Search Result
    [Arguments]    ${BOOKING_ID}=${EMPTY}    ${Declaration_No}=${EMPTY}    ${Date_To_TMO}=${EMPTY}    ${HAWD_NO}=${EMPTY}       ${Licens_id}=${EMPTY}        ${Status_Tracking}=${EMPTY}
    IF    '${BOOKING_ID}' != '${EMPTY}'
        Count Search Result By Booking ID    ${BOOKING_ID}
    END

    # 2. ตรวจสอบ Declaration No (ถ้ามีการระบุ)
    IF    '${Declaration_No}' != '${EMPTY}'
        Vertify and Count Search Result By Declaration No    ${Declaration_No}
    END
    # 3. ตรวจสอบ Date to TMO (ถ้ามีการระบุ) 
    # พิเศษ: ถ้ามี Booking ID ด้วย เราจะเช็คว่า "ID นี้ มีวันที่ตรงไหม" ในใบเดียวกัน
    IF    '${Date_To_TMO}' != '${EMPTY}'
        # แปลงวันที่สำหรับการ Verify (เช่น 2026-05-03 -> 03/05/26)
        # หมายเหตุ: ควรใช้ ${RAND_DATE_NUM} ที่เป็น format YYYY-MM-DD เพื่อความแม่นยำของ Convert Date
        ${date_for_verify}=    Convert Date    ${RAND_DATE_NUM}    result_format=%d/%m/%y
        Verify Date in Search Result    ${date_for_verify}    ${BOOKING_ID}
    END
    IF   '${HAWD_NO}' != '${EMPTY}'
        Vertify and Count Search Result By HAWB     ${HAWD_NO}        
    END
    IF     '${Licens_id}' != '${EMPTY}'
        Vertify and Count Search Result By Vehicle Plate    ${Licens_id}
    END


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



Select Origin Agency
    [Arguments]    ${origin_value}
    Click    xpath=//select[@id="tracking-search-search-origin"]
    Wait For Elements State    xpath=//select[@id="tracking-search-search-origin"]    visible    timeout=10s
    # ตรวจสอบก่อนว่าถ้าค่าเป็นว่าง (EMPTY) หรือ "All" ก็ไม่ต้องเลือกอะไร
    IF    '${origin_value}' == '${EMPTY}' or '${origin_value}' == 'All'
        Select Options By    xpath=//select[@id="tracking-search-search-origin"]    value    ${EMPTY}
    ELSE

        Select Options By    xpath=//select[@id="tracking-search-search-origin"]    value    ${origin_value}
    END
    Sleep  3 seconds  # รอให้ระบบประมวลผลหลังเลือกค่า


Select Destination Agency
    [Arguments]    ${destination_value}
    Click    xpath=//select[@id="tracking-search-search-destination"]
    Wait For Elements State    xpath=//select[@id="tracking-search-search-destination"]   visible    timeout=10s
    # ตรวจสอบก่อนว่าถ้าค่าเป็นว่าง (EMPTY) หรือ "All" ก็ไม่ต้องเลือกอะไร
    IF    '${destination_value}' == '${EMPTY}' or '${destination_value}' == 'All'
        Select Options By    xpath=//select[@id="tracking-search-search-destination"]   value    ${EMPTY}
    ELSE
        Select Options By    xpath=//select[@id="tracking-search-search-destination"]   value    ${destination_value}        
    END
    Sleep  3 seconds  # รอให้ระบบประมวลผลหลังเลือกค่า


Select Goods Type
    [Arguments]    ${goods_type_value}
    Click    xpath=//select[@id="tracking-search-search-goodsType"]
    Wait For Elements State    xpath=//select[@id="tracking-search-search-goodsType"]   visible    timeout=10s
    # ตรวจสอบก่อนว่าถ้าค่าเป็นว่าง (EMPTY) หรือ "All" ก็ไม่ต้องเลือกอะไร
    IF    '${goods_type_value}' == '${EMPTY}' or '${goods_type_value}' == 'All'
        Select Options By    xpath=//select[@id="tracking-search-search-goodsType"]   label    ${EMPTY}
    ELSE
        Select Options By    xpath=//select[@id="tracking-search-search-goodsType"]   label    ${goods_type_value}        
    END
    Sleep  3 seconds  # รอให้ระบบประมวลผลหลังเลือกค่า



Select Status
    [Arguments]    ${status_value}
    
    Click    xpath=//select[@id="tracking-search-search-statusId"]
    Wait For Elements State    xpath=//select[@id="tracking-search-search-statusId"]    visible    timeout=10s
    
    IF    '${status_value}' == '${EMPTY}' or '${status_value}' == 'All'
      
        Select Options By    xpath=//select[@id="tracking-search-search-statusId"]    label    All
    ELSE
       
        Select Options By    xpath=//select[@id="tracking-search-search-statusId"]    label    ${status_value}
    END
    Sleep    3 seconds




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


Vertify and Count Search Result By Declaration No
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


Vertify and Count Search Result By HAWB
    [Arguments]    ${target_hawb}
    
    # 1. เช็คความว่างเปล่าตามมาตรฐาน Smart Keyword
    IF    '${target_hawb}' == '${EMPTY}'
        Log    [SKIP] HAWB is empty, skipping count.
        [Return]    ${0}
    END

    # 2. สร้าง XPath ที่เจาะจง
    # หา div ที่มีคลาส card-content และมีหัวข้อ (span) เป็น HAWB 
    # จากนั้นตรวจสอบว่าใน div นั้นมีข้อความ HAWB ที่เราต้องการหรือไม่
    ${locator}=    Set Variable    xpath=//div[contains(@class, "card-content") and ./span[text()="HAWB"] and contains(., "${target_hawb}")]

    # 3. รอให้ข้อมูลปรากฏบน UI
    Wait For Elements State    ${locator}    visible    timeout=10s
    
    # 4. นับจำนวน
    ${count}=    Get Element Count    ${locator}
    
    Log To Console    \n[INFO] Found HAWB ${target_hawb}: ${count} record(s)
    
    # 5. ตรวจสอบเบื้องต้นว่าต้องเจออย่างน้อย 1 (หรือตาม Logic ที่คุณต้องการ)
    Should Be True    ${count} > 0    msg=❌ ไม่พบรายการที่ตรงกับ HAWB: ${target_hawb}
    
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




Vertify and Count Search Result By Vehicle Plate
    [Arguments]    ${target_plate}
    
    # 1. เช็คความว่างเปล่า
    IF    '${target_plate}' == '${EMPTY}'
        Log    [SKIP] Vehicle Plate is empty.
        [Return]    ${0}
    END

    # 2. สร้าง XPath ที่เจาะจง
    # หา div ที่มีหัวข้อ (span) เป็น Vehicle Plate 
    # และมี span คลาส card-sub-title ที่มีข้อความตรงกับทะเบียนรถที่ต้องการ
    ${locator}=    Set Variable    xpath=//div[contains(@class, "item") and ./span[text()="Vehicle Plate"]]//span[@class="card-sub-title" and contains(., "${target_plate}")]

    # 3. รอให้ข้อมูลปรากฏ
    Wait For Elements State    ${locator}    visible    timeout=10s
    
    # 4. นับจำนวนที่พบ
    ${count}=    Get Element Count    ${locator}
    
    Log To Console    \n[INFO] Found Vehicle Plate ${target_plate}: ${count} record(s)
    
    # 5. ตรวจสอบว่าต้องเจออย่างน้อย 1 รายการ
    Should Be True    ${count} > 0    msg=❌ ไม่พบป้ายทะเบียนรถ: ${target_plate} ในผลการค้นหา
    
    [Return]    ${count}




# *** Settings ***
# Library    Browser
# Library    String
# Resource   ../../pages/shipping/shipping_login_page.robot
# Resource   ../../pages/shipping/shipping_createBooking_page.robot
# Resource   ../../pages/shipping/shipping_QueueBooking_page.robot
# Resource   ../../resoures/utils/data_generator.robot

# *** Variables ***
# #Login Page
# ${TXT_USERNAME}    xpath=//*[@id="login-username"]
# ${TXT_PASSWORD}    xpath=//*[@id="login-password"]
# ${BTN_LOGIN}       xpath=//*[@title="Login"]
# ${MSG_TOOLTIP}    css=.invalid-tooltip
# ${url_login}     https://uataotfems.netbay.co.th/fems/#/auth/shipping/login
# ${url_home}      https://uataotfems.netbay.co.th/fems/#/mainmenu/announcement

# #Queue Booking
# ${MENU_QUEUE_BOOKING}    xpath=//*[@id="sidebar-menu-17"]
# ${MENU_CREATE_BOOKING}    xpath=//*[@id="queue-booking-tracking-btn-create"]

# *** Keywords ***
# Tracking Booking
#     [Arguments]    ${BOOKING_ID}=${EMPTY}    ${Declaration_No}=${EMPTY}    ${Date_To_TMO}=${EMPTY}    ${HAWD_NO}=${EMPTY}       ${Licens_id}=${EMPTY}
    
#     # เข้าสู่หน้า Tracking
#     Click    xpath=//*[@id="sidebar-menu-19"]
    
#     Run Keyword If    '${BOOKING_ID}' != '${EMPTY}'         Fill Text    xpath=//*[@id="tracking-search-search-bookingReferenceNumber"]    ${BOOKING_ID}
#     Run Keyword If    '${Declaration_No}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-declarationNumber"]       ${Declaration_No}
#     Run Keyword If    '${HAWD_NO}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-hawb"]    ${HAWD_NO}
    

#     Select Origin Agency        origin_value=${EMPTY}

#     Select Destination Agency    destination_value=${EMPTY}

#     Select Goods Type    goods_type_value=${EMPTY}

#     Select Status           status_value=Queue

#     Fill Text   xpath=//*[@id="tracking-search-search-vehicleNumber"]    ${Licens_id}


#     IF    '${Date_To_TMO}' != '${EMPTY}'
#         Fill Date to TMO Tracking    ${Date_To_TMO}
#     END

#     Click    xpath=//button[@id="tracking-search-btn-search"]
#     # แนะนำให้เพิ่มการรอ Loading Spinner หายไปตรงนี้ (ถ้าหน้าเว็บมี)
#     Sleep    2s    # ให้เวลาระบบ Render ผลลัพธ์ใหม่

#     # --- STEP 3: ตรวจสอบผลการค้นหา (Smart Verification) ---
#     # 1. ตรวจสอบ Booking ID (ถ้ามีการระบุ)
#     IF    '${BOOKING_ID}' != '${EMPTY}'
#         Count Search Result By Booking ID    ${BOOKING_ID}
#     END

#     # 2. ตรวจสอบ Declaration No (ถ้ามีการระบุ)
#     IF    '${Declaration_No}' != '${EMPTY}'
#         Count Search Result By Declaration No    ${Declaration_No}
#     END
    
#     # 3. ตรวจสอบ Date to TMO (ถ้ามีการระบุ) 
#     # พิเศษ: ถ้ามี Booking ID ด้วย เราจะเช็คว่า "ID นี้ มีวันที่ตรงไหม" ในใบเดียวกัน
#     IF    '${Date_To_TMO}' != '${EMPTY}'
#         # แปลงวันที่สำหรับการ Verify (เช่น 2026-05-03 -> 03/05/26)
#         # หมายเหตุ: ควรใช้ ${RAND_DATE_NUM} ที่เป็น format YYYY-MM-DD เพื่อความแม่นยำของ Convert Date
#         ${date_for_verify}=    Convert Date    ${RAND_DATE_NUM}    result_format=%d/%m/%y
#         Verify Date in Search Result    ${date_for_verify}    ${BOOKING_ID}
#     END
#     IF   '${HAWD_NO}' != '${EMPTY}'
#         Count Search Result By HAWB    ${HAWD_NO}        
#     END
#     IF     '${Licens_id}' != '${EMPTY}'
#         Count Search Result By Vehicle Plate   ${Licens_id}
#     END
    
    
    
#     # รอให้เห็นผลลัพธ์ด้วยตา (ลดเวลาลงจาก 20s เป็น 5s เพื่อความรวดเร็ว)
#     Sleep    5 seconds  


# Fill Date to TMO Tracking
#     [Arguments]    ${date_full}
    
#     # 1. แยกค่าจาก 2026-May-03
#     ${year}    ${month_name}    ${day}=    Split String    ${date_full}    -

#     # 2. เปิดปฏิทิน (ใช้ input[@id=...] เพื่อแก้ปัญหา Strict Mode)
#     Sleep  3 seconds  # รอให้ปุ่มพร้อมก่อนคลิก (ถ้าเจอปัญหาเรื่อง Element Not Interactable)
#     Click    xpath=//input[@id="tracking-search-search-reserveDate"]
#     Wait For Elements State    .bs-datepicker-container    visible    timeout=10s

#     # 3. คลิกที่ส่วนหัวปฏิทินเพื่อเลือกปี
#     # คลิกครั้งแรก (ที่ชื่อเดือน) เพื่อถอยไปหน้าเลือกเดือน
#     Click    xpath=(//div[@class="bs-datepicker-head"]//button[contains(@class, "current")])[1]
#     # คลิกครั้งที่สอง (ที่ปี) เพื่อถอยไปหน้าเลือกปี
#     Click    xpath=(//div[@class="bs-datepicker-head"]//button[contains(@class, "current")])[1]

#     # 4. เลือกปี (เช่น 2026)
#     Wait For Elements State    xpath=//span[normalize-space()="${year}"]    visible
#     Click    xpath=//span[normalize-space()="${year}"]

#     # 5. เลือกเดือน (ใช้ชื่อเดือนที่ได้จาก date_full เช่น May)
#     Wait For Elements State    xpath=//span[text()="${month_name}"]    visible
#     Click    xpath=//span[text()="${month_name}"]

#     # 6. เลือกวัน (แปลงจาก 03 เป็น 3 เพื่อความแม่นยำ)
#     ${day_int}=    Convert To Integer    ${day}
    
#     ${target_day_xpath}=    Set Variable    xpath=//div[@class="bs-datepicker-body"]//span[text()="${day_int}" and not(contains(@class, "is-other-month"))]
    
#     Wait For Elements State    ${target_day_xpath}    visible
#     Click    ${target_day_xpath}

#     # 7. รอจนปฏิทินปิดตัวลง
#     Wait For Elements State    .bs-datepicker-container    hidden    timeout=3s



# Select Origin Agency
#     [Arguments]    ${origin_value}
#     Click    xpath=//select[@id="tracking-search-search-origin"]
#     Wait For Elements State    xpath=//select[@id="tracking-search-search-origin"]    visible    timeout=10s
#     # ตรวจสอบก่อนว่าถ้าค่าเป็นว่าง (EMPTY) หรือ "All" ก็ไม่ต้องเลือกอะไร
#     IF    '${origin_value}' == '${EMPTY}' or '${origin_value}' == 'All'
#         Select Options By    xpath=//select[@id="tracking-search-search-origin"]    value    ${EMPTY}
#     ELSE

#         Select Options By    xpath=//select[@id="tracking-search-search-origin"]    value    ${origin_value}
#     END
#     Sleep  3 seconds  # รอให้ระบบประมวลผลหลังเลือกค่า


# Select Destination Agency
#     [Arguments]    ${destination_value}
#     Click    xpath=//select[@id="tracking-search-search-destination"]
#     Wait For Elements State    xpath=//select[@id="tracking-search-search-destination"]   visible    timeout=10s
#     # ตรวจสอบก่อนว่าถ้าค่าเป็นว่าง (EMPTY) หรือ "All" ก็ไม่ต้องเลือกอะไร
#     IF    '${destination_value}' == '${EMPTY}' or '${destination_value}' == 'All'
#         Select Options By    xpath=//select[@id="tracking-search-search-destination"]   value    ${EMPTY}
#     ELSE

#         Select Options By    xpath=//select[@id="tracking-search-search-destination"]   value    ${destination_value}        
#     END
#     Sleep  3 seconds  # รอให้ระบบประมวลผลหลังเลือกค่า

# Select Goods Type
#     [Arguments]    ${goods_type_value}
#     Click    xpath=//select[@id="tracking-search-search-goodsType"]
#     Wait For Elements State    xpath=//select[@id="tracking-search-search-goodsType"]   visible    timeout=10s
#     # ตรวจสอบก่อนว่าถ้าค่าเป็นว่าง (EMPTY) หรือ "All" ก็ไม่ต้องเลือกอะไร
#     IF    '${goods_type_value}' == '${EMPTY}' or '${goods_type_value}' == 'All'
#         Select Options By    xpath=//select[@id="tracking-search-search-goodsType"]   label    ${EMPTY}
#     ELSE

#         Select Options By    xpath=//select[@id="tracking-search-search-goodsType"]   label    ${goods_type_value}        
#     END
#     Sleep  3 seconds  # รอให้ระบบประมวลผลหลังเลือกค่า



# Select Status
#     [Arguments]    ${status_value}
    
#     Click    xpath=//select[@id="tracking-search-search-statusId"]
#     Wait For Elements State    xpath=//select[@id="tracking-search-search-statusId"]    visible    timeout=10s
    
#     IF    '${status_value}' == '${EMPTY}' or '${status_value}' == 'All'
      
#         Select Options By    xpath=//select[@id="tracking-search-search-statusId"]    label    All
#     ELSE
       
#         Select Options By    xpath=//select[@id="tracking-search-search-statusId"]    label    ${status_value}
#     END
#     Sleep    3 seconds




# Count Search Result By Booking ID
#     [Arguments]    ${target_booking_id}

#     IF    '${target_booking_id}' == '${EMPTY}'
#         Log    [SKIP] Booking ID is empty, skipping count.
#         [Return]    ${0}
#     END
    
#     # 1. สร้าง XPath ให้เจาะจงที่แท็ก <a> ที่มี ID หรือ Class ที่ระบุ และมีข้อความตรงกับ ID ที่ต้องการ
#     ${locator}=    Set Variable    xpath=//a[@id="tracking-card-column-goToBooking" and text()="${target_booking_id}"]
    
#     # 2. รอให้เลข Booking ปรากฏ (ช่วยให้เทสเสถียรขึ้น)
#     Wait For Elements State    ${locator}    visible    timeout=10s
    
#     # 3. นับจำนวนว่าเจอ ID นี้กี่รายการในหน้านั้น
#     ${count}=    Get Element Count    ${locator}
    
#     Log To Console    \n[INFO] Found Booking ID ${target_booking_id}: ${count} record(s)
    
#     # ส่งค่าจำนวนกลับไป (เผื่อเอาไปใช้ Check: Should Be Equal As Integers  ${count}  1)
#     [Return]    ${count}


# Vertify and Count Search Result By Declaration No
#     [Arguments]    ${target_dec_no}
    
#     # 1. เช็คถ้าเป็นค่าว่าง (ตามวิธีที่เราตกลงกันว่าให้ยืดหยุ่น)
#     IF    '${target_dec_no}' == '${EMPTY}'
#         Log    [SKIP] Declaration No is empty, skipping verification.
#         [Return]    ${0}
#     END

#     # 2. สร้าง XPath โดยอ้างอิงจาก Tag span (ถ้าไม่มี ID ให้ใช้ข้อความที่ตรงกันเป๊ะๆ)
#     # หรือถ้ามีคลาสเฉพาะให้ใส่เพิ่ม เช่น //span[@class="dec-no" and text()="${target_dec_no}"]
#     ${locator}=    Set Variable    xpath=//span[text()="${target_dec_no}"]
    
#     # 3. รอให้เลขปรากฏบนหน้าจอ
#     Wait For Elements State    ${locator}    visible    timeout=10s
    
#     # 4. นับจำนวนที่พบ
#     ${count}=    Get Element Count    ${locator}
    
#     Log To Console    \n[INFO] Found Dec No ${target_dec_no}: ${count} record(s)
#     [Return]    ${count}


# Vertify  and  Count Search Result By HAWB
#     [Arguments]    ${target_hawb}
    
#     # 1. เช็คความว่างเปล่าตามมาตรฐาน Smart Keyword
#     IF    '${target_hawb}' == '${EMPTY}'
#         Log    [SKIP] HAWB is empty, skipping count.
#         [Return]    ${0}
#     END

#     # 2. สร้าง XPath ที่เจาะจง
#     # หา div ที่มีคลาส card-content และมีหัวข้อ (span) เป็น HAWB 
#     # จากนั้นตรวจสอบว่าใน div นั้นมีข้อความ HAWB ที่เราต้องการหรือไม่
#     ${locator}=    Set Variable    xpath=//div[contains(@class, "card-content") and ./span[text()="HAWB"] and contains(., "${target_hawb}}")]

#     # 3. รอให้ข้อมูลปรากฏบน UI
#     Wait For Elements State    ${locator}    visible    timeout=10s
    
#     # 4. นับจำนวน
#     ${count}=    Get Element Count    ${locator}
    
#     Log To Console    \n[INFO] Found HAWB ${target_hawb}: ${count} record(s)
    
#     # 5. ตรวจสอบเบื้องต้นว่าต้องเจออย่างน้อย 1 (หรือตาม Logic ที่คุณต้องการ)
#     Should Be True    ${count} > 0    msg=❌ ไม่พบรายการที่ตรงกับ HAWB: ${target_hawb}
    
#     [Return]    ${count}



# Verify Date in Search Result
#     [Arguments]    ${expected_date}    ${target_booking_id}=${EMPTY}
    
#     IF    '${expected_date}' == '${EMPTY}'    [Return]    ${0}

#     # --- กลยุทธ์ XPath ระดับสูง ---
#     IF    '${target_booking_id}' != '${EMPTY}'
#         # หาการ์ดที่มี Booking ID นี้ แล้วมุดไปหาวันที่ใน Card Body เดียวกัน
#         ${locator}=    Set Variable    xpath=//a[text()="${target_booking_id}"]/ancestor::div[contains(@class, "card")]//span[text()="Date to TMO"]/following-sibling::text()[contains(., "${expected_date}")]/..
#     ELSE
#         # ถ้าค้นหาด้วยวันที่อย่างเดียว ให้เอาตัวแรกที่พบ
#         ${locator}=    Set Variable    xpath=(//div[contains(@class, "card-content") and ./span[text()="Date to TMO"] and contains(., "${expected_date}")])[1]
#     END

#     # รอให้ Element ปรากฏและเช็คจำนวน
#     Wait For Elements State    ${locator}    visible    timeout=10s
#     ${count}=    Get Element Count    ${locator}
    
#     Log To Console    \n[INFO] Verified Date ${expected_date} for Booking ${target_booking_id}: Found ${count} record(s)
#     Should Be True    ${count} > 0    msg=❌ ข้อมูลวันที่ไม่ถูกต้อง หรือไม่พบข้อมูลที่ตรงตามเงื่อนไข
#     [Return]    ${count}


# Vertify and Count Search Result By Vehicle Plate
#     [Arguments]    ${target_plate}
    
#     # 1. เช็คความว่างเปล่า
#     IF    '${target_plate}' == '${EMPTY}'
#         Log    [SKIP] Vehicle Plate is empty.
#         [Return]    ${0}
#     END

#     # 2. สร้าง XPath ที่เจาะจง
#     # หา div ที่มีหัวข้อ (span) เป็น Vehicle Plate 
#     # และมี span คลาส card-sub-title ที่มีข้อความตรงกับทะเบียนรถที่ต้องการ
#     ${locator}=    Set Variable    xpath=//div[contains(@class, "item") and ./span[text()="Vehicle Plate"]]//span[@class="card-sub-title" and contains(., "${target_plate}")]

#     # 3. รอให้ข้อมูลปรากฏ
#     Wait For Elements State    ${locator}    visible    timeout=10s
    
#     # 4. นับจำนวนที่พบ
#     ${count}=    Get Element Count    ${locator}
    
#     Log To Console    \n[INFO] Found Vehicle Plate ${target_plate}: ${count} record(s)
    
#     # 5. ตรวจสอบว่าต้องเจออย่างน้อย 1 รายการ
#     Should Be True    ${count} > 0    msg=❌ ไม่พบป้ายทะเบียนรถ: ${target_plate} ในผลการค้นหา
    
#     [Return]    ${count}