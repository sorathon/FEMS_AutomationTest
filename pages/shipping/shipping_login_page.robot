*** Settings ***
Library    Browser

*** Variables ***
${TXT_USERNAME}    xpath=//*[@id="login-username"]
${TXT_PASSWORD}    xpath=//*[@id="login-password"]
${BTN_LOGIN}       xpath=//*[@title="Login"]
# เพิ่ม Locator สำหรับ Tooltip โดยอิงจากคลาส invalid-tooltip
${MSG_TOOLTIP}     css=.invalid-tooltip

*** Keywords ***
Input Login Credentials
    [Arguments]    ${username}    ${password}
    Fill Text    ${TXT_USERNAME}    ${username}
    Fill Text    ${TXT_PASSWORD}    ${password}

Click Login Button
    Click    ${BTN_LOGIN}

# เพิ่ม Keyword สำหรับตรวจ Tooltip สีแดงโดยเฉพาะ
Verify Validation Tooltip
    [Arguments]    ${expected_text}
    # Browser Library จะฉลาดพอที่จะรอจนกว่า div ตัวนี้จะเด้งขึ้นมา แล้วค่อยดึงข้อความมาเทียบ
    Get Text    ${MSG_TOOLTIP}    contains    ${expected_text}