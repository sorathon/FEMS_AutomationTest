*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../resoures/utils/data_generator.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot

Test Setup   Run Keywords   Login To System As Shipping User   
...          AND            Prepare All Random Variables    
...          AND            Open Create Booking Page

Test Teardown    Close Web Application


    
*** Test Cases *** 

TC07: Create Complete Booking Success with single product 
    [Template]    Create New Booking
    SUCCESS        2026-July-10         7-7777-77777-77-7           กข1234        กระบี่       รถยนต์ 4 ที่นั่ง      รับสินค้าขาเข้าปกติ      
    ...      TG      ภายในประเทศ/ท่าอื่น    10  30   ของมีค่า(TG)   
    ...    ${SINGLE_PRODUCT_LIST}

TC08: Create Complete Booking Success with many product 
    [Template]    Create New Booking
    SUCCESS        2026-July-10         7-7777-77777-77-7           กข1234        กระบี่       รถยนต์ 4 ที่นั่ง      รับสินค้าขาเข้าปกติ        TG      ภายในประเทศ/ท่าอื่น    10  30   ของมีค่า(TG)      #GH587333777799     HAWB001
    ...    ${MANY_PRODUCT_LIST}





       

    


    
   




