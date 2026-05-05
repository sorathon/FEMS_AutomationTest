*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../pages/TMO/TMO_QueueManagment.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup       Run Keywords    Login As shipping User  AND   Prepare All Random Variables   
Test Teardown    Close Web Application



*** Test Cases ***
TC_07: create draft booking 
    [Documentation]    ทดสอบการ accept Queue สถานะต้องเปลี่ยนจาก Queue เป็น Accept
    Verify Booking Success       ${RAND_DATE_FULL}  
    ...     ${RAND_LICENSE}        กระบี่            รถยนต์ 4 ที่นั่ง       
    ...     ${RAND_DRIVER_ID}      รับสินค้าขาเข้าปกติ            TG               
    ...     ภายในประเทศ/ท่าอื่น     10    30            ของมีค่า(TG)    
    ...      ${RAND_DEC_NO}    ${RAND_HAWB}
    QueueAcceptSuccess            ${GLOBAL_BOOKING_ID}            ${EMPTY}               ${RAND_DATE_FULL}           
    ...         ${EMPTY}            ${EMPTY}          status_expeted=All      

    
        
    
    
    
    
      