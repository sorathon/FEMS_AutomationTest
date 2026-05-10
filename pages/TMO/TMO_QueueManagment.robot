*** Settings ***
Library     Browser
Library     String
Resource    ../../pages/TMO/TMO_Login.robot
Resource    ../../resoures/config.robot

*** Variables ***
# --- ส่วนเมนูและการนำทาง ---
${MENU_QUEUE_MGT}          xpath=//*[@id="sidebar-menu-25"]
${MENU_IMPORT}              xpath=//*[@id="sidebar-sub-menu-33"]

           
${BTN_SIDEBAR_TOGGLE}      xpath=//button[@id="sidebar-toggle-btn"]

# --- ส่วนช่องค้นหา (Search Fields) ---
${INP_SEARCH_BOOKING}      id=tracking-search-search-bookingReferenceNumber
${INP_SEARCH_DEC_NO}       id=tracking-search-search-declarationNumber
${INP_SEARCH_HAWB}         id=tracking-search-search-hawb
${INP_SEARCH_PLATE}        id=tracking-search-search-vehicleNumber
${INP_SEARCH_DATE}         id=tracking-search-search-reserveDate
${SEL_SEARCH_STATUS}       id=tracking-search-search-statusId
${BTN_SEARCH_SUBMIT}       id=tracking-search-btn-search

# --- ส่วนตารางและการจัดการ (Actions) ---
${CHK_SELECT_ALL}          id=queue-management-tracking-selected-all
${CHK_ROW_FIRST}           id=queue-management-tracking-check-0
${BTN_MULTIPLE_ACCEPT}     id=tracking-management-btn-multiple-accept
${BTN_MODAL_CONFIRM}       xpath=//div[@class="modal-content"]//button[@id="tracking-management-btn-multiple-accept"]

*** Keywords ***

QueueAcceptSuccess
    [Arguments]    ${booking_id}=${EMPTY}    ${dec_no}=${EMPTY}    ${date}=${EMPTY}    ${hawb}=${EMPTY}    ${plate}=${EMPTY}    ${status}=${EMPTY}
    Login As TMO User
    Navigate To Import Page
    Search And Verify Booking    ${booking_id}    ${dec_no}    ${date}    ${hawb}    ${plate}    ${status}
    Perform Accept Action
    Verify Status in Search Result    expected_status=Accept    target_booking_id=${booking_id}

QueueMultiAccept
    [Arguments]    ${booking_id}=${EMPTY}    ${dec_no}=${EMPTY}    ${date}=${EMPTY}    ${hawb}=${EMPTY}    ${plate}=${EMPTY}    ${status}=${EMPTY}
    Login As TMO User
    Click    css=button.swal2-confirm    # ปิดแจ้งเตือนถ้ามี
    Navigate To Import Page
    Search And Verify Booking    ${booking_id}    ${dec_no}    ${date}    ${hawb}    ${plate}    ${status}
    Perform Accept Action
    Verify Status in Search Result    expected_status=Accept

QueueAcceptFailed
    [Arguments]    ${booking_id}=${EMPTY}    ${dec_no}=${EMPTY}    ${date}=${EMPTY}    ${hawb}=${EMPTY}    ${plate}=${EMPTY}    ${status}=${EMPTY}
    Login As TMO User
    Click    css=button.swal2-confirm
    Navigate To Import Page
    Search And Verify Booking    ${booking_id}    ${dec_no}    ${date}    ${hawb}    ${plate}    ${status}
    
    # พยายาม Accept รายการที่ผิดเงื่อนไข
    Wait For Elements State    ${CHK_ROW_FIRST}    visible
    Check Checkbox             ${CHK_ROW_FIRST}
    Click                      ${BTN_MULTIPLE_ACCEPT}
    Verify Eligibility Error Appears


Navigate To Import Page
    Click    ${MENU_QUEUE_MGT}
    Click    ${MENU_IMPORT}
    Wait For Elements State    ${BTN_SEARCH_SUBMIT}    visible    timeout=10s

Search And Verify Booking
    [Arguments]    ${booking_id}    ${dec_no}    ${date}    ${hawb}    ${plate}    ${status}
    # 1. กรอกข้อมูลค้นหา
    Click    ${BTN_SIDEBAR_TOGGLE}
    IF    $booking_id    Fill Text    ${INP_SEARCH_BOOKING}    ${booking_id}
    IF    $dec_no        Fill Text    ${INP_SEARCH_DEC_NO}     ${dec_no}
    IF    $hawb          Fill Text    ${INP_SEARCH_HAWB}       ${hawb}
    IF    $plate         Fill Text    ${INP_SEARCH_PLATE}      ${plate}
    IF    $date          Fill Date to TMO Tracking        ${date}
    
    Select Status     ${status}
    Click    ${BTN_SEARCH_SUBMIT}
    Sleep    2s    # รอระบบ Render

    # 2. ตรวจสอบความถูกต้องข้อมูล (Verification)
    IF    $booking_id    Count Search Result By Booking ID    ${booking_id}
    IF    $dec_no        Count Search Result By Dec No        ${dec_no}
    IF    $hawb          Count Search Result By HAWB          ${hawb}
    IF    $plate         Count Search Result By Vehicle Plate    ${plate}
    Verify Status in Search Result    expected_status=Queue

Perform Accept Action
    Wait For Elements State    ${CHK_SELECT_ALL}    visible
    Check Checkbox             ${CHK_SELECT_ALL}
    Click                      ${BTN_MULTIPLE_ACCEPT}
    Wait For Elements State    ${BTN_MODAL_CONFIRM}    visible
    Click                      ${BTN_MODAL_CONFIRM}
    Sleep    5s



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
    # 1. ปรับ XPath ให้หาได้ทั้ง <a> และ <span> ที่อยู่ภายใต้หัวข้อ Booking No.
    # ใช้ * เพื่อหา Element อะไรก็ได้ที่มี class เกี่ยวกับ card-sub-title
    ${base_xapth}=     Set Variable    xpath=//div[./span[text()="Booking No."]]//*[contains(@class, "card-sub-title") and text()="${target_booking_id}"]   
    
    # 2. รอให้ข้อมูลปรากฏ
    Wait For Elements State    ${base_xapth}[1]    visible    timeout=10s
    
    # 3. นับจำนวนที่พบ
    ${count}=    Get Element Count    ${base_xapth}
    
    Log To Console    \n[INFO] Found Booking ID ${target_booking_id}: ${count} record(s)
    
    # 4. เพิ่มการ Verify เบื้องต้นเพื่อให้เทสหยุดทันทีถ้าหาไม่เจอ (Fail Fast)
    Should Be True    ${count} > 0    msg=❌ ไม่พบ Booking ID: ${target_booking_id} ในผลการค้นหา
    
    [Return]    ${count}



Count Search Result By Dec No
    [Arguments]    ${target_dec}
    ${locator}=    Set Variable    xpath=//span[text()="${target_dec}"]
    Wait For Elements State    ${locator}    visible
    ${count}=    Get Element Count    ${locator}
    Log To Console    \n[FOUND] Dec No: ${count} record(s)

Count Search Result By HAWB
    [Arguments]    ${target_hawb}
    ${locator}=    Set Variable    xpath=//div[contains(@class, "card-content") and ./span[text()="HAWB"] and contains(., "${target_hawb}")]
    Wait For Elements State    ${locator}    visible
    ${count}=    Get Element Count    ${locator}
    Log To Console    \n[FOUND] HAWB: ${count} record(s)

Count Search Result By Vehicle Plate
    [Arguments]    ${target_plate}
    ${locator}=    Set Variable    xpath=//div[./span[text()="Vehicle Plate"]]//span[contains(., "${target_plate}")]
    Wait For Elements State    ${locator}    visible
    ${count}=    Get Element Count    ${locator}
    Log To Console    \n[FOUND] Vehicle Plate: ${count} record(s)

Verify Status in Search Result
    [Arguments]    ${expected_status}    ${target_booking_id}=${EMPTY}
    ${base_xpath}=    Set Variable    //div[contains(@class, 'card-content') and ./span[contains(text(), 'Status')]]//span[normalize-space(.)='${expected_status}']
    IF    $target_booking_id
        ${base_xpath}=    Set Variable    //div[contains(@class, 'card-body') and .//span[text()='${target_booking_id}']]${base_xpath}
    END
    Wait For Elements State    xpath=(${base_xpath})[1]    visible
    ${count}=    Get Element Count    xpath=${base_xpath}
    Should Be True    ${count} > 0    msg=❌ ไม่พบสถานะ ${expected_status}
    Log To Console    \n[VERIFIED] Status '${expected_status}': ${count} record(s)

Verify Eligibility Error Appears
    ${error_msg}=    Set Variable    xpath=//td[contains(text(), "ไม่อยู่ในเงื่อนไขที่สามารถดำเนินการได้")]
    Wait For Elements State    ${error_msg}    visible    timeout=10s
    Log To Console    \n[EXPECTED ERROR] Found: ${error_msg}


Fill Date to TMO Tracking
    [Arguments]        ${date_full}
    # 1. แยกค่าจาก 2026-May-03
    ${year}    ${month_name}    ${day}=    Split String    ${date_full}    -
    Sleep  3 seconds  # รอให้ปุ่มพร้อมก่อนคลิก (ถ้าเจอปัญหาเรื่อง Element Not Interactable)
    Click    xpath=//input[@id="tracking-search-search-reserveDate"]
    Wait For Elements State    .bs-datepicker-container    visible    timeout=10s
    Click    xpath=(//div[@class="bs-datepicker-head"]//button[contains(@class, "current")])[1]
    Click    xpath=(//div[@class="bs-datepicker-head"]//button[contains(@class, "current")])[1]
    Wait For Elements State    xpath=//span[normalize-space()="${year}"]    visible
    Click    xpath=//span[normalize-space()="${year}"]
    Wait For Elements State    xpath=//span[text()="${month_name}"]    visible
    Click    xpath=//span[text()="${month_name}"]
    ${day_int}=    Convert To Integer    ${day}
    ${target_day_xpath}=    Set Variable    xpath=//div[@class="bs-datepicker-body"]//span[text()="${day_int}" and not(contains(@class, "is-other-month"))]
    Wait For Elements State    ${target_day_xpath}    visible
    Click    ${target_day_xpath}
    Wait For Elements State    .bs-datepicker-container    hidden    timeout=3s





# *** Settings ***
# Library    Browser
# Library    String
# Resource   ../../pages/TMO/TMO_Login.robot
# Resource   ../../resoures/config.robot

# *** Variables ***
# # Navigation
# ${MENU_QUEUE_MGT}      xpath=//*[@id="sidebar-menu-queue"]  //*[@id="sidebar-menu-25"]
# ${MENU_IMPORT}         xpath=//*[@id="sidebar-menu-import"]

# # Search Fields
# ${INP_SEARCH_ID}       id=tracking-search-search-bookingReferenceNumber
# ${INP_SEARCH_PLATE}    id=tracking-search-search-vehicleNumber
# ${BTN_SEARCH_SUBMIT}   id=tracking-search-btn-search

# # Actions
# ${CHK_SELECT_ALL}      id=queue-management-tracking-selected-all
# ${BTN_MULTIPLE_ACCEPT}  id=tracking-management-btn-multiple-accept




# *** Keywords ***
# QueueAcceptSuccess   
#     [Arguments]    ${BOOKING_ID}=${EMPTY}    ${Declaration_No}=${EMPTY}    ${Date_To_TMO}=${EMPTY}    
#     ...    ${HAWD_NO}=${EMPTY}       ${Licens_id}=${EMPTY}        ${status_expeted}=${EMPTY}    
#     Login As TMO User
#     Open QUEUEMANAGMENT Menu
#     Open IMPORT Page
#     Sleep     1     seconds
#     Tracking Booking    ${BOOKING_ID}    ${Declaration_No}    ${Date_To_TMO}    
#     ...    ${HAWD_NO}       ${Licens_id}        ${status_expeted}




# QueueMultiAccept  
#         [Arguments]    ${BOOKING_ID}=${EMPTY}    ${Declaration_No}=${EMPTY}    ${Date_To_TMO}=${EMPTY}    
#     ...    ${HAWD_NO}=${EMPTY}       ${Licens_id}=${EMPTY}        ${status_expeted}=${EMPTY}

#     Login As TMO User
#     Click    css=button.swal2-confirm
#     Open QUEUEMANAGMENT Menu
#     Open IMPORT Page
#     Sleep     1     seconds    
#     # เข้าสู่หน้า Tracking
#     Click    xpath=//button[@id="sidebar-toggle-btn"]
    
#     Run Keyword If    '${BOOKING_ID}' != '${EMPTY}'         Fill Text    xpath=//*[@id="tracking-search-search-bookingReferenceNumber"]    ${BOOKING_ID}
#     Run Keyword If    '${Declaration_No}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-declarationNumber"]       ${Declaration_No}
#     Run Keyword If    '${HAWD_NO}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-hawb"]    ${HAWD_NO}
    

#     Select Status           status_value=${status_expeted}

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

#     IF   '${HAWD_NO}' != '${EMPTY}'
#         Count Search Result By HAWB    ${HAWD_NO}        
#     END
#     IF     '${Licens_id}' != '${EMPTY}'
#         Count Search Result By Vehicle Plate   ${Licens_id}
#     END
#     Verify Status in Search Result    expected_status=Queue

#     # --- ส่วนการคลิกเลือกรายการ (Action) ---

#     # 1. รอให้ Checkbox ปรากฏและทำการเลือก (Check)
#     # ใช้ ID เจาะจงที่ตัวแรก (Index 0)
#     Wait For Elements State    id=queue-management-tracking-selected-all    visible    timeout=10s
#     Check Checkbox             id=queue-management-tracking-selected-all

#     Click    xpath=//*[@id="tracking-management-btn-multiple-accept"]
#     # 2. ตรวจสอบว่าปุ่ม Accept พร้อมให้กดหรือยัง (หลังติ๊กแล้วปุ่มควรจะกดได้)
#     Click    xpath=//div[@class="modal-content"]//button[@id="tracking-management-btn-multiple-accept"]

#     Verify Status in Search Result    expected_status=Accept
    
    
   
#     # รอให้เห็นผลลัพธ์ด้วยตา (ลดเวลาลงจาก 20s เป็น 5s เพื่อความรวดเร็ว)
#     Sleep    5 seconds   

# QueueAcceptFailed
#     [Arguments]    ${BOOKING_ID}=${EMPTY}    ${Declaration_No}=${EMPTY}    ${Date_To_TMO}=${EMPTY}    
#     ...    ${HAWD_NO}=${EMPTY}       ${Licens_id}=${EMPTY}        ${status_expeted}=${EMPTY}
#     Click    css=button.swal2-confirm
#     Open QUEUEMANAGMENT Menu
#     Open IMPORT Page
#     Sleep     1     seconds
#     Click    xpath=//button[@id="sidebar-toggle-btn"]
    
#     Run Keyword If    '${BOOKING_ID}' != '${EMPTY}'         Fill Text    xpath=//*[@id="tracking-search-search-bookingReferenceNumber"]    ${BOOKING_ID}
#     Run Keyword If    '${Declaration_No}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-declarationNumber"]       ${Declaration_No}
#     Run Keyword If    '${HAWD_NO}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-hawb"]    ${HAWD_NO}
    

#     Select Status           status_value=${status_expeted}

#     Fill Text   xpath=//*[@id="tracking-search-search-vehicleNumber"]    ${Licens_id}


#     IF    '${Date_To_TMO}' != '${EMPTY}'
#         Fill Date to TMO Tracking    ${Date_To_TMO}
#     END

#     Click    xpath=//button[@id="tracking-search-btn-search"]
#     # แนะนำให้เพิ่มการรอ Loading Spinner หายไปตรงนี้ (ถ้าหน้าเว็บมี)
#     Sleep    2s    # ให้เวลาระบบ Render ผลลัพธ์ใหม่
#         Wait For Elements State    id=queue-management-tracking-check-0    visible    timeout=10s
#     Check Checkbox             id=queue-management-tracking-check-0

#     Click    xpath=//*[@id="tracking-management-btn-multiple-accept"]

#     Verify Eligibility Error Appears 

#     Sleep    5 seconds  



# Open QUEUEMANAGMENT Menu
#     Click      ${MENU_QUEUEMANAGMENT}

# Open IMPORT Page
#     Click      ${MENU_INPORT}


# Tracking Booking
#     [Arguments]    ${BOOKING_ID}=${EMPTY}    ${Declaration_No}=${EMPTY}    ${Date_To_TMO}=${EMPTY}    
#     ...    ${HAWD_NO}=${EMPTY}       ${Licens_id}=${EMPTY}        ${status_expeted}=${EMPTY}

    
#     # เข้าสู่หน้า Tracking
#     Click    xpath=//button[@id="sidebar-toggle-btn"]
    
#     Run Keyword If    '${BOOKING_ID}' != '${EMPTY}'         Fill Text    xpath=//*[@id="tracking-search-search-bookingReferenceNumber"]    ${BOOKING_ID}
#     Run Keyword If    '${Declaration_No}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-declarationNumber"]       ${Declaration_No}
#     Run Keyword If    '${HAWD_NO}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-hawb"]    ${HAWD_NO}
    

#     Select Status           status_value=${status_expeted}

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

#     IF   '${HAWD_NO}' != '${EMPTY}'
#         Count Search Result By HAWB    ${HAWD_NO}        
#     END
#     IF     '${Licens_id}' != '${EMPTY}'
#         Count Search Result By Vehicle Plate   ${Licens_id}
#     END
#     Verify Status in Search Result    expected_status=Queue

#     # --- ส่วนการคลิกเลือกรายการ (Action) ---

#     # 1. รอให้ Checkbox ปรากฏและทำการเลือก (Check)
#     # ใช้ ID เจาะจงที่ตัวแรก (Index 0)
#     Wait For Elements State    id=queue-management-tracking-check-0    visible    timeout=10s
#     Check Checkbox             id=queue-management-tracking-check-0

#     Click    xpath=//*[@id="tracking-management-btn-multiple-accept"]
#     # 2. ตรวจสอบว่าปุ่ม Accept พร้อมให้กดหรือยัง (หลังติ๊กแล้วปุ่มควรจะกดได้)
#     Click    xpath=//div[@class="modal-content"]//button[@id="tracking-management-btn-multiple-accept"]

#     Sleep   5  seconds

#     Verify Status in Search Result    expected_status=Accept
    
    
   
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
    
#     # 1. ปรับ XPath ให้หาได้ทั้ง <a> และ <span> ที่อยู่ภายใต้หัวข้อ Booking No.
#     # ใช้ * เพื่อหา Element อะไรก็ได้ที่มี class เกี่ยวกับ card-sub-title
#     ${base_xapth}=     Set Variable    xpath=//div[./span[text()="Booking No."]]//*[contains(@class, "card-sub-title") and text()="${target_booking_id}"]   
    
#     # 2. รอให้ข้อมูลปรากฏ
#     Wait For Elements State    ${base_xapth}[1]    visible    timeout=10s
    
#     # 3. นับจำนวนที่พบ
#     ${count}=    Get Element Count    ${base_xapth}
    
#     Log To Console    \n[INFO] Found Booking ID ${target_booking_id}: ${count} record(s)
    
#     # 4. เพิ่มการ Verify เบื้องต้นเพื่อให้เทสหยุดทันทีถ้าหาไม่เจอ (Fail Fast)
#     Should Be True    ${count} > 0    msg=❌ ไม่พบ Booking ID: ${target_booking_id} ในผลการค้นหา
    
#     [Return]    ${count}


# Count Search Result By Declaration No
#     [Arguments]    ${target_dec_no}
    
#     # 1. เช็คถ้าเป็นค่าว่าง (ตามวิธีที่เราตกลงกันว่าให้ยืดหยุ่น)
#     IF    '${target_dec_no}' == '${EMPTY}'
#         Log    [SKIP] Declaration No is empty, skipping verification.
#         Return    ${0}
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


# Count Search Result By HAWB
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


# Count Search Result By Vehicle Plate
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
    
#     RETURN    ${count}


# Verify Status in Search Result
#     [Arguments]    ${expected_status}    ${target_booking_id}=${EMPTY}
    
#     IF    '${expected_status}' == '${EMPTY}' or '${expected_status}' == 'All'
#         RETURN    ${0}
#     END

#     # ปรับ XPath ให้ยืดหยุ่นขึ้น:
#     # 1. หา div ที่มีคำว่า Status
#     # 2. มุดลงไปหา span ตัวที่มีข้อความตรงกับสถานะที่เราต้องการ (ใช้ normalize-space เพื่อล้างช่องว่าง)
#     ${base_xpath}=    Set Variable    //div[contains(@class, 'card-content') and ./span[contains(text(), 'Status')]]//span[normalize-space(.)='${expected_status}']

#     # ถ้ามีการระบุ Booking ID ให้เจาะจงไปที่การ์ดใบนั้นก่อน
#     IF    '${target_booking_id}' != '${EMPTY}'
#         ${base_xpath}=    Set Variable    //div[contains(@class, 'card-body') and .//span[text()='${target_booking_id}']]${base_xpath}
#     END

#     # --- ส่วนที่เหลือเหมือนเดิม ---
#     Wait For Elements State    xpath=(${base_xpath})[1]    visible    timeout=10s
#     ${count}=    Get Element Count    xpath=${base_xpath}
    
#     Log To Console    \n[INFO] Verified Status '${expected_status}': Found ${count} record(s)
#     Should Be True    ${count} > 0    msg=❌ ไม่พบสถานะ ${expected_status} ในผลการค้นหา
#     RETURN    ${count}




# Verify Eligibility Error Appears 
#     [Documentation]    ยืนยันว่าต้องพบข้อความ Error เมื่อเลือกรายการที่ผิดเงื่อนไข
    
#     ${error_locator}=    Set Variable    xpath=//td[contains(text(), "ไม่อยู่ในเงื่อนไขที่สามารถดำเนินการได้")]
    
#     # รอให้ Element แสดงขึ้นมา (ถ้าไม่แสดงภายใน 10s จะ Fail ทันที)
#     Wait For Elements State    ${error_locator}    visible    timeout=10s
    
#     # ดึงข้อความมา Log เก็บไว้เป็นหลักฐาน
#     ${actual_message}=    Get Text    ${error_locator}
#     Log    Found expected error message: ${actual_message}