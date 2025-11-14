<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String nickname = request.getParameter("nickname");
    String userid   = request.getParameter("userid");

    String userPw = null;   // 찾은 비밀번호 저장

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // ===== DB 연결 정보(네 프로젝트에 맞게 수정) =====
        Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 기준
        String url    = "jdbc:mysql://localhost:3306/yourDB?useSSL=false&characterEncoding=UTF-8";
        String dbUser = "yourDBUser";
        String dbPass = "yourDBPassword";

        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // ===== 비밀번호 찾기 쿼리 =====
        // 예: members(userid, password, nickname)
        String sql = "SELECT password FROM members WHERE userid = ? AND nickname = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userid);
        pstmt.setString(2, nickname);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            userPw = rs.getString("password");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null)    rs.close(); }   catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); }catch (Exception e) {}
        try { if (conn != null)  conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기 결과</title>
</head>
<body>

<% if (userPw != null) { %>
<h2>비밀번호 찾기 결과</h2>
<p>회원님의 비밀번호는 <strong><%= userPw %></strong> 입니다.</p>
<a href="login.jsp">로그인하러 가기</a>
<% } else { %>
<h2>비밀번호를 찾을 수 없습니다.</h2>
<p>닉네임 또는 아이디가 일치하지 않습니다.</p>
<a href="find_pw.jsp">다시 시도하기</a>
<% } %>

</body>
</html>
