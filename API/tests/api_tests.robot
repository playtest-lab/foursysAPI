*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary
Library    String

*** Variables ***
${BROWSER}    Chrome
${URL}        https://reqres.in
${BASE_URL}    https://reqres.in/api
${CREATED_USER_ID}    ${EMPTY}

*** Test Cases ***
Acessar url
    Open Browser    ${URL}    ${BROWSER}
    
POST New User
    [Documentation]    Cadastro de novo usuário
    [Tags]    API
    Create Session    reqres    ${BASE_URL}

    ${payload}=    Create Dictionary    name=John Doe    job=Tester
    ${response}=    POST On Session    reqres    /users    data=${payload}
    Should Be Equal As Strings    ${response.status_code}    201

    # Validate all fields and field types
    ${created_user}=    Set Variable    ${response.json()}
    Log    Created User: ${created_user}
    
    Validate Field Exists    ${created_user}    id
    Should Be String    ${created_user['id']} 
    Validate Field Exists    ${created_user}    name
    Should Be String   ${created_user['name']}
    Validate Field Exists    ${created_user}    job
    Should Be String    ${created_user['job']} 
    Validate Field Exists    ${created_user}    createdAt
    
    Set Global Variable    ${CREATED_USER_ID}    ${created_user['id']}

GET User Create
    [Documentation]    Busca de novo usuário criado
    [Tags]    API
    Create Session    reqres    ${BASE_URL}

    ${response}=    GET On Session    reqres    /users/${CREATED_USER_ID}
    Should Be Equal As Strings    ${response.status_code}    200

PUT User Create
    [Documentation]    Atualização do novo usuário
    [Tags]    API
    Create Session    reqres    ${BASE_URL}

    ${payload}=    Create Dictionary    name=Sarah Doe    job=zion resident
    ${response}=    PUT On Session    reqres    /users/${CREATED_USER_ID}    data=${payload}
    Should Be Equal As Strings    ${response.status_code}    201

    # Validate all fields and field types
    ${created_user}=    Set Variable    ${response.json()}
    Log    Created User: ${created_user}
    
    Validate Field Exists    ${created_user}    id
    Should Be String    ${created_user['id']} 
    Validate Field Exists    ${created_user}    name
    Should Be String   ${created_user['name']}
    Validate Field Exists    ${created_user}    job
    Should Be String    ${created_user['job']} 
    Validate Field Exists    ${created_user}    createdAt
    
    Set Global Variable    ${CREATED_USER_ID}    ${created_user['id']}

Delete User Create
    [Documentation]    Delete do novo usuário criado
    [Tags]    API
    Create Session    reqres    ${BASE_URL}

    ${response}=    DELETE On Session    reqres    /users/${CREATED_USER_ID}
    Should Be Equal As Strings    ${response.status_code}    204

Get User Delete
    [Documentation]    Validar a exclusão do novo usuário criado
    [Tags]    API
    Create Session    reqres    ${BASE_URL}

    ${response}=    GET On Session    reqres    /users/${CREATED_USER_ID}
    Should Be Equal As Strings    ${response.status_code}    404

*** Keywords ***
Validate Field Exists
    [Arguments]    ${dictionary}    ${field}
    Run Keyword If    "${field}" not in "${dictionary}"    Fail    Field '${field}' does not exist in dictionary ${dictionary}