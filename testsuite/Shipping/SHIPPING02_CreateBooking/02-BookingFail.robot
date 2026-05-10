*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot

Test Setup   Run Keywords   Login To System As Shipping User   
...          AND            Prepare All Random Variables    
...          AND            Open Create Booking Page
Test Teardown    Close Web Application

*** Test Cases ***
TC_09: Create Booking Validation - Mandatory Field Missing
     [Template]     Create New Booking And Check Booking status
           FAIL   
    ...    ${RAND_DATE_FULL}    
    ...    ${RAND_DRIVER_ID}    
    ...    ${RAND_LICENSE}    
    ...    กระบี่
    ...    รถยนต์ 4 ที่นั่ง    
    ...    รับสินค้าขาเข้าปกติ
    ...    TG    
    ...    ภายในประเทศ/ท่าอื่น    
    ...    10    30
    ...    ของมีค่า(TG)    
    ...    ${SINGLE_PRODUCT_LIST}


       

    


    
   




