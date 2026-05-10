*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../pages/TMO/TMO_QueueManagment.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup       Run Keywords    Login As TMO User  AND   Prepare All Random Variables   
Test Teardown    Close Web Application

*** Test Cases ***
Try to Accept an already Accepted booking
    [Documentation]    ทดสอบว่ารายการที่มีสถานะเป็น Accept อยู่แล้ว ไม่สามารถกด Accept ซ้ำได้ (ต้องเจอ Error)
    [Tags]    Negative    Validation

    QueueAcceptFailed    
    ...    booking_id=${EMPTY}    
    ...    dec_no=${EMPTY}    
    ...    date=2026-May-05    
    ...    hawb=${EMPTY}    
    ...    plate=${EMPTY}    
    ...    status=Accept
        
    
    
    
    
      