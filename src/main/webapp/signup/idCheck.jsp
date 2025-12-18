<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String userId   = request.getParameter("userId");
    String nickname = request.getParameter("nickname");
    String password = request.getParameter("password");

    boolean success = false;

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://localhost:3306/your_db_name?serverTimezone=Asia/Seoul&characterEncoding=UTF-8";
        String dbUser = "your_db_user";
        String dbPass = "your_db_password";

        conn = DriverManager.getConnection(url, dbUser, dbPass);

        String sql = "INSERT INTO user (user_id, nickname, password) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, userId);
        pstmt.setString(2, nickname);
        pstmt.setString(3, password);

        int rows = pstmt.executeUpdate();
        success = (rows > 0);

    } catch (Exception e) {
        e.printStackTrace();
        success = false;
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception ignored) {}
        try { if (conn  != null) conn.close();  } catch (Exception ignored) {}
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입 처리</title>
</head>
<body>
<%
    if (success) {
%>
<script>
    alert("가입이 완료되었습니다.");
    location.href = "login.jsp";
</script>
<%
} else {
%>
<script>
    alert("회원가입 오류가 발생했습니다. 다시 시도해 주세요.");
    history.back();
</script>
<%
    }
%>
</body>
</html>
