*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../pages/TMO/TMO_QueueManagment.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup   Run Keywords  Prepare All Random Variables   
...          AND            Login To System As Shipping User            
...          AND            Open Create Booking Page 
Test Teardown    Close Web Application



*** Test Cases ***
 Create Booking and Accept Queue with Mandatory Field
    [Documentation]    สร้าง Booking ใหม่โดย Shipping แล้วทำการ Accept Queue โดย TMO
    [Tags]    E2E    Positive
    Create New Booking And Check Booking status
    ...    SUCCESS    
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

    # --- STEP 2: อนุมัติคิว (ฝั่ง TMO) ---
    # เรียกใช้ Keyword ที่เราปรับปรุงใหม่ (สั้น กระชับ และ Reuse ได้)
    QueueAcceptSuccess    
    ...    booking_id=${GLOBAL_BOOKING_ID}    
    ...    date=${RAND_DATE_FULL}             
    ...    status=All    # ระบุสถานะเริ่มต้นที่ต้องการค้นหา
      