package com.webSever;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/social") // 클래스 레벨 매핑: /social
public class SocialController {

    /**
     * 🚨 수정: PostRepository에서 데이터를 가져와 Model에 담아 전달합니다.
     * 최종 URL: /social/board
     */
    @GetMapping("/board")
    public String socialBoard(Model model) {
        model.addAttribute("posts", PostRepository.findAll());
        return "social_board"; // WEB-INF/views/social_board.jsp
    }

    /**
     * 게시글 작성 페이지를 로드합니다. (GET 요청)
     * 최종 URL: /social/write
     */
    @GetMapping("/write")
    public String writePost() {
        return "social_write"; // WEB-INF/views/social_write.jsp
    }

    /**
     * 🚨 수정: Post 객체를 생성하고 PostRepository에 저장합니다.
     * 최종 URL: /social/write
     */
    @PostMapping("/write")
    public String submitPost(
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam("public_option") String publicOption
    ) {
        Post newPost = new Post(title, content, publicOption);
        PostRepository.save(newPost);

        // 게시글 목록으로 리다이렉트
        return "redirect:/social/board";
    }

    /**
     * 🚨 수정: ID를 받아 PostRepository에서 게시글을 조회하고 조회수를 증가시킵니다.
     * 최종 URL: /social/detail?id=...
     */
    @GetMapping("/detail")
    public String viewPostDetail(
            @RequestParam("id") long postId, // 게시글 ID를 받음
            Model model
    ) {
        PostRepository.findById(postId).ifPresent(post -> {
            post.incrementViews(); // 조회수 증가
            model.addAttribute("post", post);
        });

        return "social_detail";
    }
}