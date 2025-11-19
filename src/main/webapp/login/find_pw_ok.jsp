<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String nickname = request.getParameter("nickname");
    String userid   = request.getParameter("userid");

    boolean match = false;  // 일치하는 회원이 있는지 여부

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // DB 연결 -> 수정 해야함
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/yourDB?useSSL=false&characterEncoding=UTF-8";
        String dbUser = "yourDBUser";
        String dbPass = "yourDBPassword";
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // 닉네임 + userid 검증
        String sql = "SELECT * FROM members WHERE nickname=? AND userid=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nickname);
        pstmt.setString(2, userid);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            match = true; // 정보 일치
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    // ===== 정보 일치 여부에 따른 처리 =====
    if (!match) {
%>
<script>
    alert("입력하신 정보가 일치하지 않습니다. 다시 시도해 주세요.");
    location.href = "new_pw.jsp";
</script>
<%
        return;
    }

    // 일치하면 → reset_pw.jsp로 값 전달
    request.setAttribute("userid", userid);
    request.setAttribute("nickname", nickname);

    RequestDispatcher rd = request.getRequestDispatcher("reset_pw.jsp");
    rd.forward(request, response);
%>
