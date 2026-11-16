package com.tablebook.service;

import com.tablebook.model.Restaurant;
import java.util.ArrayList;

// Service class to handle all restaurant operations
public class RestaurantService {
    // we need the FileHandler to talk to our text files
    private FileHandler fh;
    
    // symbol used to separate columns in our text file
    private String delimiter = "\\|";

    // Constructor creates a new FileHandler
    public RestaurantService() {
        this.fh = new FileHandler();
    }

    // Method to add a brand new restaurant
    public void addRestaurant(String name, String location, String operatingHours, String ownerId) {
        // generate a random ID using the current time so it's always unique
        String newId = "RES" + System.currentTimeMillis();
        
        // combine everything into one string with pipes
        String newRecord = newId + "|" + name + "|" + location + "|" + operatingHours + "|" + ownerId;
        
        // append the new record to the file
        fh.appendLine(fh.getRestaurantsFile(), newRecord);
    }

    // Method to get a list of all restaurants in the system
    public ArrayList<Restaurant> getAllRestaurants() {
        ArrayList<String> allLines = fh.readLines(fh.getRestaurantsFile());
        ArrayList<Restaurant> restaurantList = new ArrayList<>();
        
        // basic loop to go through each line
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // make sure it has all 5 parts (id, name, location, hours, ownerId)
            if (parts.length >= 5) {
                // create the object and add to our list
                Restaurant res = new Restaurant(parts[0], parts[1], parts[2], parts[3], parts[4]);
                restaurantList.add(res);
            }
        }
        
        return restaurantList;
    }

    // Method to find all restaurants owned by a specific owner
    public ArrayList<Restaurant> getRestaurantsByOwnerId(String targetOwnerId) {
        // first get all restaurants
        ArrayList<Restaurant> allRestaurants = getAllRestaurants();
        
        // create a new list just for this owner
        ArrayList<Restaurant> ownerRestaurants = new ArrayList<>();
        
        for (int i = 0; i < allRestaurants.size(); i++) {
            Restaurant currentRes = allRestaurants.get(i);
            
            // check if the owner ID matches
            if (currentRes.getOwnerId().equals(targetOwnerId)) {
                ownerRestaurants.add(currentRes);
            }
        }
        
        return ownerRestaurants;
    }
    
    // Method to find one specific restaurant by its ID
    public Restaurant getRestaurantById(String targetId) {
        ArrayList<Restaurant> allRestaurants = getAllRestaurants();
        
        for (int i = 0; i < allRestaurants.size(); i++) {
            Restaurant currentRes = allRestaurants.get(i);
            
            // check if the ID matches
            if (currentRes.getId().equals(targetId)) {
                return currentRes;
            }
        }
        
        // return null if we couldn't find it
        return null;
    }

    // Method to change the location or hours of a restaurant
    public void updateRestaurant(String idToUpdate, String newLocation, String newHours) {
        ArrayList<String> allLines = fh.readLines(fh.getRestaurantsFile());
        ArrayList<String> updatedLines = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // if we find the restaurant we want to update
            if (parts.length >= 5 && parts[0].equals(idToUpdate)) {
                // update the specific columns
                parts[2] = newLocation;
                parts[3] = newHours;
                
                // put the string back together
                String modifiedLine = parts[0] + "|" + parts[1] + "|" + parts[2] + "|" + parts[3] + "|" + parts[4];
                updatedLines.add(modifiedLine);
            } else {
                // just keep the old line if it's not the one we're updating
                updatedLines.add(currentLine);
            }
        }
        
        // overwrite the text file
        fh.writeLines(fh.getRestaurantsFile(), updatedLines);
    }

    // Method to remove a restaurant completely
    public void deleteRestaurant(String idToDelete) {
        ArrayList<String> allLines = fh.readLines(fh.getRestaurantsFile());
        ArrayList<String> linesAfterDelete = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // if we find the restaurant to delete
            if (parts.length >= 5 && parts[0].equals(idToDelete)) {
                // do nothing! we skip it so it is deleted
            } else {
                // keep everything else
                linesAfterDelete.add(currentLine);
            }
        }
        
        // save the new file data
        fh.writeLines(fh.getRestaurantsFile(), linesAfterDelete);
    }
}
