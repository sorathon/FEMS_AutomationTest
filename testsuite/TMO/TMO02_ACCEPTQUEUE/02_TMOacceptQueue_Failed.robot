*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../pages/TMO/TMO_QueueManagment.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup       Run Keywords    Login As TMO User  AND   Prepare All Random Variables   
Test Teardown    Close Web Application



*** Test Cases ***
TC_07: create draft booking 
    [Documentation]    ทดสอบการ accept Queue เเล้วสถานะไม่ใช่ Queue
    QueueAcceptFailed            ${EMPTY}            ${EMPTY}              2026-May-05           
    ...         ${EMPTY}            ${EMPTY}          status_expeted=Accept          

    
        
    
    
    
    
      