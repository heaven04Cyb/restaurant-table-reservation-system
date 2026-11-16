package com.tablebook.model;

public class Review {
    private String id;
    private String restaurantId;
    private String userEmail;
    private int rating;
    private String comment;

    public Review(String id, String restaurantId, String userEmail, int rating, String comment) {
        this.id = id;
        this.restaurantId = restaurantId;
        this.userEmail = userEmail;
        this.rating = rating;
        this.comment = comment;
    }

    public String getId() { return id; }
    public String getRestaurantId() { return restaurantId; }
    public String getUserEmail() { return userEmail; }
    public int getRating() { return rating; }
    public String getComment() { return comment; }
}
