*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../pages/TMO/TMO_assignDock.robot
Resource    ../../../resoures/utils/data_generator.robot
 
Test Setup       Run Keywords    Login As shipping User  AND   Prepare All Random Variables   
Test Teardown    Close Web Application



*** Test Cases ***
TC_07: create draft booking 
    [Documentation]    ทดสอบการ    accept หลายรายการ
    AssigDockSuccess    select-value=36 (Vehicle = 0)    time_in_TMO=60

    
        
    
    
    
    
      