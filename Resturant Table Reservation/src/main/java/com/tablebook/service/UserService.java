package com.tablebook.service;

import com.tablebook.model.User;
import java.util.ArrayList;

// Service class to handle user login, register, and profile updates
public class UserService {
    // we need the FileHandler to read and write to users.txt
    private FileHandler fh;
    
    // this is the symbol we use to separate data in the text file
    private String delimiter = "\\|";

    // Constructor creates a new FileHandler object
    public UserService() {
        this.fh = new FileHandler();
    }

    // Method to create a new user and save to text file
    public User register(String name, String email, String password, String role) {
        // if role is not OWNER or ADMIN, make them a CUSTOMER by default
        if (role.equals("OWNER") == false && role.equals("ADMIN") == false) {
            role = "CUSTOMER"; 
        }
        
        // create a unique ID using the current time
        String newId = "USR" + System.currentTimeMillis();
        
        // combine all details into one string line separated by pipe symbols
        String userLine = newId + "|" + name + "|" + email + "|" + password + "|" + role;
        
        // append this new line to the users file
        fh.appendLine(fh.getUsersFile(), userLine);
        
        // return the newly created user object
        return new User(newId, name, email, password, role);
    }

    // Method to check login credentials
    public User login(String email, String password) {
        // read all lines from users.txt into an ArrayList
        ArrayList<String> allLines = fh.readLines(fh.getUsersFile());
        
        // basic for loop to check every line
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            
            // split the line to get the individual parts
            String[] parts = currentLine.split(delimiter);
            
            // make sure the line has all 5 parts (id, name, email, password, role)
            if (parts.length >= 5) {
                // check if the email and password match what the user typed
                if (parts[2].trim().equals(email.trim()) && parts[3].trim().equals(password.trim())) {
                    // if it matches, return a new User object
                    return new User(parts[0], parts[1], parts[2], parts[3], parts[4]);
                }
            }
        }
        
        // if no match is found, return null to show login failed
        return null;
    }

    // Method to find a user by their ID
    public User findById(String targetId) {
        ArrayList<String> allLines = fh.readLines(fh.getUsersFile());
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            if (parts.length >= 5) {
                // check if the ID matches the target
                if (parts[0].trim().equals(targetId.trim())) {
                    return new User(parts[0], parts[1], parts[2], parts[3], parts[4]);
                }
            }
        }
        return null;
    }

    // Method to change a user's name or password
    public void updateProfile(String idToUpdate, String newName, String newPassword) {
        ArrayList<String> allLines = fh.readLines(fh.getUsersFile());
        
        // we create a new list to hold the updated data
        ArrayList<String> newUpdatedList = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // if we find the user we want to update
            if (parts.length >= 5 && parts[0].trim().equals(idToUpdate.trim())) {
                
                // update name if they provided a new one
                if (newName != null && newName.isEmpty() == false) {
                    parts[1] = newName;
                }
                
                // update password if they provided a new one
                if (newPassword != null && newPassword.isEmpty() == false) {
                    parts[3] = newPassword;
                }
                
                // create the new updated string and add to our new list
                String modifiedLine = parts[0] + "|" + parts[1] + "|" + parts[2] + "|" + parts[3] + "|" + parts[4];
                newUpdatedList.add(modifiedLine);
                
            } else {
                // if it's not the user we want to update, just keep the old line
                newUpdatedList.add(currentLine);
            }
        }
        
        // overwrite the users file with our new updated list
        fh.writeLines(fh.getUsersFile(), newUpdatedList);
    }

    // Method to get a list of all users in the system
    public ArrayList<User> getAllUsers() {
        ArrayList<String> allLines = fh.readLines(fh.getUsersFile());
        ArrayList<User> userList = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            if (parts.length >= 5) {
                // create a user object and add it to our list
                User u = new User(parts[0], parts[1], parts[2], parts[3], parts[4]);
                userList.add(u);
            }
        }
        
        return userList;
    }

    // Method to remove a user from the text file
    public void deleteUser(String idToDelete) {
        ArrayList<String> allLines = fh.readLines(fh.getUsersFile());
        ArrayList<String> listAfterDelete = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // if we find the user we want to delete
            if (parts.length >= 5 && parts[0].trim().equals(idToDelete.trim())) {
                // do nothing! we just skip them so they don't get added to the new list
            } else {
                // add everyone else to the new list
                listAfterDelete.add(currentLine);
            }
        }
        
        // overwrite the file without the deleted user
        fh.writeLines(fh.getUsersFile(), listAfterDelete);
    }
}
