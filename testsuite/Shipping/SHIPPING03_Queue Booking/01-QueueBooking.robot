*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_QueueBooking_page.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup       Run Keywords    Login As shipping User    AND    Prepare All Random Variables   
Test Teardown    Close Web Application



*** Test Cases ***
TC_07: create draft booking 
    [Documentation]    ทดสอบ Queue Booking
    Queue Booking       2026-05-05       Queue       
    Search Auto By Booking ID             ${GLOBAL_BOOKING_ID}
      

               
