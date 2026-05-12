*** Settings ***
Library    Browser
Library    String
Library    DateTime

Resource    ../../pages/shipping/shipping_createBooking_page.robot

*** Variables ***
# --- Locators ---
${TXT_SEARCH_REF_NO}        xpath=//input[@id="queue-booking-tracking-search-referenceNumber"]
${TXT_SEARCH_SUBMIT_DATE}   xpath=//input[@id="queue-booking-tracking-search-submitDate"]
${TXT_SEARCH_RESERVE_DATE}  id=queue-booking-tracking-search-reserveDate
${DDL_SEARCH_STATUS}        xpath=//select[@id="queue-booking-tracking-search-statusId"]
${BTN_SEARCH_QUEUE}         xpath=//*[@id="queue-booking-tracking-btn-search"]

*** Keywords ***
# ---------------------------------------------------------
# ACTIONS (พฤติกรรมการกด/กรอกของ User)
# ---------------------------------------------------------
Open Queue Booking Page
    Click    ${MNU_SIDEBAR_QUEUE_BOOKING}

Search Booking In Queue Booking
    [Documentation]    ค้นหาคิวบุ๊คกิ้งโดยใช้ Booking ID, วันที่ และสถานะ
    [Arguments]    ${booking_id}    ${submit_date}=${EMPTY}    ${reserve_date}=${EMPTY}    ${status}=${EMPTY}
    
    # กรอก Reference Number
    Fill Text    ${TXT_SEARCH_REF_NO}    ${booking_id}
    
    # กรอก Submit Date (ถ้ามี)
    IF    $submit_date
        Fill Text    ${TXT_SEARCH_SUBMIT_DATE}    ${submit_date}
    END
    
    # เคลียร์ค่าและกรอก Reserve Date (ถ้ามี)
    IF    $reserve_date
        Click         ${TXT_SEARCH_RESERVE_DATE}
        Press Keys    ${TXT_SEARCH_RESERVE_DATE}    Control+A    Backspace
        Fill Text     ${TXT_SEARCH_RESERVE_DATE}    ${reserve_date}
    END
    
    # เลือก Status (ถ้ามี)
    IF    $status
        Select Options By    ${DDL_SEARCH_STATUS}    text    ${status}
    END
    
    Click    ${BTN_SEARCH_QUEUE}
    # แทนที่ Sleep ด้วยการรอให้โหลดเสร็จ (ถ้ามี Loading Spinner ให้ Wait For Element State hidden แทน)



Verify Booking Is Displayed In Search Result
    [Documentation]    ตรวจสอบว่าพบ Reference Number นี้ในตารางผลลัพธ์
    [Arguments]    ${target_booking_id}
    
    ${locator}=    Set Variable    xpath=//span[contains(@class, "reference-number") and text()="${target_booking_id}"]
    Wait For Elements State    ${locator}    visible    timeout=10s
    ${count}=      Get Element Count       ${locator}
    Log To Console    \n[INFO] Found Booking ID ${target_booking_id}: ${count} record(s)
    RETURN    ${count}


Verify Date To TMO In Search Result
    [Documentation]    ตรวจสอบว่าวันที่ TMO แสดงผลถูกต้องตรงกับ Booking ID นั้นๆ
    [Arguments]    ${target_booking_id}    ${expected_date_num}
    
    # แปลง Format วันที่ให้ตรงกับหน้า UI (สมมติว่ารับมาเป็น 2026-05-10 ต้องแปลงเป็น 10/05/2026)
    ${ui_date}=    Convert Date    ${expected_date_num}    date_format=%Y-%m-%d    result_format=%d/%m/%Y
    
    ${locator}=    Set Variable    xpath=//div[contains(@class, 'card-body') and .//span[text()="${target_booking_id}"]]//div[contains(@class, 'card-content') and ./span[text()='Date To TMO'] and contains(., "${ui_date}")]
    
    Wait For Elements State    ${locator}    visible    timeout=10s
    ${count}=      Get Element Count       ${locator}
    Log To Console    \n[INFO] Verified Date To TMO: ${ui_date} for Booking: ${target_booking_id} | Found: ${count}
    RETURN    ${count}