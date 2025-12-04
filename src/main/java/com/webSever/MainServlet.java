package com.webSever;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/main")   // /main 은 여기 하나만
public class MainServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // main.jsp 는 /WEB-INF/views 아래에 있으니까 forward 로만 접근
        req.getRequestDispatcher("/WEB-INF/views/main.jsp")
                .forward(req, resp);
    }
}

