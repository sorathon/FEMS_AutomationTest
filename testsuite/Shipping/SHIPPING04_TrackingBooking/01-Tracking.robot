*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_TrackingBooking_page.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup       Run Keywords    Login As shipping User    AND    Prepare All Random Variables   
Test Teardown    Close Web Application



*** Test Cases ***
TC_07: create draft booking 
    [Documentation]    ทดสอบกรณีสร้าง Draft
    Verify Booking Success   ${RAND_DATE_FULL}  
    ...     ${RAND_LICENSE}        กระบี่            รถยนต์ 4 ที่นั่ง       
    ...     ${RAND_DRIVER_ID}      รับสินค้าขาเข้าปกติ            TG               
    ...     ภายในประเทศ/ท่าอื่น     10    30            ของมีค่า(TG)    
    ...      ${RAND_DEC_NO}    ${RAND_HAWB}
    Tracking Booking            ${GLOBAL_BOOKING_ID}            ${RAND_DEC_NO}               ${RAND_DATE_FULL}                ${RAND_HAWB}            ${RAND_LICENSE}    
    Sleep   10 seconds
      