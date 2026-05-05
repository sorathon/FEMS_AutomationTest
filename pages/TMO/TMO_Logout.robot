*** Settings ***
Library    Browser
Library    String
Resource   ../../pages/TMO/TMO_Login.robot

*** Keywords ***
TMOLogout
    Click    css=button.swal2-confirm 
    Click    xpath=//*[@id="sidebar-panel"]/ul[2]/li[3]/a
    Click    css=button.swal2-confirm 

Vertify Logout success
    Get Url  ==  https://uataotfems.netbay.co.th/fems/#/auth/login









