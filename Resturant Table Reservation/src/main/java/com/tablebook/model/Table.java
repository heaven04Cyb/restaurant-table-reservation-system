package com.tablebook.model;
//Encapsulation
public class Table {
    private String id;
    private String restaurantId;
    private String tableNumber;
    private int capacity;
    private String status;
//Constructor
    public Table(String id, String restaurantId, String tableNumber, int capacity, String status) {
        this.id = id;
        this.restaurantId = restaurantId;
        this.tableNumber = tableNumber;
        this.capacity = capacity;
        this.status = status;
    }

    public String getId() { return id; }
    public String getRestaurantId() { return restaurantId; }
    public String getTableNumber() { return tableNumber; }
    public int getCapacity() { return capacity; }
    public String getStatus() { return status; }
}
