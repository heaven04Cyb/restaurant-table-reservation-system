package com.tablebook.model;

public class Restaurant {
    private String id;
    private String name;
    private String location;
    private String operatingHours;
    private String ownerId;

    public Restaurant(String id, String name, String location, String operatingHours, String ownerId) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.operatingHours = operatingHours;
        this.ownerId = ownerId;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public String getLocation() { return location; }
    public String getOperatingHours() { return operatingHours; }
    public String getOwnerId() { return ownerId; }

    public void setLocation(String location) { this.location = location; }
    public void setOperatingHours(String operatingHours) { this.operatingHours = operatingHours; }
}
