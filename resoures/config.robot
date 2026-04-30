*** Settings ***
Library    Browser
Resource   ../pages/shipping/shipping_login_page.robot



*** Variables ***
${URL_LOGIN}    https://uataotfems.netbay.co.th/fems/#/auth/shipping/login

*** Keywords *** 
Open Login Shipping Web Application
    New Browser   browser=chromium    headless=False
    New Page       ${URL_LOGIN}   
    Set Browser Timeout    20 seconds   

Login As shipping User
    Open Login Shipping Web Application
    Input Login Credentials     trainingship          Netbay@123
    Click Login Button


    

Close Web Application
    Close Browser