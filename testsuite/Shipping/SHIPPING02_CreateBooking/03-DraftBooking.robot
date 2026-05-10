*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot

Test Setup   Run Keywords   Login To System As Shipping User   
...          AND            Prepare All Random Variables    
...          AND            Open Create Booking Page
Test Teardown    Close Web Application

*** Test Cases ***
TC_010 : Create Draft   Booking success 
    [Template]    Create New Booking And Check Booking status
    DRAFT           2026-July-10         7-7777-77777-77-7           ${EMPTY}        กระบี่       รถยนต์ 4 ที่นั่ง      รับสินค้าขาเข้าปกติ        TG      ภายในประเทศ/ท่าอื่น    10  30   ของมีค่า(TG)      #GH587333777799     HAWB001
    ...    ${EMPTY}



       

    


    
   




