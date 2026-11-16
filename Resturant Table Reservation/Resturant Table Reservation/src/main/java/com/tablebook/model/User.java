package com.tablebook.model;

public class User {
    private String id;
    private String name;
    private String email;
    private String password;
    private String role; // ADMIN, OWNER, CUSTOMER

    public User(String id, String name, String email, String password, String role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getRole() { return role; }

    public void setName(String name) { this.name = name; }
    public void setPassword(String password) { this.password = password; }
}
