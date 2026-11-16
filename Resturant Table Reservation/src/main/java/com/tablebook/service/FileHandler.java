package com.tablebook.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

// A simple file handler to read and write to text files
public class FileHandler {
    
    // I am storing the folder path here
    private String dataDir;
    
    // These are the file paths for my database
    private String usersFile;
    private String restaurantsFile;
    private String tablesFile;
    private String reservationsFile;
    private String reviewsFile;

    // Constructor to set up the files when we create the object
    public FileHandler() {
        // get the current working directory and add /data/
        this.dataDir = System.getProperty("user.dir") + "/data/";
        
        // set all the file locations
        this.usersFile = dataDir + "users.txt";
        this.restaurantsFile = dataDir + "restaurants.txt";
        this.tablesFile = dataDir + "tables.txt";
        this.reservationsFile = dataDir + "reservations.txt";
        this.reviewsFile = dataDir + "reviews.txt";
        
        // call this method to make sure folders and files exist
        initDataDir();
    }

    // method to create the folder and files if they don't exist
    private void initDataDir() {
        File folder = new File(dataDir);
        
        // if folder does not exist, make it
        if (folder.exists() == false) {
            folder.mkdirs();
        }
        
        // create array of all my files
        String[] myFiles = {usersFile, restaurantsFile, tablesFile, reservationsFile, reviewsFile};
        
        // basic for loop to go through each file
        for (int i = 0; i < myFiles.length; i++) {
            File currentFile = new File(myFiles[i]);
            
            // if the file is missing, create a new empty one
            if (currentFile.exists() == false) {
                try {
                    currentFile.createNewFile();
                } catch (IOException e) {
                    // print error
                    System.out.println("Could not create file: " + currentFile.getName());
                }
            }
        }
    }

    // method to read a text file and return a list of strings
    public ArrayList<String> readLines(String filePath) {
        ArrayList<String> myLines = new ArrayList<>();
        File fileToRead = new File(filePath);
        
        // if file is not there, return empty list
        if (fileToRead.exists() == false) {
            return myLines;
        }

        // try to read the file using BufferedReader
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath, StandardCharsets.UTF_8))) {
            String line;
            
            // read line by line until the end
            while ((line = reader.readLine()) != null) {
                // remove spaces from the ends
                line = line.trim();
                
                // only add it if it is not a blank line
                if (line.isEmpty() == false) {
                    myLines.add(line);
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading the file: " + e.getMessage());
        }
        
        return myLines;
    }

    // method to add one single line to the end of a file
    public void appendLine(String filePath, String line) {
        // the "true" part means we append to the file instead of overwriting
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, StandardCharsets.UTF_8, true))) {
            writer.write(line);
            writer.newLine();
        } catch (IOException e) {
            System.out.println("Error saving to file: " + e.getMessage());
        }
    }

    // method to overwrite the whole file with a new list of strings
    // we use this when we delete or update something
    public void writeLines(String filePath, ArrayList<String> newLines) {
        // the "false" part means we overwrite everything
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, StandardCharsets.UTF_8, false))) {
            
            // loop through the list and write each string
            for (int i = 0; i < newLines.size(); i++) {
                writer.write(newLines.get(i));
                writer.newLine(); // go to next line
            }
            
        } catch (IOException e) {
            System.out.println("Error writing all lines: " + e.getMessage());
        }
    }

    // simple getters so other classes can know the file paths
    public String getUsersFile() { 
        return usersFile; 
    }
    
    public String getRestaurantsFile() { 
        return restaurantsFile; 
    }
    
    public String getTablesFile() { 
        return tablesFile; 
    }
    
    public String getReservationsFile() { 
        return reservationsFile; 
    }
    
    public String getReviewsFile() { 
        return reviewsFile; 
    }
}
