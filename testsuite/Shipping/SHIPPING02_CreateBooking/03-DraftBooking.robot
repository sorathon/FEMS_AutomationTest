*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup       Run Keywords    Login As shipping User    AND    Prepare All Random Variables
Test Teardown    Close Web Application
Test Template   Verify Draft Booking

*** Test Cases ***
TC_07: create draft booking 
    [Documentation]    ทดสอบกรณีสร้าง Draft
           # [วันที่]             [ทะเบียน]          [จังหวัด]              [ประเภทรถ]          [ID คนขับ]
           ${RAND_DATE}        ${RAND_LICENSE}            กระบี่                  รถยนต์ 4 ที่นั่ง        ${RAND_DRIVER_ID} 
    #     [ประเภทหรือกรณี]       [รับสินค้าจากคลัง]    [ไปส่งสินค้าที่]         [เวลาเข้าพื้นที่]        [ประเภทสินค้า]
    ...    ${EMPTY}            TG                ภายในประเทศ/ท่าอื่น     10    30            ของมีค่า(TG)    
    #     [Declaration No.]    [HAWB]   
    ...    GH587333777777      VG778777777



       

    


    
   




