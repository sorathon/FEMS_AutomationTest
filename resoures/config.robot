*** Settings ***
Library    Browser
Resource   ../pages/TMO/TMO_Login.robot
Resource    ../pages/shipping/shipping_login_page.robot



*** Keywords *** 
Open Login Shipping Web Application
    New Browser   browser=chromium    headless=False
    New Page       ${url_login}  
    Set Browser Timeout    20 seconds 


Open Login TMO Web Application
    New Browser   browser=chromium    headless=False
    New Page       ${url_loginTMO}  
    Set Browser Timeout    20 seconds 



Login As shipping User
    Open Login Shipping Web Application
    Input Login Credentials     trainingship          Netbay@123
    Click Login Button

Login As TMO User
    Open Login TMO Web Application
    Input LoginTMO Credentials         username=trainingtg      password=Netbay@123
    Click LoginTMO Button
    #Click    css=button.swal2-confirm


    

Close Web Application
    Close Browser