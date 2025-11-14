<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>로그인</title>
        <link rel="stylesheet" type="text/css" href="login.css">
    </head>

    <%
        String idErrorParam = request.getParameter("idError");
        String pwErrorParam = request.getParameter("pwError");
    %>

    <body>
        <img src="<%=request.getContextPath()%>/img/WebServerLogo.png">
        <form id="loginForm" action="login_ok.jsp" method="post">
            <!--아이디-->
            <div class="id-box">
                <input type="text" name="userid" id="userid" placeholder="아이디">
                <p id="idError">
                    <%= (idErrorParam != null ? idErrorParam : "")%>
                </p>
            </div>
            <!--비밀번호-->
            <div class="pw-box">
                <input type="password" name="userpw" id="userpw" placeholder="비밀번호">
                <img class="eyeoff" id="togglePw" src="../img/eye.png">
            </div>
            <p id="pwError" class="error-msg"></p>
            <!--자동 로그인-->
            <label>
                <input type="checkbox" name="autoLogin" value="N">
                자동 로그인
            </label><br>
            <button type="submit">로그인</button>
            <!--아이디 찾기, 비밀번호 찾기, 회원가입-->
            <div class="link-box">
                <a href="find_id.jsp">아이디 찾기</a> |
                <a href="find_pw.jsp">비밀번호 찾기</a> |
                <a href="signup.jsp">회원가입</a>
            </div><br>
        </form>
    </body>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const pwInput  = document.getElementById("userpw");
            const togglePw = document.getElementById("togglePw");
            //비밀번호 보기/숨기기 기능
            if (togglePw && pwInput) {
                togglePw.addEventListener("click", () => {
                    if (pwInput.type === "password") {
                        pwInput.type = "text";
                        togglePw.src = "../img/eyeoff.png";
                    }
                    else {
                        pwInput.type = "password";
                        togglePw.src = "../img/eye.png";
                    }
                });
            }
            //폼 제출 시 아이디/비밀번호 미입력 체크
            const loginForm = document.getElementById("loginForm");
            const userid = document.getElementById("userid");
            const idError = document.getElementById("idError");
            const pwError = document.getElementById("pwError");

            loginForm.addEventListener("submit", (e) => {
                let valid = true;
                //아이디 미입력
                if (userid.value.trim() === "") {
                    idError.textContent = "아이디를 확인해주세요.";
                    valid = false;
                }
                else {
                    idError.textContent = "";
                }
                // 비밀번호 미입력
                if (pwInput.value.trim() === "") {
                    pwError.textContent = "비밀번호를 확인해주세요.";
                    valid = false;
                }
                else {
                    pwError.textContent = "";
                }
                if (!valid) e.preventDefault(); // 제출 막기
            });
        });
    </script>
</html>