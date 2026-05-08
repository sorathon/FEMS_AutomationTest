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

Login To System As Shipping User
    Open Login Shipping Web Application
    Login To System As Shipping    username=trainingship        password=Netbay@123


Login As TMO User
    Open Login TMO Web Application
    Input LoginTMO Credentials         username=trainingtg      password=Netbay@123
    Click LoginTMO Button
    #Click    css=button.swal2-confirm

Close Web Application
    Close Browser