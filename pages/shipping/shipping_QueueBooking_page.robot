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
    
    Verify Booking Success   ${RAND_DATE_FULL}  
    ...     ${RAND_LICENSE}        กระบี่            รถยนต์ 4 ที่นั่ง       
    ...     ${RAND_DRIVER_ID}      รับสินค้าขาเข้าปกติ            TG               
    ...     ภายในประเทศ/ท่าอื่น     10    30            ของมีค่า(TG)    
    ...      ${RAND_DEC_NO}    ${RAND_HAWB}   
    

    Fill Text    xpath=//input[@id="queue-booking-tracking-search-referenceNumber"]            ${GLOBAL_BOOKING_ID}
    Fill Text    xpath=//input[@id="queue-booking-tracking-search-submitDate"]    ${Booking Date}
    
    

    Click    id=queue-booking-tracking-search-reserveDate
    

    Press Keys    id=queue-booking-tracking-search-reserveDate    Control+A    Backspace
    
    Fill Text     id=queue-booking-tracking-search-reserveDate        ${RAND_DATE_NUM}

    Select Options By       xpath=//select[@id="queue-booking-tracking-search-statusId"]  text   ${status}
    Sleep   3 seconds
    Click  xpath=//*[@id="queue-booking-tracking-btn-search"]  
    
    Verify Date in Search Result         ${RAND_DATE_NUM}        ${GLOBAL_BOOKING_ID}
    Search Auto By Booking ID             ${GLOBAL_BOOKING_ID}

    Sleep     5  seconds


    

Search Auto By Booking ID
    [Arguments]    ${target_booking_id}
    
    Wait For Elements State    xpath=//span[contains(@class, "reference-number") and text()="${target_booking_id}"]    visible    timeout=7s
    
    ${count}=    Get Element Count    xpath=//span[contains(@class, "reference-number") and text()="${target_booking_id}"]
    
    Log To Console    \n[INFO] Found Booking ID ${target_booking_id}: ${count} record(s)
    [Return]    ${count}


    
    

Verify Date in Search Result
    [Arguments]    ${expected_date}    ${target_booking_id}
    
    IF    '${expected_date}' == '${EMPTY}'    [Return]    ${0}

    ${ui_date}=    Convert Date    ${expected_date}    
    ...    date_format=%Y-%m-%d    
    ...    result_format=%d/%m/%Y

    IF    '${target_booking_id}' != '${EMPTY}'
        ${locator}=    Set Variable    xpath=//div[contains(@class, 'card-body') and .//span[text()="${target_booking_id}"]]//div[contains(@class, 'card-content') and ./span[text()='Date To TMO'] and contains(., "${ui_date}")]

    END

    Wait For Elements State    ${locator}    visible    timeout=10s
    ${count}=    Get Element Count    ${locator}
    
    Log To Console    \n[INFO] Verified Date To TMO: ${ui_date} for Booking: ${target_booking_id} | Found: ${count}
    
    [Return]    ${count}

