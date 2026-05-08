*** Settings ***
Resource    ../../../resoures/config.robot
Resource    ../../../pages/shipping/shipping_TrackingBooking_page.robot
Resource    ../../../pages/shipping/shipping_createBooking_page.robot
Resource    ../../../resoures/utils/data_generator.robot

Test Setup       Run Keywords    Login To System As Shipping User    
...              AND             Prepare All Random Variables
...              AND             Open Create Booking Page
Test Teardown    Close Web Application

*** Test Cases ***
# --- ส่วนที่ 1: การเตรียมข้อมูล (Data Preparation) ---
Create New Draft Booking For Tracking
    [Documentation]    ขั้นตอนการสร้าง Booking เพื่อเอาเลขไปใช้ทดสอบ Tracking ในเคสถัดไป
    Create New Booking
    ...    SUCCESS             ${RAND_DATE_FULL}            ${RAND_DRIVER_ID}       ${RAND_LICENSE}                   กระบี่
    ...    รถยนต์ 4 ที่นั่ง              รับสินค้าขาเข้าปกติ
    ...    TG                        ภายในประเทศ/ท่าอื่น                 10  30
    ...    ของมีค่า(TG)                ${SINGLE_PRODUCT_LIST}    

                
    
    # เก็บค่า Booking ID ไว้ใน Global เพื่อให้เคสอื่นใน Suite เดียวกันเรียกใช้ได้
    #Set Global Variable    ${TARGET_BOOKING_ID}    ${GLOBAL_BOOKING_ID}


# --- ส่วนที่ 2: การทดสอบการค้นหาแยกตามฟิลด์ (Single Field Search) ---
Search Tracking By Booking ID
    [Tags]    Regression
    [Documentation]    ตรวจสอบว่าค้นหาด้วยเลข Booking ID แล้วเจอข้อมูลที่ถูกต้อง
    Tracking Booking    ${GLOBAL_BOOKING_ID}
    Verify Booking Is Displayed In Search Result    ${GLOBAL_BOOKING_ID}    

# Search Tracking By Declaration Number
#     [Tags]    Regression
#     [Documentation]    ตรวจสอบว่าค้นหาด้วยเลข Declaration No แล้วเจอข้อมูลที่ถูกต้อง
#     Tracking Booking    Declaration_No=${RAND_DEC_NO}

# Search Tracking By Date To TMO
#     [Tags]    Regression
#     [Documentation]    ตรวจสอบว่าค้นหาด้วยวันที่ Date To TMO แล้วเจอข้อมูลที่ถูกต้อง
#     Tracking Booking    Date_To_TMO=${RAND_DATE_FULL}


# # --- ส่วนที่ 3: การทดสอบแบบรวมทุกเงื่อนไข (Combined Search) ---
# Search Tracking By All Criteria (Full Match)
#     [Tags]    Critical
#     [Documentation]    ตรวจสอบการกรองข้อมูลแบบละเอียดที่สุด โดยใส่ทุกฟิลด์ที่ทราบค่า
#     Tracking Booking    
#     ...    BOOKING_ID=${TARGET_BOOKING_ID}
#     ...    Declaration_No=${RAND_DEC_NO}
#     ...    Date_To_TMO=${RAND_DATE_FULL}
#     ...    HAWD_NO=${RAND_HAWB}
#     ...    Licens_id=${RAND_LICENSE}
#     ...    Status_Tracking=Draft