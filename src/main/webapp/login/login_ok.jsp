<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
    request.setCharacterEncoding("UTF-8");

    //로그인에서 넘어온 값
    String id = request.getParameter("userid");
    String pw = request.getParameter("userpw");
    String autoLogin = request.getParameter("autoLogin");  // 체크 시 "Y"

    //JDBC 준비
    String jdbcUrl = "jdbc:mysql://localhost:3306/yourDB?characterEncoding=UTF-8&serverTimezone=UTC"; //DB 이름
    String dbUser  = "yourUser";  //DB 계정
    String dbPass  = "yourPass";  //DB 비밀번호

    boolean loginSuccess = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT id FROM users WHERE id = ? AND password = ?")) {  //테이블/컬럼명 맞게 수정
            pstmt.setString(1, id);
            pstmt.setString(2, pw);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    loginSuccess = true;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<%
    if (loginSuccess) {  //로그인 성공 -> 세션 저장
    session.setAttribute("userid", id);

    // 자동 로그인 체크 -> 쿠키 설정
    if ("Y".equals(autoLogin)) {
        javax.servlet.http.Cookie cookie =
                new javax.servlet.http.Cookie("userid", URLEncoder.encode(id, "UTF-8"));
        cookie.setMaxAge(60 * 60 * 24 * 7); // 7일
        cookie.setPath("/");
        response.addCookie(cookie);
    }
%>
<script>
    alert('로그인 성공');
    location.href = 'index.jsp';
</script>
<% } else { %>
<script>
    alert('아이디 또는 비밀번호가 틀렸습니다.');
    history.back();
</script>
<% } %>
