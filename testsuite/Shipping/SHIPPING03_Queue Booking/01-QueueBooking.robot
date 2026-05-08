*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../resoures/utils/data_generator.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../pages/shipping/shipping_QueueBooking_page.robot



Test Setup   Run Keywords   Login To System As Shipping User   
...          AND            Prepare All Random Variables    
...          AND            Open Create Booking Page

Test Teardown    Close Web Application


    
*** Test Cases *** 
TC_11: Create Booking and Verify user can search and find existing booking in Queue Tracking     
   [Documentation]   สร้าง boking ใหม่จากนั้นหาคิวด้วยค่าที่ได้ใส่เเละได้จาก booking
   Create New Booking
    ...     SUCCESS        ${RAND_DATE_FULL}         7-7777-77777-77-7           กข1234        กระบี่       รถยนต์ 4 ที่นั่ง      รับสินค้าขาเข้าปกติ      
    ...      TG      ภายในประเทศ/ท่าอื่น    10  30   ของมีค่า(TG)   
    ...    ${SINGLE_PRODUCT_LIST}

    Open Queue Booking Page


    Search Booking In Queue Booking             booking_id=${GLOBAL_BOOKING_ID}      reserve_date=${RAND_DATE_NUM}    status=All
    

    #VERIFICATIONS: ตรวจสอบผลลัพธ์ว่าแสดงผลถูกต้อง
    Verify Booking Is Displayed In Search Result    ${GLOBAL_BOOKING_ID}
    Verify Date To TMO In Search Result             ${GLOBAL_BOOKING_ID}    ${RAND_DATE_NUM} 
    



