*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../resoures/utils/data_generator.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot

    

Test Setup   Run Keywords   Login To System As Shipping User    AND    Prepare All Random Variables
   


Test Teardown    Close Web Application


    

*** Test Cases *** 
Scenario: Multi-Product Booking with Random Data
    [Template]    Booking Operation Template
    SUCCESS        2026-July-10         7-7777-77777-77-7           กข1234        กระบี่       รถยนต์ 4 ที่นั่ง      รับสินค้าขาเข้าปกติ        TG      ภายในประเทศ/ท่าอื่น    10  30   ของมีค่า(TG)      GH587333777799     HAWB001
    ...    ${RAND_PRODUCT_LIST}
Scenario: Create Complete Booking Success
    [Template]    Booking Operation Template
   
    SUCCESS        2026-July-10         7-7777-77777-77-7           กข1234        กระบี่       รถยนต์ 4 ที่นั่ง      รับสินค้าขาเข้าปกติ        TG      ภายในประเทศ/ท่าอื่น    10  30   ของมีค่า(TG)      GH587333777799     HAWB001
# TC_05: create booking success
#     [Documentation]    ทดสอบกรณีสร้าง booking สำเร็จ
#     # [วันที่]      [ทะเบียน]   [จังหวัด]    [ประเภทรถ]        [ID คนขับ]
#     2026-July-01    มก232    กระบี่    รถยนต์ 4 ที่นั่ง    7-7777-77777-77-7   
#     #     [ประเภทหรือกรณี]    [รับสินค้าจากคลัง]   [ไปส่งสินค้าที่]         [เวลาเข้าพื้นที่]        [ประเภทสินค้า]
#     ...    รับสินค้าขาเข้าปกติ    TG               ภายในประเทศ/ท่าอื่น    10    30            ของมีค่า(TG)    
#     #     [Declaration No.]    [HAWB]   
#     ...    GH587333777777      VG778777777




       

    


    
   




