*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../pages/TMO/TMO_assignDock.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup   Run Keywords  Prepare All Random Variables   
...          AND            Login To System As Shipping User            
...          AND            Open Create Booking Page  

Test Teardown    Close Web Application



*** Test Cases ***
 E2E - Create booking, accept multiple items and assign dock successfully
    [Documentation]    ทดสอบการ    accept หลายรายการ
 
    Assign Dock Success Flow    37 (Vehicle = 0)    60

    
        
    
    
    
    
      