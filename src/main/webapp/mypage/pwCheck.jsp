<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%
    final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    final String DB_URL = "jdbc:mysql://localhost:3306/your_database_name?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
    final String DB_USER = "your_db_user";
    final String DB_PASS = "your_db_password";

    final String USERS_TABLE = "users";
    final String ID_COLUMN = "user_id";
    final String PW_COLUMN = "password";
    final String ID_SESSION_ATTR = "userId";

    request.setCharacterEncoding("UTF-8");

    // 세션에서 사용자 id 가져오기
    String userId = (String) session.getAttribute(ID_SESSION_ATTR);
    if (userId == null || userId.trim().isEmpty()) {
        // 로그인 상태가 아님
%>
<script>
    alert('로그인 상태가 아닙니다. 로그인 페이지로 이동합니다.');
    location.href = '/login/login.jsp';
</script>
<%
        return;
    }

    // 폼으로부터 받은 값
    String original = request.getParameter("original");
    String newPw = request.getParameter("new");
    String confirmPw = request.getParameter("password");

    if (original == null) original = "";
    if (newPw == null) newPw = "";
    if (confirmPw == null) confirmPw = "";

    original = original.trim();
    newPw = newPw.trim();
    confirmPw = confirmPw.trim();

    // 기본 유효성 검사 (서버 측)
    if (original.isEmpty() || newPw.isEmpty() || confirmPw.isEmpty()) {
%>
<script>
    alert('모든 항목을 입력해 주세요.');
    history.back();
</script>
<%
        return;
    }

    // 새 비밀번호와 확인이 일치하는지
    if (!newPw.equals(confirmPw)) {
%>
<script>
    alert('새 비밀번호와 비밀번호 확인이 일치하지 않습니다.');
    history.back();
</script>
<%
        return;
    }

    // 새 비밀번호가 기존 비밀번호와 같은지 (서버 측 확인은 DB의 저장 형태를 고려해 처리)
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        Class.forName(DB_DRIVER);
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

        // 1) DB에서 현재 저장된 비밀번호 불러오기
        String selectSql = "SELECT " + PW_COLUMN + " FROM " + USERS_TABLE + " WHERE " + ID_COLUMN + " = ?";
        pstmt = conn.prepareStatement(selectSql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        if (!rs.next()) {
%>
<script>
    alert('사용자 정보를 찾을 수 없습니다.');
    history.back();
</script>
<%
        return;
    }

    String storedPw = rs.getString(PW_COLUMN);
    if (storedPw == null) storedPw = "";

    // 도우미: SHA-256 해시 생성 (hex)
    String hashOriginal = null;
    String hashNew = null;
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        // original 해시
        byte[] origBytes = md.digest(original.getBytes("UTF-8"));
        StringBuilder sb1 = new StringBuilder();
        for (byte b : origBytes) sb1.append(String.format("%02x", b));
        hashOriginal = sb1.toString();
        // new 해시
        byte[] newBytes = md.digest(newPw.getBytes("UTF-8"));
        StringBuilder sb2 = new StringBuilder();
        for (byte b : newBytes) sb2.append(String.format("%02x", b));
        hashNew = sb2.toString();
    } catch (NoSuchAlgorithmException e) {
        // SHA-256 지원 안하는 JVM 희박. 이 경우 hashOriginal/hashNew는 null로 남음.
        hashOriginal = null;
        hashNew = null;
    }

    // 저장된 비밀번호가 SHA-256 해시인지(16진수 64자리) 간단히 검사
    boolean storedIsSha256 = storedPw.matches("^[a-fA-F0-9]{64}$");

    boolean originalMatches = false;
    if (storedIsSha256 && hashOriginal != null) {
        originalMatches = storedPw.equalsIgnoreCase(hashOriginal);
    } else {
        // 평문 저장된 경우(혹은 검사 불가 시) 평문 비교
        originalMatches = storedPw.equals(original);
    }

    if (!originalMatches) {
%>
<script>
    alert('기존 비밀번호가 일치하지 않습니다.');
    history.back();
</script>
<%
        return;
    }

    // 새 비밀번호가 기존 비밀번호와 같은지 검사 (서버측)
    boolean newEqualsOld = false;
    if (storedIsSha256 && hashNew != null) {
        newEqualsOld = storedPw.equalsIgnoreCase(hashNew);
    } else {
        newEqualsOld = storedPw.equals(newPw);
    }

    if (newEqualsOld) {
%>
<script>
    alert('새 비밀번호는 기존 비밀번호와 동일할 수 없습니다.');
    history.back();
</script>
<%
        return;
    }

    // 이제 비밀번호 업데이트: 저장된 방식에 맞춰 업데이트 (해시였으면 해시로, 평문이었으면 평문으로)
    String updateSql = "UPDATE " + USERS_TABLE + " SET " + PW_COLUMN + " = ? WHERE " + ID_COLUMN + " = ?";
    pstmt.close();
    pstmt = conn.prepareStatement(updateSql);
    if (storedIsSha256 && hashNew != null) {
        pstmt.setString(1, hashNew);
    } else {
        pstmt.setString(1, newPw);
    }
    pstmt.setString(2, userId);

    int updated = pstmt.executeUpdate();
    if (updated > 0) {
%>
<script>
    alert('비밀번호가 성공적으로 변경되었습니다.');
    location.href = 'mypage.jsp';
</script>
<%
} else {
%>
<script>
    alert('비밀번호 변경에 실패했습니다. 다시 시도해 주세요.');
    history.back();
</script>
<%
    }

} catch (ClassNotFoundException cnfe) {
%>
<script>
    alert('DB 드라이버를 찾을 수 없습니다: ' + '<%= cnfe.getMessage() %>');
    history.back();
</script>
<%
} catch (SQLException sqle) {
%>
<script>
    alert('DB 오류가 발생했습니다: ' + '<%= sqle.getMessage() %>');
    history.back();
</script>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
