*** Settings ***
Library    Browser
Library    String
Resource   ../../pages/shipping/shipping_login_page.robot

*** Variables ***
#Login Page
${TXT_USERNAME}    xpath=//*[@id="login-username"]
${TXT_PASSWORD}    xpath=//*[@id="login-password"]
${BTN_LOGIN}       xpath=//*[@title="Login"]
${MSG_TOOLTIP}    css=.invalid-tooltip
${url_login}     https://uataotfems.netbay.co.th/fems/#/auth/shipping/login
${url_home}      https://uataotfems.netbay.co.th/fems/#/mainmenu/announcement

#Queue Booking
${MENU_QUEUE_BOOKING}    xpath=//*[@id="sidebar-menu-17"]
${MENU_CREATE_BOOKING}    xpath=//*[@id="queue-booking-tracking-btn-create"]



*** Keywords ***

Open Queue Booking Menu
    Click      ${MENU_QUEUE_BOOKING}

Open Create Booking Page
    Click      ${MENU_CREATE_BOOKING}

Select Driver By id
    [Arguments]    ${driver_id}
    
    # สเต็ปที่ 1: พิมพ์ชื่อคนขับลงไปในช่องเลย เพื่อให้ระบบ Filter รายชื่อให้สั้นลง
    # (คำสั่ง Fill Text ใน Browser Library จะคลิกให้ก่อนพิมพ์อัตโนมัติ)
    Click    xpath=//*[@id="queue-booking-view-driver"]/ngx-select/div/div[2] 

    Click  xpath=//*[@id="queue-booking-view-driver"]/ngx-select/div/ngx-select-choices/ul/li[1]/a    
    
    Fill Text  xpath=//*[@id="queue-booking-tracking-search-driverTaxId"]   ${driver_id}


Fill Vehicle infomation
    [Arguments]    ${driver_license}    ${vehicle_province}  ${driver_cartype}
    # --- 1. เลือกประเภทรถ ---
    # ใช้ ID แม่ (view-vehicle) นำทาง แล้วกดตัวที่มองเห็น
    Click        id=queue-booking-view-vehicle >> css=.ngx-select__toggle >> visible=true
    # เลือกตัวเลือกแรก
    Click        xpath=//*[@id="queue-booking-view-vehicle"]//ngx-select-choices//li[1]/a
    
    # --- 2. กรอกทะเบียน ---
    Fill Text    xpath=//input[@placeholder="ป้ายทะเบียน"] >> visible=true    ${driver_license}
    
    # --- 3. จัดการ Sidebar (ถ้าจำเป็นต้องปิดเหมือนเดิม) ---
    Click        id=sidebar-toggle-btn
    Sleep        2 seconds

    # --- 4. เลือกจังหวัด (ใช้เทคนิคเดียวกัน) ---
    # คลิกกาง Dropdown จังหวัด (ตัวที่มองเห็นภายใต้ ID vehicleProvince)
    Click        id=queue-booking-tracking-search-vehicleProvince >> css=.ngx-select__toggle >> visible=true
    
    # พิมพ์ชื่อจังหวัดในช่อง Search ของมันเอง
    Fill Text    id=queue-booking-tracking-search-vehicleProvince >> css=.ngx-select__search    ${vehicle_province}
    
    # รอให้ผลลัพธ์ขึ้นมาแล้วคลิก (ใช้ normalize-space เพื่อจัดการเว้นวรรคใน HTML)
    Click        xpath=//*[@id="queue-booking-tracking-search-vehicleProvince"]//ngx-select-choices//a[contains(normalize-space(.), '${vehicle_province}')]

    Click        id=vehicle-management-vehicle-type-id >> css=.ngx-select__toggle >> visible=true
    
    Fill Text    xpath=//*[@id="vehicle-management-vehicle-type-id"]/ngx-select/div/input    ${driver_cartype}  
    Click        xpath=//*[@id="vehicle-management-vehicle-type-id"]//ngx-select-choices//a[contains(normalize-space(.), '${driver_cartype}')]  


Fill Date to TMO
    [Arguments]    ${date_to_tmo}

    # แยกค่า
    ${year}    ${month}    ${day}    Split String    ${date_to_tmo}    -

    Click    //*[@id="queue-booking-tracking-search-reserveDate"]
    Wait For Elements State    .bs-datepicker-container    visible

    
    Click    (//div[contains(@class,"bs-datepicker-head")]//button[contains(@class,"current")])[2]

 
    Click    //span[normalize-space()="${year}"]


    Click    //span[normalize-space()="${month}"]

    Wait For Elements State    .bs-datepicker-body    visible
    ${day_int}    Convert To Integer    ${day}
    Click    (//div[contains(@class,"bs-datepicker-body")]//span[normalize-space()="${day_int}"])[1]


Fill infomation request Booking
    [Arguments]    ${bookingType}   ${bokingOrigin}   ${bookingDestination}    ${reserveHour}    ${reserveMinute}    ${goodsType}
    Select Options By    xpath=//select[@id='queue-booking-detail-bookingTypeId']    text   ${bookingType}
    Select Options By    xpath=//select[@id="queue-booking-detail-origin"]      text   ${bokingOrigin}
    Select Options By     xpath=//select[@id="queue-booking-detail-destination"]     text        ${bookingDestination}
    Fill Text    css=input[placeholder="HH"]    ${reserveHour}
    Fill Text    css=input[placeholder="MM"]    ${reserveMinute}
    Press Keys    css=input[placeholder="MM"]    Tab
    Select Options By    xpath=//select[@id="queue-booking-detail-goodsType"]   text   ${goodsType}

Fill Product list
    [Arguments]    ${declaration_number}   ${HAWB}
    Fill Text        xpath=//*[@id="queue-booking-detail-declarationNumber"]    ${declaration_number}
    Click      xpath=//*[@id="queue-booking-detail-search-declarationNumber"]
    Fill Text      xpath=//input[@id="queue-booking-detail-hawb"]      ${HAWB}}
    Click    xpath=//*[@id="queue-booking-detail-add-declarationNumber"] 
    Click    xpath=//*[@id="queue-booking-tracking-btn-search"]   

Submit Booking
    click    xpath=//*[@id="queue-booking-tracking-btn-submit"]  
    Click    xpath=//*[@id="queue-booking-tracking-btn-save"]
    Sleep    5 seconds
    Click    xpath=//*[@id="queue-booking-tracking-btn-save"]

Submit Booking failed
    click    xpath=//*[@id="queue-booking-tracking-btn-submit"]  

Submit Draft Booking 
    click    xpath=//*[@id="queue-booking-tracking-btn-draft"]
    

check booking success
    Wait For Elements State    xpath=//div[contains(@class, 'text-dark') and contains(., '20')]    visible    30s

    # 2. ดึงค่าออกมาเก็บในตัวแปร
    # ใช้ XPath ที่กระชับขึ้น: หา div ที่มีคลาส text-dark และอยู่ภายใต้โซนที่แสดงข้อมูลการจอง
    ${booking_id}=    Get Text    xpath=//div[contains(@class, 'text-dark') and contains(., '20')]
    Log To Console    \nSuccessfully Created Booking ID: ${booking_id}
    Set Global Variable    ${GLOBAL_BOOKING_ID}    ${booking_id}
    ${Queue_status}=    Get Text    xpath=//div[contains(@class, 'text-dark') and contains(., 'Queue')]
    Log To Console    Queue Status: ${Queue_status}

    Click   xpath=//*[@id="queue-booking-tracking-btn-back"]


check booking failed
    # แทนที่จะรอเลขจอง ให้รอข้อความแจ้งเตือนสีแดงแทน
    Wait For Elements State    text="กรุณาระบุข้อมูลคิวให้ครบทุกคิวก่อนทำการบันทึก"    visible    10s


check Draft booking 
    Wait For Elements State    xpath=//div[contains(@class, 'text-dark') and contains(., 'D')]    visible    30s
    ${Queue_status}=    Get Text    xpath=//div[contains(@class, 'text-dark') and contains(., 'Draft')]
    Log To Console    Queue Status: ${Queue_status}
    Click   xpath=//*[@id="queue-booking-tracking-btn-back"]
    
    
Verify Booking Success
    [Arguments]   
    ...    ${date_to_tmo}  
    ...    ${driver_license}   
    ...    ${vehicle_province}  
    ...    ${driver_cartype}     
    ...    ${driver_id}  
    ...    ${bookingType}   
    ...    ${bokingOrigin}   
    ...    ${bookingDestination}    
    ...    ${reserveHour}    
    ...    ${reserveMinute}    
    ...    ${goodsType}  
    ...    ${declaration_number}   
    ...    ${HAWB} 
    Open Queue Booking Menu
    Open Create Booking Page
    Fill Date to TMO    ${date_to_tmo}
    IF   '${driver_id}' != '${EMPTY}'
        Select Driver By id       ${driver_id}
    END
    IF  '${driver_license}' != '${EMPTY}' and '${vehicle_province}' != '${EMPTY}' and '${driver_cartype}' != '${EMPTY}'
        Fill Vehicle infomation    ${driver_license}    ${vehicle_province}      ${driver_cartype}
    END
    IF  '${bookingType}' != '${EMPTY}' and '${bokingOrigin}' != '${EMPTY}' and '${bookingDestination}' != '${EMPTY}' and '${reserveHour}' != '${EMPTY}' and '${reserveMinute}' != '${EMPTY}' and '${goodsType}' != '${EMPTY}'
        Fill infomation request Booking     
        ...    ${bookingType}   
        ...    ${bokingOrigin}   
        ...    ${bookingDestination}    
        ...    ${reserveHour}    
        ...    ${reserveMinute}    
        ...    ${goodsType} 
    END
    IF     '${declaration_number}' != '${EMPTY}' and '${HAWB}' != '${EMPTY}'
        Fill Product list    ${declaration_number}   ${HAWB} 
    END
    Submit Booking
    check booking success

Verify Booking Failed
    [Arguments]   
    ...    ${date_to_tmo}  
    ...    ${driver_license}   
    ...    ${vehicle_province}  
    ...    ${driver_cartype}     
    ...    ${driver_id}  
    ...    ${bookingType}   
    ...    ${bokingOrigin}   
    ...    ${bookingDestination}    
    ...    ${reserveHour}    
    ...    ${reserveMinute}    
    ...    ${goodsType}  
    ...    ${declaration_number}   
    ...    ${HAWB} 
    Open Queue Booking Menu
    Open Create Booking Page
    Fill Date to TMO    ${date_to_tmo}
    IF   '${driver_id}' != '${EMPTY}'
        Select Driver By id       ${driver_id}
    END
    IF  '${driver_license}' != '${EMPTY}' or '${vehicle_province}' != '${EMPTY}' or '${driver_cartype}' != '${EMPTY}'
        Fill Vehicle infomation    ${driver_license}    ${vehicle_province}      ${driver_cartype}
    END
    IF  '${bookingType}' != '${EMPTY}' or '${bokingOrigin}' != '${EMPTY}' or '${bookingDestination}' != '${EMPTY}' or '${reserveHour}' != '${EMPTY}' or '${reserveMinute}' != '${EMPTY}' or '${goodsType}' != '${EMPTY}'
        Fill infomation request Booking     
        ...    ${bookingType}   
        ...    ${bokingOrigin}   
        ...    ${bookingDestination}    
        ...    ${reserveHour}    
        ...    ${reserveMinute}    
        ...    ${goodsType} 
    END
    IF     '${declaration_number}' != '${EMPTY}' or '${HAWB}' != '${EMPTY}'
        Fill Product list    ${declaration_number}   ${HAWB} 
    END 
    Submit Booking failed
    check booking failed


Verify Draft Booking 
    [Arguments]   
    ...    ${date_to_tmo}  
    ...    ${driver_license}   
    ...    ${vehicle_province}  
    ...    ${driver_cartype}     
    ...    ${driver_id}  
    ...    ${bookingType}   
    ...    ${bokingOrigin}   
    ...    ${bookingDestination}    
    ...    ${reserveHour}    
    ...    ${reserveMinute}    
    ...    ${goodsType}  
    ...    ${declaration_number}   
    ...    ${HAWB} 
    Open Queue Booking Menu
    Open Create Booking Page
    Fill Date to TMO    ${date_to_tmo}
    IF   '${driver_id}' != '${EMPTY}'
        Select Driver By id       ${driver_id}
    END
    IF  '${driver_license}' != '${EMPTY}' or '${vehicle_province}' != '${EMPTY}' or '${driver_cartype}' != '${EMPTY}'
        Fill Vehicle infomation    ${driver_license}    ${vehicle_province}      ${driver_cartype}
    END
    IF  '${bookingType}' != '${EMPTY}' or '${bokingOrigin}' != '${EMPTY}' or '${bookingDestination}' != '${EMPTY}' or '${reserveHour}' != '${EMPTY}' or '${reserveMinute}' != '${EMPTY}' or '${goodsType}' != '${EMPTY}'
        Fill infomation request Booking     
        ...    ${bookingType}   
        ...    ${bokingOrigin}   
        ...    ${bookingDestination}    
        ...    ${reserveHour}    
        ...    ${reserveMinute}    
        ...    ${goodsType} 
    END
    IF     '${declaration_number}' != '${EMPTY}' or '${HAWB}' != '${EMPTY}'
        Fill Product list    ${declaration_number}   ${HAWB} 
    END 
    Submit Draft Booking 
    check Draft booking 

             