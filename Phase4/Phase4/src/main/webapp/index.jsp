<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.util.Objects" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>TUBE FINDER</title>
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
    </style>
</head>
<body>
<%!
    String select;
    String[] genreNames = {"Animation", "Beauty", "Makeup", "Comedy", "Critics", "Review", "DIY", "Education", "Fashion", "Muckbang", "Cooking", "Gaming", "Health", "Fitness", "Music", "News", "Podcaster", "Sports", "Technology", "Vlogger", "Science", "Dance"};
    String channelName = "SELECT c.channel_id, c.channel_name, c.total_views, c.subscriber_num, c.thumbnail FROM channel c, has h, genre g WHERE c.channel_id = h.channel_id AND h.genre_num = g.genre_num AND g.genre_name = ? ORDER BY channel_name";
    String subscriberNum = "SELECT c.channel_id, c.channel_name, c.total_views, c.subscriber_num, c.thumbnail FROM channel c, has h, genre g WHERE c.channel_id = h.channel_id AND h.genre_num = g.genre_num AND g.genre_name = ? ORDER BY subscriber_num DESC";
    String totalViews = "SELECT c.channel_id, c.channel_name, c.total_views, c.subscriber_num, c.thumbnail FROM channel c, has h, genre g WHERE c.channel_id = h.channel_id AND h.genre_num = g.genre_num AND g.genre_name = ? ORDER BY total_views DESC";
    String sql = null;
%>
<header>
    <nav class="navbar navbar-expand-md fixed-top bg-white flex-column border-bottom">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">TUBE FINDER</a>
            <div class="d-flex">
                <button type="button" class="btn btn-outline-primary me-2" onclick="location.href='login.jsp'">Login
                </button>
                <button type="button" class="btn btn-primary">Sign-up</button>
            </div>
        </div>
        <div class="container-fluid flex-row mt-3">
            <button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="collapse"
                    data-bs-target="#collapseExample"
                    aria-expanded="false" aria-controls="collapseExample">
                Search channel
            </button>
            <div class="d-flex align-items-center">
                <label style="white-space: nowrap">Order by:</label>
                <form method="get">
                    <select class="form-select ms-2" id="exampleSelect1" name="select" onchange="this.form.submit()">
                        <%
                            select = request.getParameter("select");
                            select = select != null ? select : "1";
                            switch (select) {
                                case "1":
                                    out.println("<option value=\"1\" selected>Channel name</option>");
                                    out.println("<option value=\"2\">Number of subscribers</option>");
                                    out.println("<option value=\"3\">Total views</option>");
                                    break;
                                case "2":
                                    out.println("<option value=\"1\">Channel name</option>");
                                    out.println("<option value=\"2\" selected>Number of subscribers</option>");
                                    out.println("<option value=\"3\">Total views</option>");
                                    break;
                                case "3":
                                    out.println("<option value=\"1\">Channel name</option>");
                                    out.println("<option value=\"2\">Number of subscribers</option>");
                                    out.println("<option value=\"3\" selected>Total views</option>");
                                    break;
                            }
                        %>
                    </select>
                </form>
            </div>
        </div>
    </nav>
    <div class="collapse fixed-top form-collapse" id="collapseExample">
        <div class="card card-body">
            <form action="searchp.jsp" method="get">
                <div class="mb-3">
                    <label for="inputKeywords" class="form-label">Keywords</label>
                    <input type="text" class="form-control" id="inputKeywords" name="keywords" aria-describedby="keywordsHelp">
                    <div id="keywordsHelp" class="form-text">Separated by spaces. Up to 2. Search keywords from channel
                        name and description.
                    </div>
                </div>
                <div class="mb-3">
                    <label for="subscriberNumOver" class="form-label">Number of subscribers over: <span
                            class="span1">0</span></label>
                    <input type="range" class="form-range" min="0" max="25700000" value="0" step="100000"
                           id="subscriberNumOver" name="subscriberNumOver" onchange="range_change('span1', this)">
                </div>
                <div class="mb-3">
                    <label for="subscriberNumUnder" class="form-label">Number of subscribers under: <span class="span2">25700000</span></label>
                    <input type="range" class="form-range" min="0" max="25700000" value="25700000" step="100000"
                           id="subscriberNumUnder" name="subscriberNumUnder" onchange="range_change('span2', this)">
                </div>
                <div class="mb-3">
                    <label for="totalViewsOver" class="form-label">Total views over: <span
                            class="span3">0</span></label>
                    <input type="range" class="form-range" min="0" max="12000000000" value="0" step="10000000"
                           id="totalViewsOver" name="totalViewsOver" onchange="range_change('span3', this)">
                </div>
                <div class="mb-3">
                    <label for="totalViewsUnder" class="form-label">Total views under: <span
                            class="span4">12000000000</span></label>
                    <input type="range" class="form-range" min="0" max="12000000000" value="12000000000" step="10000000"
                           id="totalViewsUnder" name="totalViewsUnder" onchange="range_change('span4', this)">
                </div>
                <div class="mb-3">
                    <label for="inputGenreNames" class="form-label">Genre names</label>
                    <input type="text" class="form-control" id="inputGenreNames" name="genreNames" aria-describedby="genreNamesHelp">
                    <div id="genreNamesHelp" class="form-text">Separated by spaces. Up to 2.</div>
                </div>
                <button type="submit" class="btn btn-primary">Submit</button>
            </form>
        </div>
    </div>
</header>
<main>
    <div class="container-fluid">
        <%
            switch (select) {
                case "1":
                    sql = channelName;
                    break;
                case "2":
                    sql = subscriberNum;
                    break;
                case "3":
                    sql = totalViews;
                    break;
            }
            DataSource dataSource = null;
            try {
                Context context = new InitialContext();
                dataSource = (DataSource) context.lookup("java:comp/env/jdbc/oracle19c");
            } catch (NamingException e) {
                e.printStackTrace();
            }
            try (Connection conn = Objects.requireNonNull(dataSource).getConnection()) {
                conn.setAutoCommit(false);

                for (int i = 0; i < genreNames.length; i++) {
                    out.println("<div class=\"row\">");
                    out.println("<div class=\"col\">");
                    out.println(String.format("<h2 class=\"mx-3\">%s</h2>", genreNames[i]));
                    out.println("</div>");
                    out.println("</div>");
                    out.println("<div class=\"row\">");
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, genreNames[i]);
                        try (ResultSet rs = ps.executeQuery()) {
                            for (int j = 0; j < 5; j++) {
                                if (rs.next()) {
                                    out.println("<div class=\"col\">");
                                    out.println("<div class=\"card shadow-sm\" style=\"margin-bottom: 24px\">");
                                    out.println(String.format("<img class=\"card-img-top\" src=\"%s\">", rs.getString(5)));
                                    out.println("<div class=\"card-body\">");
                                    out.println(String.format("<p class=\"card-text\">%s</p>", rs.getString(2)));
                                    out.println("<div class=\"d-flex justify-content-between align-items-center\">");
                                    out.println(String.format("<small class=\"text-muted\">%d<br>subscribers</small>", rs.getLong(4)));
                                    out.println(String.format("<small class=\"text-muted\" style=\"text-align: right\">%d<br>time watched</small>", rs.getLong(3)));
                                    out.println("</div>");
                                    out.println(String.format("<a href=\"channel_info.jsp?id=%s\" class=\"stretched-link\"></a>", rs.getString(1)));
                                    out.println("</div>");
                                    out.println("</div>");
                                    out.println("</div>");
                                }
                            }
                        }
                    }
                    out.println("</div>");
                }
            } catch (SQLException e) {
                System.err.println("sql error = " + e.getMessage());
            }
        %>
    </div>
</main>
<script>
    function range_change(target, obj) {
        let x = document.getElementsByClassName(target)[0];
        x.innerText = obj.value;
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
        crossorigin="anonymous"></script>
</body>
</html>