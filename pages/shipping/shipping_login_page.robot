*** Settings ***
Library    Browser
Library    String

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
Input Login Credentials
    [Arguments]    ${username}    ${password}
    Fill Text    ${TXT_USERNAME}    ${username}
    Fill Text    ${TXT_PASSWORD}    ${password}

Click Login Button
    Click    ${BTN_LOGIN}
    Sleep  3 seconds


Verify Validation Tooltip
    [Arguments]    ${expected_text}
    Get Text    ${MSG_TOOLTIP}    contains    ${expected_text}

Verify Login Success
    Get Url  contains  ${url_home} 

Verify Login Failed
    [Arguments]    ${expected_text}=Login Failed
    Get Url  contains  ${url_login}
    Get Text    xpath=//*[@id="swal2-title"]    contains    ${expected_text}
Verify Login Empty
    [Arguments]   ${username}    ${password}    ${expected_tooltip}
    Input Login Credentials    ${username}         ${password}
    Click Login Button
    Verify Validation Tooltip    ${expected_tooltip}


#####################################################################################################

Open Queue Booking Menu
    Click      ${MENU_QUEUE_BOOKING}

Open Create Booking Page
    Click      ${MENU_CREATE_BOOKING}



#####################################################################################################
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
    Select Options By    xpath=//select[@id='queue-booking-detail-bookingTypeId']    text   รับสินค้าขาเข้าปกติ
    Select Options By    xpath=//select[@id="queue-booking-detail-origin"]      text   TG
    Select Options By     xpath=//select[@id="queue-booking-detail-destination"]     text    ภายในประเทศ/ท่าอื่น
    Fill Text    css=input[placeholder="HH"]    10
    Fill Text    css=input[placeholder="MM"]    30
    Press Keys    css=input[placeholder="MM"]    Tab
    Select Options By    xpath=//select[@id="queue-booking-detail-goodsType"]   text   ของมีค่า(TG)

Fill Product list
    [Arguments]    ${declaration_number}   ${HAWB}
    Fill Text        xpath=//*[@id="queue-booking-detail-declarationNumber"]    ${declaration_number}
    Click      xpath=//*[@id="queue-booking-detail-search-declarationNumber"]
    Fill Text      xpath=//input[@id="queue-booking-detail-hawb"]      ${HAWB}}
    Click    xpath=//*[@id="queue-booking-detail-add-declarationNumber"]    
    Click    xpath=//*[@id="queue-booking-tracking-btn-search"]
    click    xpath=//*[@id="queue-booking-tracking-btn-submit"]  
    Click    xpath=//*[@id="queue-booking-tracking-btn-save"]
    Sleep    5 seconds
    Click    xpath=//*[@id="queue-booking-tracking-btn-save"]

check booking success
    Wait For Elements State    xpath=//div[contains(@class, 'text-dark') and contains(., '20')]    visible    30s

    # 2. ดึงค่าออกมาเก็บในตัวแปร
    # ใช้ XPath ที่กระชับขึ้น: หา div ที่มีคลาส text-dark และอยู่ภายใต้โซนที่แสดงข้อมูลการจอง
    ${booking_id}=    Get Text    xpath=//div[contains(@class, 'text-dark') and contains(., '20')]
    Log To Console    \nSuccessfully Created Booking ID: ${booking_id}

    Click   xpath=//*[@id="queue-booking-tracking-btn-back"]
    
    
    
    
    

#####################################################################################################

    








Select Driver By id
    [Arguments]    ${driver_id}
    
    # สเต็ปที่ 1: พิมพ์ชื่อคนขับลงไปในช่องเลย เพื่อให้ระบบ Filter รายชื่อให้สั้นลง
    # (คำสั่ง Fill Text ใน Browser Library จะคลิกให้ก่อนพิมพ์อัตโนมัติ)
    Click    xpath=//*[@id="queue-booking-view-driver"]/ngx-select/div/div[2] 

    Click  xpath=//*[@id="queue-booking-view-driver"]/ngx-select/div/ngx-select-choices/ul/li[1]/a    
    
    Fill Text  xpath=//*[@id="queue-booking-tracking-search-driverTaxId"]   ${driver_id}

