<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String nickname = request.getParameter("nickname");
    String password = request.getParameter("password");

    String userId = null; // 찾은 아이디 저장 변수

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // ====== DB 연결 ======
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/yourDB?useSSL=false&characterEncoding=UTF-8";
        String dbUser = "yourDBUser";
        String dbPass = "yourDBPassword";
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // ====== 아이디 찾기 쿼리 ======
        String sql = "SELECT userid FROM members WHERE nickname = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nickname);
        pstmt.setString(2, password);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            userId = rs.getString("userid");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>아이디 찾기 결과</title>
    </head>
    <body>
    <% if (userId != null) { %>
    <h2>아이디 찾기 결과</h2>
    <p>회원님의 아이디는 <strong><%= userId %></strong> 입니다.</p>
    <a href="login.jsp">로그인하러 가기</a>
    <% } else { %>
    <h2>아이디를 찾을 수 없습니다.</h2>
    <p>닉네임 또는 비밀번호가 일치하지 않습니다.</p>
    <a href="find_id.jsp">다시 시도하기</a>
    <% } %>
    </body>
</html>
