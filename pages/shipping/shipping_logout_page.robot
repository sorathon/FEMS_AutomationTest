

*** Settings ***
Library    Browser
Library    String
Resource    ../shipping/shipping_login_page.robot

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
Check Logout
     Click    xpath=//*[@id="sidebar-panel"]/ul[2]/li[3]/a
     Click    css=button.swal2-confirm 

Vertify Logout success
    Get Url  ==  https://uataotfems.netbay.co.th/fems/#/auth/login



