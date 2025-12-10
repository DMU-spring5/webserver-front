<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userid          = request.getParameter("userid");
    String newPassword     = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    int minLen = 8;   // 최소 자리수

    // 1) 길이 + 일치만 체크
    if (newPassword == null || confirmPassword == null
            || newPassword.trim().length() < minLen
            || confirmPassword.trim().length() < minLen
            || !newPassword.equals(confirmPassword)) {
%>
<script>
    alert('비밀번호는 최소 <%=minLen%>자리 이상이며,\n두 칸이 서로 일치해야 합니다.');
    history.back();
</script>
<%
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // ===== 2) DB 연결 (★여기 네 DB 정보로 바꾸기!) =====
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url    = "jdbc:mysql://localhost:3306/**네_디비이름**?useSSL=false&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        String dbUser = "**디비아이디**";
        String dbPass = "**디비비밀번호**";

        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // ===== 3) 비밀번호만 UPDATE (★테이블/컬럼명 실제대로 맞추기!) =====
        String sql = "UPDATE **members** SET **password** = ? WHERE **userid** = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, newPassword);
        pstmt.setString(2, userid);

        int result = pstmt.executeUpdate();

        // 여기까지 예외 없이 오면 그냥 성공 처리
%>
<script>
    alert('비밀번호 변경이 완료되었습니다.\n새 비밀번호로 로그인해 주세요.');
    location.href = 'login.jsp';
</script>
<%
} catch (Exception e) {
    e.printStackTrace();   // 톰캣 콘솔에 실제 에러 내용 찍힘
%>
<script>
    alert('비밀번호 변경 중 오류가 발생했습니다. 다시 시도해 주세요.');
    history.back();
</script>
<%
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn  != null) conn.close(); } catch (Exception e) {}
    }
%>
