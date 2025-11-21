package com.webSever;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    /**
     * 루트 경로 "/" 요청을 처리하여 지도 페이지를 로드합니다.
     * 최종 URL: http://localhost:8080/
     */
    @GetMapping("/")
    public String home() {
        // 지도 페이지의 JSP 파일명을 'map'이라고 가정합니다.
        return "map"; // WEB-INF/views/map.jsp를 찾아 로드
    }
}