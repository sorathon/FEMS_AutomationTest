*** Settings ***
Library    String
Library    DateTime
Library    Collections

*** Keywords ***
Prepare All Random Variables
    ${date_full}                ${date_num}=       Get Random Date to TMO

    ${license}=    Get Random License Plate

    ${dec_no}           ${hawb_no}=    Generate Random DecNo And HAWB

    ${dec2_no}           ${hawb2_no}=    Generate Random DecNo2 And HAWB2

    ${driver_id_fmt}=    Get Random Driver ID

    ${final_list}=    Generate Random Product List    1    3

    ${single_list}=    Generate Random Product List    1    1     




    # --- เก็บตัวแปรไว้ใช้ ---
    # ใช้ชื่อเดือนคลิกปฏิทิน
    Set Global Variable    ${RAND_DATE_FULL}    ${date_full}
    Set Global Variable    ${RAND_DATE_NUM}     ${date_num}
    
    Set Global Variable    ${RAND_LICENSE}      ${license}
    Set Global Variable    ${RAND_DEC_NO}       ${dec_no}
    Set Global Variable    ${RAND_HAWB}         ${hawb_no}

    Set Global Variable    ${RAND_DEC2_NO}       ${dec2_no}
    Set Global Variable    ${RAND_HAWB2}         ${hawb2_no}

    Set Global Variable    ${RAND_DRIVER_ID}    ${driver_id_fmt}

    Set Global Variable    ${MANY_PRODUCT_LIST}    ${final_list}

     Set Global Variable    ${SINGLE_PRODUCT_LIST}    ${single_list}

Get Random License Plate
    ${rand_char}=      Generate Random String    2    กขคพยรล
    ${rand_num}=       Generate Random String    3    [NUMBERS]
    ${license}=        Set Variable    ${rand_char}${rand_num}
    [Return]    ${license}

Get Random Date to TMO
    ${random_days}=    Evaluate    random.randint(1, 60)    modules=random
    
    # 1. ได้ค่าแบบชื่อเดือน (Full Format)
    ${date_full}=    Get Current Date    increment=${random_days} days    result_format=%Y-%B-%d
    
    # 2. แปลงเป็นแบบตัวเลข (Numeric Format)
    ${date_num}=     Convert Date    ${date_full}    date_format=%Y-%B-%d    result_format=%Y-%m-%d
    
    # ส่งกลับไป 2 ค่าพร้อมกัน
    [Return]    ${date_full}        ${date_num}

Generate Random DecNo And HAWB
    ${dec_no}=         Generate Random String    14    [NUMBERS]
    ${hawb_no}=        Generate Random String    10    [UPPER][NUMBERS]
    [Return]    ${dec_no}    ${hawb_no}

Generate Random DecNo2 And HAWB2
    ${dec2_no}=         Generate Random String    14    [NUMBERS]
    ${hawb2_no}=        Generate Random String    10    [UPPER][NUMBERS]
    [Return]    ${dec2_no}    ${hawb2_no}

Get Random Driver ID
    ${driver_id}=      Generate Random String    13    [NUMBERS]
    # แปลง Format เลขบัตรประชาชนให้มีขีด (1-XXXX-XXXXX-XX-X)
    ${driver_id_fmt}=  Set Variable    1-${driver_id[1:5]}-${driver_id[5:10]}-${driver_id[10:12]}-${driver_id[12]}
    [Return]    ${driver_id_fmt}

Generate Random Product List
    [Arguments]    ${min_items}    ${max_items}
    ${final_list}=    Create List
    # สุ่มว่ารอบนี้จะมีสินค้ากี่ใบขน (เช่น 1-3 ใบ)
    ${count}=    Evaluate    random.randint(${min_items}, ${max_items})    modules=random
    
    FOR    ${index}    IN RANGE    ${count}
        # สุ่มเลขใบขนและ HAWB (สามารถปรับรูปแบบได้ตามต้องการ)
        ${rand_dec}=     Generate Random String    11    [NUMBERS]
        ${rand_hawb}=    Generate Random String    8     [UPPER][NUMBERS]
        
        # สร้าง Dictionary สินค้า 1 ชิ้น
        ${item}=    Create Dictionary    dec_no=DEC${rand_dec}    hawb=HWB${rand_hawb}
        IF    ${index} == 0
            Set Global Variable    ${RAND_DEC_NO}    DEC${rand_dec}
            Set Global Variable    ${RAND_HAWB}      HWB${rand_hawb}
        END
        
        # ใส่ลงใน List หลัก
        Append To List    ${final_list}    ${item}
    END
    RETURN    ${final_list}