*** Settings ***
Library    Browser
Library    String

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
LoginSuccess
    [Arguments]        ${username}     ${password}
    Input Login Credentials    ${username}     ${password}     
    
    Click Login Button
    
    Verify Login Success

LoginFail
    [Arguments]        ${username}     ${password}
    Input Login Credentials    ${username}     ${password}     
    
    Click Login Button
    
    Verify Login Failed

Input Login Credentials
    [Arguments]    ${username}    ${password}
    Fill Text    ${TXT_USERNAME}    ${username}
    Fill Text    ${TXT_PASSWORD}    ${password}

Click Login Button
    Click    ${BTN_LOGIN}
    Sleep  3 seconds


Verify Validation Tooltip
    [Arguments]    ${expected_text}
    Get Text    ${MSG_TOOLTIP}    contains    ${expected_text}

Verify Login Success
    Get Url  contains  ${url_home} 

Verify Login Failed
    [Arguments]    ${expected_text}=Login Failed
    Get Url  contains  ${url_login}
    Get Text    xpath=//*[@id="swal2-title"]    contains    ${expected_text}


Verify Login Empty
    [Arguments]   ${username}    ${password}    ${expected_tooltip}
    Input Login Credentials    ${username}         ${password}
    Click Login Button
    Verify Validation Tooltip    ${expected_tooltip}






    










