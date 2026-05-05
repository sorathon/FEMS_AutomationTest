*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../resoures/utils/data_generator.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot


Test Setup       Run Keywords    Login As shipping User  AND   Prepare All Random Variables   
Test Teardown    Close Web Application



*** Test Cases ***
TC_05: create booking success
    [Documentation]    ทดสอบกรณีสร้าง booking สำเร็จ
      Verify Booking Success (Double)   ${RAND_DATE_FULL}  
    ...     ${RAND_LICENSE}        กระบี่            รถยนต์ 4 ที่นั่ง       
    ...     ${RAND_DRIVER_ID}      รับสินค้าขาเข้าปกติ            TG               
    ...     ภายในประเทศ/ท่าอื่น     10    30            ของมีค่า(TG)    
    ...      ${RAND_DEC_NO}    ${RAND_HAWB}   




       

    


    
   




