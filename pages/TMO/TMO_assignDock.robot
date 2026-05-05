*** Settings ***
Library    Browser
Library    String
Resource   ../../pages/TMO/TMO_Login.robot
Resource   ../../resoures/config.robot
Resource   ../../pages/shipping/shipping_createBooking_page.robot
Resource   ../../pages/TMO/TMO_QueueManagment.robot


*** Keywords ***
AssigDockSuccess
    [Arguments]         ${select-value}           ${time_in_TMO}  
      
    Verify Booking Success           ${RAND_DATE_FULL}  
    ...     ${RAND_LICENSE}        กระบี่            รถยนต์ 4 ที่นั่ง       
    ...     ${RAND_DRIVER_ID}      รับสินค้าขาเข้าปกติ            TG               
    ...     ภายในประเทศ/ท่าอื่น     10    30            ของมีค่า(TG)    
    ...      ${RAND_DEC_NO}    ${RAND_HAWB}
    Login As TMO User
    Click    css=button.swal2-confirm
    Open QUEUEMANAGMENT Menu
    Open IMPORT Page
    Sleep     1     seconds
    Tracking Booking     ${GLOBAL_BOOKING_ID}     ${RAND_DEC_NO}            ${RAND_DATE_FULL}   
    ...    ${RAND_HAWB}       ${EMPTY}           status_expeted=All
    check assignDock success        ${select-value}           ${time_in_TMO}

    



Tracking Booking
    [Arguments]    ${BOOKING_ID}=${EMPTY}    ${Declaration_No}=${EMPTY}      ${Date_To_TMO}=${EMPTY}    
    ...    ${HAWD_NO}=${EMPTY}       ${Licens_id}=${EMPTY}        ${status_expeted}=${EMPTY}

    
    # เข้าสู่หน้า Tracking
    Click    xpath=//button[@id="sidebar-toggle-btn"]
    
    Run Keyword If    '${BOOKING_ID}' != '${EMPTY}'         Fill Text    xpath=//*[@id="tracking-search-search-bookingReferenceNumber"]    ${BOOKING_ID}
    Run Keyword If    '${Declaration_No}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-declarationNumber"]       ${Declaration_No}
    Run Keyword If    '${HAWD_NO}' != '${EMPTY}'    Fill Text    xpath=//*[@id="tracking-search-search-hawb"]    ${HAWD_NO}}
    

    Select Status           status_value=${status_expeted}

    Fill Text   xpath=//*[@id="tracking-search-search-vehicleNumber"]    ${Licens_id}


    IF    '${Date_To_TMO}' != '${EMPTY}'
        Fill Date to TMO Tracking    ${Date_To_TMO}
    END

    Click    xpath=//button[@id="tracking-search-btn-search"]
    # แนะนำให้เพิ่มการรอ Loading Spinner หายไปตรงนี้ (ถ้าหน้าเว็บมี)
    Sleep    2s    # ให้เวลาระบบ Render ผลลัพธ์ใหม่

    # --- STEP 3: ตรวจสอบผลการค้นหา (Smart Verification) ---
    # 1. ตรวจสอบ Booking ID (ถ้ามีการระบุ)
    IF    '${BOOKING_ID}' != '${EMPTY}'
        Count Search Result By Booking ID    ${BOOKING_ID}
    END

    # 2. ตรวจสอบ Declaration No (ถ้ามีการระบุ)
    IF    '${Declaration_No}' != '${EMPTY}'
        Count Search Result By Declaration No    ${Declaration_No}
    END
    
    # 3. ตรวจสอบ Date to TMO (ถ้ามีการระบุ) 
    # พิเศษ: ถ้ามี Booking ID ด้วย เราจะเช็คว่า "ID นี้ มีวันที่ตรงไหม" ในใบเดียวกัน

    IF   '${HAWD_NO}' != '${EMPTY}'
        Count Search Result By HAWB    ${HAWD_NO}        
    END
    Verify Status in Search Result    expected_status=Queue

    # --- ส่วนการคลิกเลือกรายการ (Action) ---

    # 1. รอให้ Checkbox ปรากฏและทำการเลือก (Check)
    # ใช้ ID เจาะจงที่ตัวแรก (Index 0)
    Wait For Elements State    id=queue-management-tracking-selected-all    visible    timeout=10s
    Check Checkbox             id=queue-management-tracking-selected-all

    Click    xpath=//*[@id="tracking-management-btn-multiple-accept"]
    # 2. ตรวจสอบว่าปุ่ม Accept พร้อมให้กดหรือยัง (หลังติ๊กแล้วปุ่มควรจะกดได้)
    Click    xpath=//div[@class="modal-content"]//button[@id="tracking-management-btn-multiple-accept"]

    Verify Status in Search Result    expected_status=Accept

    # --- ส่วนการคลิกเลือกรายการ (Action) ---

    # 1. รอให้ Checkbox ปรากฏและทำการเลือก (Check)
    # ใช้ ID เจาะจงที่ตัวแรก (Index 0)
    Wait For Elements State    id=queue-management-tracking-check-0    visible    timeout=10s
    Check Checkbox             id=queue-management-tracking-check-0

check assignDock success
    [Arguments]    ${select-value}        ${time_in_TMO}    
     Click    xpath=//*[@id="channel-management-btn-search"]

    Select ngx-select Value           ${select-value}        

    Sleep    3s

    # เลือกตัวเลือกที่มี value="30"
    Select Options By    xpath=//select[@id="popup-cancel-timeAuthorizeToGoods"]    value    ${time_in_TMO}    
    
    Sleep   5  seconds
    
    Click    xpath=/html/body/modal-container/div[2]/div/app-queue-management-assign-channel/div[3]/button[2]
    
    Verify Status in Search Result    expected_status=Allow to TMO





Select ngx-select Value
    [Arguments]    ${target_value}
    
    # 1. คลิกเปิด Dropdown
    Click    xpath=//div[contains(@class, "ngx-select__toggle")]
    
    # 2. นิยาม Locator ของรายการตัวเลือก
    # โครงสร้างคือ <a> ที่ครอบ <span> ที่มีข้อความที่เราต้องการ
    ${item_locator}=    Set Variable    xpath=//ul[contains(@class, "ngx-select__choices")]//a[contains(@class, "ngx-select__item")]//span[normalize-space(.)="${target_value}"]
    
    # 3. รอให้รายการนั้นปรากฏ (สำคัญมาก เพราะ Angular อาจใช้เวลาเรนเดอร์ List)
    Wait For Elements State    ${item_locator}    visible    timeout=10s
    
    # 4. คลิกเลือกค่า
    Click    ${item_locator}