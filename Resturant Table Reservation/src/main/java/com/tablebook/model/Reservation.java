package com.tablebook.model;

public class Reservation {
    private String id;
    private String userEmail;
    private String restaurantId;
    private String tableId;
    private String date;
    private String time;
    private int partySize;
    private String status;

    public Reservation(String id, String userEmail, String restaurantId, String tableId, String date, String time, int partySize, String status) {
        this.id = id;
        this.userEmail = userEmail;
        this.restaurantId = restaurantId;
        this.tableId = tableId;
        this.date = date;
        this.time = time;
        this.partySize = partySize;
        this.status = status;
    }

    public String getId() { return id; }
    public String getUserEmail() { return userEmail; }
    public String getRestaurantId() { return restaurantId; }
    public String getTableId() { return tableId; }
    public String getDate() { return date; }
    public String getTime() { return time; }
    public int getPartySize() { return partySize; }
    public String getStatus() { return status; }
}
