*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_QueueBooking_page.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup       Run Keywords    Login As shipping User    AND    Prepare All Random Variables   
Test Teardown    Close Web Application



*** Test Cases ***
TC_07: create draft booking 
    [Documentation]    ทดสอบกรณีสร้าง Draft
    Queue Booking       2026-04-30       Queue       
    Search Auto By Booking ID         ${GLOBAL_BOOKING_ID}
    Search Auto By Date To TMO        ${RAND_DATE_NUM}     
      

               
