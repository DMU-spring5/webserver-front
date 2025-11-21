package com.webSever;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class Post {
    private static long nextId = 100001;

    private long postId;
    private String title;
    private String content;
    private String writer;
    private String date;
    private String publicOption;
    private int views = 0;      // ⬅️ 조회수 필드 필요
    private int recommends = 0; // ⬅️ 추천수 필드 필요

    public Post(String title, String content, String publicOption) {
        this.postId = nextId++;
        this.title = title;
        this.content = content;
        this.publicOption = publicOption;
        this.writer = "니인내조";
        this.date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy.MM.dd"));
    }

    // Getter 메소드들
    public long getPostId() { return postId; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public String getWriter() { return writer; }
    public String getDate() { return date; }
    public int getViews() { return views; }
    public int getRecommends() { return recommends; }
    public String getPublicOption() { return publicOption; }

    // 🚨 컨트롤러 오류 해결을 위해 추가된 메서드
    public void incrementViews() {
        this.views++;
    }
}