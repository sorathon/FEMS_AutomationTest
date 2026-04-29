*** Settings ***
Library    Browser

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
    Fill Text    xpath=//*[@id="queue-booking-tracking-search-reserveDate"]      ${date_to_tmo}


#####################################################################################################

    








Select Driver By id
    [Arguments]    ${driver_id}
    
    # สเต็ปที่ 1: พิมพ์ชื่อคนขับลงไปในช่องเลย เพื่อให้ระบบ Filter รายชื่อให้สั้นลง
    # (คำสั่ง Fill Text ใน Browser Library จะคลิกให้ก่อนพิมพ์อัตโนมัติ)
    Click    xpath=//*[@id="queue-booking-view-driver"]/ngx-select/div/div[2] 

    Click  xpath=//*[@id="queue-booking-view-driver"]/ngx-select/div/ngx-select-choices/ul/li[1]/a    
    
    Fill Text  xpath=//*[@id="queue-booking-tracking-search-driverTaxId"]   ${driver_id}

