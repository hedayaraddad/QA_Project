*** Settings ***
Test Setup        setupHttpContext
Test Teardown     tearDown
Force Tags        reqres
Library           HttpLibrary.HTTP

*** variables ***
${response_status}    ${EMPTY}
${response_body}    ${EMPTY}
${base_url}       reqres.in

*** Test Cases ***
Get_ListUsers
    HttpLibrary.HTTP.GET    /api/users?page=2
    Response Status Code Should Equal    200
    Response Status Code Should Not Equal    401
    ${response_body}    Get Response Body
    Log To Console    ${response_body}
    Response Should Have Header    connection
    Log Response Headers

Get_SingleUser
    HttpLibrary.HTTP.GET    /api/users/2
    ${response_body}    Get Response Body
    Log To Console    ${response_body}
    Response Status Code Should Not Equal    501

Get_notFoundUser
    Run Keyword And Ignore Error    HttpLibrary.HTTP.GET    /api/users/23
    ${response_body}    Get Response Body
    log    ${response_body}

Post_CreateUser
    ${body}    Set Json Value    {"name":"name","job":"job"}    /name    "morpheus"
    ${body}    Set Json Value    ${body}    /job    "leader"
    Set Request Body    ${body}
    HttpLibrary.HTTP.POST    /api/users
    ${response_body}    Get Response Body
    Log To Console    ${response_body}

Put_UpdateUser
    ${body}    Set Json Value    {"name":"name","job":"job"}    /name    "morpheus"
    ${body}    Set Json Value    ${body}    /job    "zion resident"
    Set Request Body    ${body}
    HttpLibrary.HTTP.PUT    /api/users/2
    ${response_body}    Get Response Body
    Log To Console    ${response_body}

Delete_User
    DELETE    /api/users/2
    Response Status Code Should Equal    204

Register_unsuccessful
    ${body}    Set Json Value    {"email":"email"}    /email    "ev.t@reqres.in"
    log    ${body}
    Set Request Body    ${body}
    Run Keyword And Ignore Error    HttpLibrary.HTTP.POST    /api/register
    ${response_body}    Get Response Body
    log    ${response_body}

Register_successful
    ${body}    Set Json Value    {"email":"email","password":"password"}    /email    "eve.holt@reqres.in"
    ${body}    Set Json Value    ${body}    /password    "pistol"
    Set Request Body    ${body}
    Set Request Header    Content-Type    application/json
    HttpLibrary.HTTP.POST    /api/register
    ${response_body}    Get Response Body
    Log To Console    ${response_body}

Login_successful
    [Tags]    Login
    ${body}    Set Json Value    {"email":"email","password":"password"}    /email    "eve.holt@reqres.in"
    ${body}    Set Json Value    ${body}    /password    "pistol"
    Set Request Body    ${body}
    Set Request Header    Content-Type    application/json
    HttpLibrary.HTTP.POST    /api/login
    ${response_body}    Get Response Body

Login_unsuccessful
    [Tags]    Login
    ${body}    Set Json Value    {"email":"email"}    /email    "eve.holt@reqres.in"
    Set Request Body    ${body}
    Set Request Header    Content-Type    application/json
    Run Keyword And Ignore Error    HttpLibrary.HTTP.POST    /api/login
    ${response_body}    Get Response Body

Delayed_response
    HttpLibrary.HTTP.GET    /api/users?delay=3
    ${response_body}    Get Response Body

*** Keywords ***
setupHttpContext
    HttpLibrary.HTTP.Create Http Context    ${base_url}    https
    Log To Console    setup HTTP context
    Set Request Header    Content-Type    application/json

tearDown
    ${response_status}    Get Response Status
    Log To Console    ${response_status}
