*** Settings ***
Library    Browser
Library    String

*** Variables ***
#Login Page
${TXT_USERNAME}    xpath=//*[@id="login-username"] 
${TXT_PASSWORD}    xpath=//*[@id="login-password"]
${BTN_LOGIN}       xpath=//*[@title="Login"]
${BTN_CON}        xpath=/html/body/div[2]/div/div[3]/button[1]
${MSG_TOOLTIP}    css=.invalid-tooltip
${url_loginTMO}     https://uataotfems.netbay.co.th/fems/#/auth/tmo/login
${url_homeTMO}      https://uataotfems.netbay.co.th/fems/#/mainmenu/announcement

#Queue Booking
${MENU_QUEUEMANAGMENT}    xpath=//*[@id="sidebar-menu-25"]
${MENU_IMPORT}            xpath=//*[@id="sidebar-sub-menu-33"]

*** Keywords ***
TMOLoginsuccess
    [Arguments]        ${username}        ${password}
    Input LoginTMO Credentials        ${username}    ${password}
    Click LoginTMO Button
    Click    css=button.swal2-confirm
    Sleep    3s
    Verify LoginTMO Success


Input LoginTMO Credentials
    [Arguments]    ${username}    ${password}
    Fill Text    ${TXT_USERNAME}    ${username}
    Fill Text    ${TXT_PASSWORD}    ${password}

Click LoginTMO Button
    Click    ${BTN_LOGIN}
    Sleep  3 seconds


Verify Validation Tooltip
    [Arguments]    ${expected_text}
    Get Text    ${MSG_TOOLTIP}    contains    ${expected_text}

Verify LoginTMO Success
    Get Url  contains  ${url_homeTMO} 

Verify LoginTMO Failed
    [Arguments]    ${expected_text}=Login Failed
    Get Url  contains  ${url_loginTMO}
    Get Text    xpath=//*[@id="swal2-title"]    contains    ${expected_text}
    
Verify LoginTMO Empty
    [Arguments]   ${username}    ${password}    ${expected_tooltip}
    Input LoginTMO Credentials    ${username}         ${password}
    Click LoginTMO Button
    Verify Validation Tooltip    ${expected_tooltip}




    










