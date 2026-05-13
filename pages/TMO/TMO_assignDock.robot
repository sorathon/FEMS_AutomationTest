*** Settings ***
Documentation      Keywords สำหรับการจัดการ Queue และ Assign Dock ในระบบ TMO
Library            Browser
Library            String
Resource           ../../pages/TMO/TMO_Login.robot
Resource           ../../resoures/config.robot              
Resource           ../../pages/shipping/shipping_createBooking_page.robot
Resource           ../../pages/TMO/TMO_QueueManagment.robot

*** Variables ***
${LOCATOR_ACCEPT_BTN}           xpath=//*[@id="tracking-management-btn-multiple-accept"]
${LOCATOR_MODAL_ACCEPT_BTN}     xpath=//div[@class="modal-content"]//button[@id="tracking-management-btn-multiple-accept"]

*** Keywords ***
Assign Dock Success Flow
    [Documentation]    Flow หลักในการตรวจสอบ Booking, Login และ Assign Dock จนสำเร็จ
    [Arguments]        ${select_value}    ${time_in_tmo}
    
    # # 1. ตรวจสอบข้อมูล Booking เบื้องต้น
    #  Verify Booking Success 
    # ...    ${RAND_DATE_FULL}    ${RAND_LICENSE}    กระบี่    รถยนต์ 4 ที่นั่ง
    # ...    ${RAND_DRIVER_ID}    รับสินค้าขาเข้าปกติ    TG    ภายในประเทศ/ท่าอื่น
    # ...    10    30    ของมีค่า(TG)    ${RAND_DEC_NO}    ${RAND_HAWB}
    Create New Booking And Check Booking status
    ...    SUCCESS    
    ...    ${RAND_DATE_FULL}    
    ...    ${RAND_DRIVER_ID}    
    ...    ${RAND_LICENSE}    
    ...    กระบี่
    ...    รถยนต์ 4 ที่นั่ง    
    ...    รับสินค้าขาเข้าปกติ
    ...    TG    
    ...    ภายในประเทศ/ท่าอื่น    
    ...    10    30
    ...    ของมีค่า(TG)    
    ...    ${SINGLE_PRODUCT_LIST}
     ${hawb_value}=    Set Variable    ${SINGLE_PRODUCT_LIST[0]['hawb']}
    Log To Console    Extracted HAWB: ${hawb_value}
    
    #ถ้าค่าถูกต้องค่อยทำให้เป็น Global
    Set Global Variable    ${GLOBAL_HAWB}    ${hawb_value}
    # 2. ขั้นตอนการจัดการ Queue
    Login As TMO User
    Click    css=button.swal2-confirm
    Navigate To Import Page
    
    
    
    # ค้นหาและระบุสถานะที่ต้องการ
    Search Booking By Criteria
    ...    booking_id=${GLOBAL_BOOKING_ID}
    ...    declaration_no=${EMPTY}
    ...    date_to_tmo=${RAND_DATE_FULL}
    ...    hawb_no=${GLOBAL_HAWB}
    ...    status_expected=All

    Accept Selected Booking
    Assign Docking Channel    ${select_value}    ${time_in_tmo}


Search Booking By Criteria
    [Documentation]    Keyword สำหรับ Fill ข้อมูลค้นหาในหน้า Tracking
    [Arguments]    ${booking_id}=${EMPTY}    ${declaration_no}=${EMPTY}    ${date_to_tmo}=${EMPTY}
    ...            ${hawb_no}=${EMPTY}       ${license_id}=${EMPTY}        ${status_expected}=${EMPTY}

    Click    id=sidebar-toggle-btn
    
    IF    '${booking_id}' != '${EMPTY}'
        Fill Text    id=tracking-search-search-bookingReferenceNumber    ${booking_id}
    END
    
    IF    '${declaration_no}' != '${EMPTY}'
        Fill Text    id=tracking-search-search-declarationNumber         ${declaration_no}
    END

    IF    '${hawb_no}' != '${EMPTY}'
        Fill Text    id=tracking-search-search-hawb                      ${hawb_no}
    END

    IF    '${status_expected}' != '${EMPTY}'
        Select Status    status_value=${status_expected}
    END

    Fill Text    id=tracking-search-search-vehicleNumber    ${license_id}

    IF    '${date_to_tmo}' != '${EMPTY}'
        Fill Date to TMO Tracking    ${date_to_tmo}
    END

    Click    id=tracking-search-btn-search
    
    # แก้ไขจุดนี้: ใช้ Wait For Elements State แทน

Accept Selected Booking
    [Documentation]    เลือกรายการที่ค้นหาได้และกดยอมรับ (Accept)
    Wait For Elements State    id=queue-management-tracking-selected-all    visible    timeout=10s
    Check Checkbox             id=queue-management-tracking-selected-all
    
    Click    ${LOCATOR_ACCEPT_BTN}
    Wait For Elements State    ${LOCATOR_MODAL_ACCEPT_BTN}    visible
    Click    ${LOCATOR_MODAL_ACCEPT_BTN}
    
    Verify Status in Search Result    expected_status=Accept


# Assign Docking Channel
#     [Documentation]    เลือกช่องทาง (Dock) และกำหนดเวลาในการอนุญาตเข้าพื้นที่
#     [Arguments]    ${dock_value}    ${time_limit}
    
#     # เลือกรายการแรกในตารางเพื่อ Assign
#     Wait For Elements State    id=queue-management-tracking-check-0    visible
#     Check Checkbox             id=queue-management-tracking-check-0
    
#     Click    id=channel-management-btn-search
#     Select Ngx Dropdown Value    ${dock_value}

#     # เลือกเวลา

#     Select Options By    xpath=//select[@id="popup-cancel-timeAuthorizeToGoods"]    value    ${time_limit}  
    
#     # กดปุ่มยืนยัน (ควรเปลี่ยน XPath เป็น ID หรือ Class ที่เจาะจง)
#     Click    xpath=//app-queue-management-assign-channel//button[contains(., "ยืนยัน") or contains(., "Confirm")]
    
#     Verify Status in Search Result    expected_status=Allow to TMO


Assign Docking Channel
    [Arguments]    ${dock_value}    ${time_limit}
    ${clean_time}=    Strip String    ${time_limit}

    Wait For Elements State    id=queue-management-tracking-check-0    visible
    Check Checkbox             id=queue-management-tracking-check-0
    Click    id=channel-management-btn-search
    
    Sleep  2s
    Select Ngx Dropdown Value    ${dock_value}

    Wait For Elements State    xpath=//select[@id="popup-cancel-timeAuthorizeToGoods"]/option[@value="${clean_time}"]    attached
    
    Select Options By    xpath=//select[@id="popup-cancel-timeAuthorizeToGoods"]    value    ${clean_time}    
    # 4. กดยืนยัน
    Click    xpath=//app-queue-management-assign-channel//button[contains(., "ยืนยัน") or contains(., "Confirm")]

    Verify Status in Search Result    expected_status=Allow to TMO


Select Ngx Dropdown Value
    [Arguments]    ${target_value}
    Click    xpath=//div[contains(@class, "ngx-select__toggle")]
    ${item_locator}=    Set Variable    xpath=//ul[contains(@class, "ngx-select__choices")]//a[contains(@class, "ngx-select__item")]//span[normalize-space(.)="${target_value}"]
    Wait For Elements State    ${item_locator}    visible    timeout=10s
    Click    ${item_locator}