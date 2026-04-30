*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot

Test Setup       Login As shipping User
Test Teardown    Close Web Application
Test Template    Verify Booking Failed

*** Test Cases ***
TC_06: create booking fail when driver is unavailable
    [Documentation]    ทดสอบกรณีสร้าง booking ไม่สำเร็จ
    # [วันที่]      [ทะเบียน]   [จังหวัด]    [ประเภทรถ]        [ID คนขับ]
    2026-July-01    มก232    กระบี่    รถยนต์ 4 ที่นั่ง    7-7777-77777-77-7   
    #     [ประเภทหรือกรณี]    [รับสินค้าจากคลัง]   [ไปส่งสินค้าที่]         [เวลาเข้าพื้นที่]        [ประเภทสินค้า]
    ...    ${EMPTY}           TG             ภายในประเทศ/ท่าอื่น    10    30            ของมีค่า(TG)    
    #     [Declaration No.]    [HAWB]   
    ...    GH587333777777      VG778777777



       

    


    
   




