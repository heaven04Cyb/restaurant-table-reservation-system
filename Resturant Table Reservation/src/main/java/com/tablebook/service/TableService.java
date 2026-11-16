package com.tablebook.service;

import com.tablebook.model.Table;
import java.util.ArrayList;

// Service class to handle operations for tables
public class TableService {
    // we use FileHandler to connect to our data files
    private FileHandler fh;
    
    // the pipe symbol separates our data columns
    private String delimiter = "\\|";

    // Constructor creates a new FileHandler
    public TableService() {
        this.fh = new FileHandler();
    }

    // Method to add a new table to a restaurant
    public void addTable(String restaurantId, String tableNumber, int capacity) {
        // create a unique ID for the table
        String newId = "TBL" + System.currentTimeMillis();
        
        // combine the data into one string line. Default status is AVAILABLE
        String newLine = newId + "|" + restaurantId + "|" + tableNumber + "|" + capacity + "|AVAILABLE";
        
        // append it to the tables text file
        fh.appendLine(fh.getTablesFile(), newLine);
    }

    // Method to find all AVAILABLE tables for a specific restaurant
    public ArrayList<Table> getAvailableTables(String targetRestaurantId) {
        ArrayList<String> allLines = fh.readLines(fh.getTablesFile());
        ArrayList<Table> availableTables = new ArrayList<>();
        
        // basic loop to check each line
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // check if the line has all 5 parts
            if (parts.length >= 5) {
                // I am using .trim() here to fix a bug where invisible spaces caused errors
                String resId = parts[1].trim();
                String status = parts[4].trim();
                
                // if it belongs to the restaurant AND is available, add it to our list
                if (resId.equals(targetRestaurantId.trim()) && status.equals("AVAILABLE")) {
                    // convert capacity to integer
                    int cap = Integer.parseInt(parts[3].trim());
                    Table t = new Table(parts[0].trim(), resId, parts[2].trim(), cap, status);
                    availableTables.add(t);
                }
            }
        }
        return availableTables;
    }

    // Method to get ALL tables (both available and occupied) for a restaurant
    public ArrayList<Table> getAllTables(String targetRestaurantId) {
        ArrayList<String> allLines = fh.readLines(fh.getTablesFile());
        ArrayList<Table> allTables = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            if (parts.length >= 5) {
                String resId = parts[1].trim();
                
                // if it belongs to the restaurant, add it
                if (resId.equals(targetRestaurantId.trim())) {
                    int cap = Integer.parseInt(parts[3].trim());
                    Table t = new Table(parts[0].trim(), resId, parts[2].trim(), cap, parts[4].trim());
                    allTables.add(t);
                }
            }
        }
        return allTables;
    }

    // Method to change a table's status (e.g. from AVAILABLE to OCCUPIED)
    public void updateStatus(String tableIdToUpdate, String newStatus) {
        ArrayList<String> allLines = fh.readLines(fh.getTablesFile());
        ArrayList<String> newUpdatedList = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // if we find the table we want to update
            if (parts.length >= 5 && parts[0].trim().equals(tableIdToUpdate.trim())) {
                // update the status column
                parts[4] = newStatus;
                
                // rebuild the line
                String modifiedLine = parts[0].trim() + "|" + parts[1].trim() + "|" + parts[2].trim() + "|" + parts[3].trim() + "|" + parts[4].trim();
                newUpdatedList.add(modifiedLine);
            } else {
                // otherwise just keep the old line
                newUpdatedList.add(currentLine);
            }
        }
        
        // overwrite the file
        fh.writeLines(fh.getTablesFile(), newUpdatedList);
    }

    // Method to permanently delete a table
    public void deleteTable(String tableIdToDelete) {
        ArrayList<String> allLines = fh.readLines(fh.getTablesFile());
        ArrayList<String> linesAfterDelete = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // if we find the table
            if (parts.length >= 5 && parts[0].trim().equals(tableIdToDelete.trim())) {
                // do nothing! skipping it will delete it
            } else {
                // keep everyone else
                linesAfterDelete.add(currentLine);
            }
        }
        
        // overwrite the file without the deleted table
        fh.writeLines(fh.getTablesFile(), linesAfterDelete);
    }
}
