package com.example.phase4;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        DataSource dataSource = null;

        try {
            Context context = new InitialContext();
            dataSource = (DataSource) context.lookup("java:comp/env/jdbc/oracle19c");
        } catch (NamingException e) {
            e.printStackTrace();
        }

        try (Connection conn = Objects.requireNonNull(dataSource).getConnection()) {
            conn.setAutoCommit(false);
            String sql = "SELECT c.customer_id, c.nickname FROM customer c WHERE c.customer_id = ? AND c.password = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                System.out.println(username);
                System.out.println(password);
                ps.setString(1, request.getParameter("username"));
                ps.setString(2, request.getParameter("password"));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", rs.getString(1));
                        session.setAttribute("nickname", rs.getString(2));
                        response.sendRedirect("index.jsp");
                        System.out.println("Success");
                    } else {
                        response.sendRedirect("login.jsp");
                        System.out.println("fail");
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("sql error = " + e.getMessage());
        }
    }
}
