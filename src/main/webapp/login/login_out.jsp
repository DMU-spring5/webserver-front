<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();

    // 캐시 방지(뒤로가기 시 로그인 화면/메인 캐시 문제 예방)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    javax.servlet.http.HttpSession s = request.getSession(false);
    if (s != null) s.invalidate();

    response.sendRedirect(ctx + "/login/login.jsp");
%>
