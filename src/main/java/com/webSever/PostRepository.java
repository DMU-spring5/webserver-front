package com.webSever;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional; // ⬅️ 이 import가 필수입니다!

// 싱글톤 패턴처럼 동작하는 임시 저장소
public class PostRepository {
    private static final List<Post> POSTS = new ArrayList<>();

    // 서버 시작 시 테스트 데이터 추가 (선택 사항)
    static {
        POSTS.add(new Post("서버 저장소 테스트 글입니다.", "메모리 리포지토리가 잘 작동하는지 확인해 봅시다.", "public"));
    }

    public static void save(Post post) {
        POSTS.add(0, post); // 최신 글이 앞에 오도록 0번째 인덱스에 추가
    }

    public static List<Post> findAll() {
        return POSTS;
    }

    // 🚨 컨트롤러 오류 해결을 위해 추가된 메서드
    public static Optional<Post> findById(long id) {
        return POSTS.stream()
                .filter(post -> post.getPostId() == id) // ID로 게시글 찾기
                .findFirst();
    }
}