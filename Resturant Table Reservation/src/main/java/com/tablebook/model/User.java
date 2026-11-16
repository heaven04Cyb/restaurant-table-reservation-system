package com.tablebook.model;
//var
public class User {
    private String id;
    private String name;
    private String email;
    private String password;
    private String role; // ADMIN, OWNER, CUSTOMER
//constr
    public User(String id, String name, String email, String password, String role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }
//getters(used to READ the varibls)
    public String getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
//setters(used to UPDATE the varibls values)
    public void setName(String name) { this.name = name; }
    public void setPassword(String password) { this.password = password; }
}
