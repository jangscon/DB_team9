<!doctype html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*" %>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.FileReader"%>
<%@page import="java.io.IOException"%>



<html lang="en">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <style>
        body {
            min-height: 75rem;
            padding-top: 8rem;
        }
        .form-collapse {
            margin-left: 8rem;
            margin-right: 8rem;
            margin-top: 8rem;
        }
        .card-horizontal {
            display: flex;
            flex: 1 1 auto;
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
	try{
		String filePath = application.getRealPath("config.txt");
	    reader = new BufferedReader(new FileReader(filePath));
	
	    serverIP = reader.readLine();
		strSID = reader.readLine();
		portNum = reader.readLine();
		user = reader.readLine();
		pass = reader.readLine();
	   
		reader.close();
	}finally{try{
	 	reader.close();
	 }catch(Exception e){}}

%>
<!-- 디비 접속 --> 
<%
		String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
		
		
		Connection conn = null;
		PreparedStatement pstmt;
		ResultSet rs;
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url, user, pass);
		
		// 테스트용 쿼리 
		
		String query_yt = "SELECT c.channel_id, c.channel_name, c.total_views, c.subscriber_num ,c.youtuber_id, y.name, AVG(r.rating), c.thumbnail " +
					"FROM channel c, rating r, youtuber y " +
					"WHERE c.channel_id = r.channel_id " +
					"AND c.youtuber_id = y.youtuber_id " + 
							
					"AND c.subscriber_num > 3000000 " + 
					/*  
					
					여기서 검색할 조건 입력 AND로 
					
					*/
					"GROUP BY c.channel_id, c.channel_name, c.total_views, c.subscriber_num, c.youtuber_id , y.name, c.thumbnail ";

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




<main>
    <div class="container-fluid">
        <div class="row">
            <div class="col h3">
                <!-- <span >"query"</span> -->
                <span class="mx-3">검색 결과</span>
            </div>
        </div>
        <%
        
        /* 
        CHANNEL_ID               
        CHANNEL_NAME                             
        DESCRIPTION                                                                                                                                                                                                                                                                                                                                                                                                      
        TOTAL_VIEWS 
        SUBSCRIBER_NUM 
        YOUTUBER_ID 
        */

        ResultSet rs_yt;
        
        ResultSetMetaData rsmd = rs.getMetaData();
		int cnt = rsmd.getColumnCount();
        int numcnt = 1;
        
        String chname ;
        String chID;
        long scrnum;
        long totalview;
        int ytid;
        String ytname;
        float rating;
        String thumbnail;
        
		while(rs.next()) {
			
			chID = rs.getString(1);
			chname = rs.getString(2);
			totalview = rs.getLong(3);
			scrnum = rs.getLong(4);
			ytid = rs.getInt(5);
			ytname = rs.getString(6); 
			rating = rs.getFloat(7);
			thumbnail = rs.getString(8); 
			
			
			
			if ((numcnt-1)%4 == 0) {
				out.println("<div class=\"row\">");	
			}
			out.println(
						"<div class=\"col\"> "+
							"<div class=\"card\"> "+
								"<div class=\"card-horizontal\"> "+
									"<div class=\"img-square-wrapper\"> "+
										"<img src=\""+ thumbnail +"\"> "+
											"<title>Placeholder</title> "+
											"<rect width=\"100%\" height=\"100%\" fill=\"#55595c\"/> "+
									"</div> "+
								"<div class=\"card-body\"> "+
									"<p class=\"card-text h4\">" + chname + "</p> "+
									"<div> "+
										"<div class=\"d-flex justify-content-between align-items-center\"> "+
											"<div class=\"text-muted h5\"> "+
												"<span class=\"bold_name\">평점 : </span> "+
												"<span>" + String.format("%.2f", rating) +"/ 10</span> "+
											"</div> "+
										"</div> "+
									"<div class=\"d-flex justify-content-between align-items-center\"> "+
										"<div class=\"text-muted h5\"> "+
											"<span class=\"bold_name\">구독자수 : </span> "+
											"<span>" + scrnum +"</span> "+
										"</div> "+
									"</div> "+
									"<div class=\"d-flex justify-content-between align-items-center\"> "+
										"<div class=\"text-muted h5\"> "+
											"<span class=\"bold_name\">조회수 : </span> "+
											"<span>" + totalview +"</span> "+
										"</div> "+
									"</div> "+
									"<div class=\"d-flex justify-content-between align-items-center\"> "+
										"<div class=\"text-muted h5\"> "+
											"<span class=\"bold_name\">유튜버 : </span> "+
											"<span>"+ ytname +"</span> "+
										"</div> "+
									"</div> "+
								"</div> "+
							"</div> "+
						"</div> "+
						"<div class=\"card-footer\"> "+
							"<small class=\"text-muted\"><A href = \"http://www.youtube.com/channel/"+ chID +"\")>" + chname + " 체널 바로가기</A></small> "+
						"</div> "+
					"</div> "+
				"</div> ");
			
			if ((numcnt-1)%4 == 0) {
				out.println("</div>");	
			}
			
			numcnt += 1;
		}
		
                    		
		%>
                   
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
        crossorigin="anonymous"></script>
</body>
</html>