package com.webSever;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SocialUnitListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String unitName = req.getParameter("unitName");
        if (unitName == null || unitName.trim().isEmpty()) {
            unitName = "제 98여단";
        }

        List<Map<String, Object>> list = new ArrayList<>();

        Map<String, Object> row1 = new HashMap<>();
        row1.put("no", 1);
        row1.put("summary", "좋은 건 밥 뿐...");
        row1.put("writer", "익명");
        row1.put("score", 2);
        row1.put("date", LocalDate.of(2025, 3, 30));
        list.add(row1);

        req.setAttribute("unitName", unitName);
        req.setAttribute("evalList", list);

        req.getRequestDispatcher("/WEB-INF/views/social_unit_list.jsp")
                .forward(req, resp);
    }
}