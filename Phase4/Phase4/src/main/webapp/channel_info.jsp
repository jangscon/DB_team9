<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.text.*, java.sql.*" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@page import="java.io.IOException" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <style>
        body {
            min-height: 75rem;
            padding-top: 8rem;
        }

        ul {
            padding: 0;
        }

        li {
            display: inline-block;
        }

        .bold_name {
            font-weight: bold;
        }

        .info_li {
            padding: 0;
            margin-bottom: 0;
        }

        .form-collapse {
            margin-left: 8rem;
            margin-right: 8rem;
            margin-top: 8rem;
        }


        #myform fieldset {
            display: inline-block; /* 하위 별점 이미지들이 있는 영역만 자리를 차지함.*/
            border: 0; /* 필드셋 테두리 제거 */
        }

        #myform input[type=radio] {
            display: none; /* 라디오박스 감춤 */
        }

        #myform label {
            font-size: 3em; /* 이모지 크기 */
            color: transparent; /* 기존 이모지 컬러 제거 */
            text-shadow: 0 0 0 #f0f0f0; /* 새 이모지 색상 부여 */
        }

        #myform label:hover {
            text-shadow: 0 0 0 #a00; /* 마우스 호버 */
        }

        #myform label:hover ~ label {
            text-shadow: 0 0 0 #a00; /* 마우스 호버 뒤에오는 이모지들 */
        }

        #myform fieldset {
            display: inline-block; /* 하위 별점 이미지들이 있는 영역만 자리를 차지함.*/
            direction: rtl; /* 이모지 순서 반전 */
            border: 0; /* 필드셋 테두리 제거 */
        }

        #myform fieldset legend {
            text-align: left;
        }

        #myform input[type=radio]:checked ~ label {
            text-shadow: 0 0 0 #a00; /* 마우스 클릭 체크 */
        }


        #form-commentInfo {
            width: 100%;
        }

        #comment-count {
            margin-bottom: 10px;
        }

        #comment-input {


            width: 50%;
            height: 200px;
            textAlignVertical: top;

        }

        #submit {
            background-color: rgb(0, 128, 255);
            width: 5.5em;
            height: 3.3em;;
            font-size: 15px;
            font-weight: bold;
            color: aliceblue;
        }

        #voteUp, #voteDown {
            width: 3.5em;
            height: 1.9em;
            background-color: aqua;
        }

        #comments {
            margin-top: 10px;
        }

        .eachComment {
            width: 50%;
            margin: 10px;
            padding: 0.5em;
            border-bottom: 1px solid #c1bcba;
        }

        .eachComment .name {
            font-size: 1.5em;
            font-weight: bold;
            margin-bottom: 0.3em;
            display: flex;
            justify-content: space-between;
        }

        .eachComment .inputValue {
            font-size: 1.2em;
            font-style: italic;
        }

        .eachComment .time {
            font-size: 0.7em;
            color: #c1bcba;
            font-style: oblique;
            margin-top: 0.5em;
            margin-bottom: 0.5em;

        }

        .eachComment .voteDiv {
            display: flex;
            justify-content: flex-end;
        }

        .eachComment .deleteComment {
            background-color: red;
            color: aliceblue;
        }

    </style>
</head>
<body>

<%
    String serverIP;
    String strSID;
    String portNum;
    String user;
    String pass;

    BufferedReader reader = null;
    try {
        String filePath = application.getRealPath("config.txt");
        reader = new BufferedReader(new FileReader(filePath));

        serverIP = reader.readLine();
        strSID = reader.readLine();
        portNum = reader.readLine();
        user = reader.readLine();
        pass = reader.readLine();
        out.println(serverIP + "<br/>");


        reader.close();
    } finally {
        try {
            reader.close();
        } catch (Exception e) {
        }
    }

%>
<!-- 디비 접속 -->
<%
    DataSource dataSource = null;
    try {
        Context context = new InitialContext();
        dataSource = (DataSource) context.lookup("java:comp/env/jdbc/oracle19c");
    } catch (NamingException e) {
        e.printStackTrace();
    }
    Connection conn = null;
    PreparedStatement pstmt;
    ResultSet rs;
    conn = dataSource.getConnection();

    // 테스트용 쿼리

    String query_yt = "SELECT c.channel_id, c.channel_name, c.total_views, c.subscriber_num ,c.youtuber_id, y.name, AVG(r.rating), c.thumbnail, c.description " +
            "FROM channel c, rating r, youtuber y " +
            "WHERE c.channel_id = r.channel_id " +
            "AND c.youtuber_id = y.youtuber_id " +

            "AND c.subscriber_num > 3000000 " +
					/*

					여기서 검색할 조건 입력 AND로

					*/
            "GROUP BY c.channel_id, c.channel_name, c.total_views, c.subscriber_num, c.youtuber_id , y.name, c.thumbnail, c.description ";

    pstmt = conn.prepareStatement(query_yt);
    rs = pstmt.executeQuery();
%>


<header>
    <nav class="navbar navbar-expand-md fixed-top bg-white flex-column border-bottom">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Fixed navbar</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse"
                    aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <ul class="navbar-nav me-auto mb-2 mb-md-0">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Link</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link disabled">Disabled</a>
                    </li>
                </ul>
                <div class="d-flex">
                    <button type="button" class="btn btn-outline-primary me-2">Login</button>
                    <button type="button" class="btn btn-primary">Sign-up</button>
                </div>
            </div>
        </div>
        <div class="container-fluid flex-row mt-3">
            <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#collapseExample"
                    aria-expanded="false" aria-controls="collapseExample">
                Button with data-bs-target
            </button>
            <div>
                <select class="form-select" id="exampleSelect1">
                    <option selected>Open this select menu</option>
                    <option value="1">One</option>
                    <option value="2">Two</option>
                    <option value="3">Three</option>
                </select>
            </div>
        </div>
    </nav>

    <div class="collapse fixed-top form-collapse" id="collapseExample">
        <div class="card card-body">
            <form>
                <div class="mb-3">
                    <label for="exampleInputEmail1" class="form-label">Email address</label>
                    <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp">
                    <div id="emailHelp" class="form-text">We'll never share your email with anyone else.</div>
                </div>
                <div class="mb-3">
                    <label for="exampleInputPassword1" class="form-label">Password</label>
                    <input type="password" class="form-control" id="exampleInputPassword1">
                </div>
                <div class="mb-3">
                    <label for="exampleSelect" class="form-label">Select menu</label>
                    <select class="form-select" id="exampleSelect">
                        <option selected>Open this select menu</option>
                        <option value="1">One</option>
                        <option value="2">Two</option>
                        <option value="3">Three</option>
                    </select>
                </div>
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="exampleCheck1">
                    <label class="form-check-label" for="exampleCheck1">Check me out</label>
                </div>
                <fieldset class="mb-3">
                    <legend>Radios buttons</legend>
                    <div class="form-check">
                        <input type="radio" name="radios" class="form-check-input" id="exampleRadio1">
                        <label class="form-check-label" for="exampleRadio1">Default radio</label>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="radio" name="radios" class="form-check-input" id="exampleRadio2">
                        <label class="form-check-label" for="exampleRadio2">Another radio</label>
                    </div>
                </fieldset>
                <div class="mb-3">
                    <label class="form-label" for="customFile">Upload</label>
                    <input type="file" class="form-control" id="customFile">
                </div>
                <div class="mb-3 form-check form-switch">
                    <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckChecked" checked>
                    <label class="form-check-label" for="flexSwitchCheckChecked">Checked switch checkbox input</label>
                </div>
                <div class="mb-3">
                    <label for="customRange3" class="form-label">Example range</label>
                    <input type="range" class="form-range" min="0" max="5" step="0.5" id="customRange3">
                </div>
                <button type="submit" class="btn btn-primary">Submit</button>
            </form>
        </div>
    </div>
</header>

<%

    /*
    CHANNEL_ID
    CHANNEL_NAME
    DESCRIPTION
    TOTAL_VIEWS
    SUBSCRIBER_NUM
    YOUTUBER_ID
    */


    ResultSetMetaData rsmd = rs.getMetaData();
    int cnt = rsmd.getColumnCount();
    int numcnt = 1;

    String chname;
    String chID;
    long scrnum;
    long totalview;
    int ytid;
    String ytname;
    float rating;
    String thumbnail;
    String description;

    rs.next();

    chID = rs.getString(1);
    chname = rs.getString(2);
    totalview = rs.getLong(3);
    scrnum = rs.getLong(4);
    ytid = rs.getInt(5);
    ytname = rs.getString(6);
    rating = rs.getFloat(7);
    thumbnail = rs.getString(8);
    description = rs.getString(9);


%>

<main>
    <div class="container-fluid">
        <div class="row">
            <div class="col" style="margin-left: 100px; margin-right: 100px">

                <div class="card shadow-sm" style="margin-bottom: 24px">
                    <div class="col">
                        <%
                            out.println("<img src=\"" + thumbnail + "\" style=\" width=50%; height=50% \"> ");
                        %>
                    </div>
                    <div class="card-body">

                        <%
                            out.println("<p class=\"card-text h3\">" + chname + "</p>");
                        %>

                        <form name="myform" id="myform" method="post" action="./save" style="margin: 0 10px 0 10px">
                            <fieldset>
                                <input type="radio" name="rating" value="5" id="rate1"><label for="rate1">⭐</label>
                                <input type="radio" name="rating" value="4" id="rate2"><label for="rate2">⭐</label>
                                <input type="radio" name="rating" value="3" id="rate3"><label for="rate3">⭐</label>
                                <input type="radio" name="rating" value="2" id="rate4"><label for="rate4">⭐</label>
                                <input type="radio" name="rating" value="1" id="rate5"><label for="rate5">⭐</label>
                            </fieldset>
                        </form>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted h5">
                                <span class="bold_name">평점 : </span>
                                <%
                                    out.println("<span> " + rating + " / 10 </span>");
                                %>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted h5">
                                <span class="bold_name">구독자수 : </span>
                                <%
                                    out.println("<span> " + scrnum + " 명</span>");
                                %>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted h5">
                                <span class="bold_name">조회수 : </span>
                                <%
                                    out.println("<span> " + totalview + " 회</span>");
                                %>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted h5">
                                <span class="bold_name">유튜버 : </span>
                                <%
                                    out.println("<span> " + ytname + "</span>");
                                %>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center h5">
                            <div class="text-muted">
                                <ul class="info_li">
                                    <li class="bold_name">출연진 :</li>

                                </ul>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center h5">
                            <div class="text-muted">
                                <ul class="info_li">
                                    <li class="bold_name">장르 :</li>
                                    <li>공포</li>
                                    <li>스포츠</li>
                                    <li>영화</li>
                                </ul>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted h5">
                                <span class="bold_name">체널 설명 : </span>
                                <span>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <p class="card-text h3">댓글</p>
            <div class="row">
                <div class="card mb-3" style="padding: 20px; margin-left: 10px;">
                    <div class="">
                        <h3 class="">닉네임 이메일</h3>
                    </div>
                    <div class="" style="padding-bottom: 20px;">
                        2022-01-02
                    </div>
                    <div class="" style="padding-bottom: 20px;">
                        Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been
                        the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley
                        of type and scrambled it to make a type specimen book. It has survived not only five centuries,
                        but also the leap into electronic typesetting, remaining essentially unchanged. It was
                        popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages,
                        and more recently with desktop publishing software like Aldus PageMaker including versions of
                        Lorem Ipsum.
                    </div>
                    <div style="float: right;">
                        👍 10
                        <button type="button" class="btn btn-warning">추천!</button>
                    </div>
                </div>
            </div>

            <div id="row">
                <div class="card mb-3" style="padding: 20px; margin-left: 10px;">
                    <div style="float: right;">
                        <div class="h3" id="comment-count">댓글작성</div>
                        <input id="comment-input" placeholder="댓글을 입력해 주세요.">
                        <button id="submit">등록</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
        crossorigin="anonymous"></script>
</body>
</html>
