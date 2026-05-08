*** Settings ***
Library    Browser
Library    String

*** Variables ***
#Login Page
${LOGIN_USER_FIELD}      xpath=//*[@id="login-username"]
${LOGIN_PASS_FIELD}      xpath=//*[@id="login-password"]
${BTN_LOGIN}       xpath=//*[@title="Login"]
${MSG_TOOLTIP}    css=.invalid-tooltip
${LOGIN_ERROR_POPUP}     xpath=//*[@id="swal2-title"]


${url_login}     https://uataotfems.netbay.co.th/fems/#/auth/shipping/login
${url_home}      https://uataotfems.netbay.co.th/fems/#/mainmenu/announcement

#Queue Booking
${MENU_QUEUE_BOOKING}    xpath=//*[@id="sidebar-menu-17"]
${MENU_CREATE_BOOKING}    xpath=//*[@id="queue-booking-tracking-btn-create"]

*** Keywords ***
Login Failure Template
    [Arguments]    ${user}    ${pass}    ${msg}
    [Documentation]    Keyword สำหรับตรวจสอบกรณี Login ไม่สำเร็จทุกรูปแบบ
    Login To System As Shipping    ${user}    ${pass}
    Verify Login Error Message     ${msg}

Login Success 
     [Arguments]        ${username}     ${password}
     Login To System As Shipping   ${username}     ${password}     
     Click Login Button
     Verify Home Page Reached

Fill username as shipping 
     [Arguments]        ${username}
    Fill Text    ${LOGIN_USER_FIELD}    ${username}

Fill Password as shipping
    [Arguments]        ${password}
    Fill Text    ${LOGIN_PASS_FIELD}    ${password}

Login To System As Shipping
    [Arguments]    ${username}    ${password}
    Fill username as shipping    ${username}
    Fill Password as shipping    ${password}
    Click Login Button

Click Login Button
    Click    ${BTN_LOGIN}
    Sleep  3 seconds

Verify Home Page Reached
    Wait For Condition    Url    contains    ${URL_HOME}    timeout=10s
    Log To Console        \n[PASS] Logged in successfully.

Verify Login Error Message
    [Arguments]    ${expected_msg}
    # รองรับทั้ง Tooltip และ Swal Popup ใน Keyword เดียว
    ${is_tooltip}=    Get Element Count    ${MSG_TOOLTIP}
    IF    ${is_tooltip} > 0
        Get Text    ${MSG_TOOLTIP}    contains    ${expected_msg}
    ELSE
        Get Text    ${LOGIN_ERROR_POPUP}    contains    ${expected_msg}
    END


   

# LoginFail  
#     [Arguments]        ${username}     ${password}
#     Input Login Credentials    ${username}     ${password}     
    
#     Click Login Button
    
#     Verify Login Failed

# Input Login Credentials
#     [Arguments]    ${username}    ${password}
#     Fill Text    ${TXT_USERNAME}    ${username}
#     Fill Text    ${TXT_PASSWORD}    ${password}

# Verify Validation Tooltip
#     [Arguments]    ${expected_text}
#     Get Text    ${MSG_TOOLTIP}    contains    ${expected_text}

# Verify Login Success
#     Get Url  contains  ${url_home} 

# Verify Login Failed
#     [Arguments]    ${expected_text}=Login Failed
#     Get Url  contains  ${url_login}
#     Get Text    xpath=//*[@id="swal2-title"]    contains    ${expected_text}


# Verify Login Empty
#     [Arguments]   ${username}    ${password}    ${expected_tooltip}
#     Input Login Credentials    ${username}         ${password}
#     Click Login Button
#     Verify Validation Tooltip    ${expected_tooltip}






    










