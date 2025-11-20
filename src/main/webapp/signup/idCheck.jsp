<%@ page contentType="application/json; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String userId = request.getParameter("userId");
    boolean exists = false;

    if (userId != null && !userId.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 1. JDBC 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. DB 접속 (여기 너 DB정보에 맞게 수정!)
            String url = "jdbc:mysql://localhost:3306/your_db_name?serverTimezone=Asia/Seoul&characterEncoding=UTF-8";
            String dbUser = "your_db_user";
            String dbPass = "your_db_password";
            conn = DriverManager.getConnection(url, dbUser, dbPass);

            // 3. 아이디 존재 여부 조회 (테이블/컬럼 이름 수정!)
            String sql = "SELECT COUNT(*) FROM user WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                exists = (count > 0);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }

    boolean available = !exists;   // true면 사용 가능

    // JSON 문자열 안전하게 만들기
    StringBuilder sb = new StringBuilder();
    sb.append("{\"available\":");
    sb.append(available ? "true" : "false");
    sb.append("}");

    out.print(sb.toString());
%>
