*** Keywords ***
Log Response
    [Arguments]    ${response}
    Log    Status: ${response.status_code}
    Log    Body: ${response.json()}




