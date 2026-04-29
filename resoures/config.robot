*** Settings ***
Library    Browser

*** Variables ***
${URL_LOGIN}    https://uataotfems.netbay.co.th/fems/#/auth/shipping/login

*** Keywords ***
Open Shipping Web Application
    New Browser   browser=chromium    headless=False
    New Page       ${URL_LOGIN}   
    Set Browser Timeout    20 seconds    

Close Web Application
    Close Browser