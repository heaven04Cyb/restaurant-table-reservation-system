package com.tablebook.service;

import com.tablebook.model.Review;
import java.util.ArrayList;

// Service class to handle restaurant reviews
public class ReviewService {
    // need FileHandler to save data
    private FileHandler fh;
    
    private String delimiter = "\\|";

    // Constructor to setup the FileHandler
    public ReviewService() {
        this.fh = new FileHandler();
    }

    // Method to add a new review
    public void addReview(String restaurantId, String userEmail, int rating, String comment) {
        // create a random unique ID for this review
        String newId = "REV" + System.currentTimeMillis();
        
        // combine everything into one string line
        String newReviewLine = newId + "|" + restaurantId + "|" + userEmail + "|" + rating + "|" + comment;
        
        // add the line to the end of the text file
        fh.appendLine(fh.getReviewsFile(), newReviewLine);
    }

    // Method to get all reviews for one specific restaurant
    public ArrayList<Review> getRestaurantReviews(String targetRestaurantId) {
        ArrayList<String> allLines = fh.readLines(fh.getReviewsFile());
        ArrayList<Review> reviewList = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // make sure the line has all 5 parts
            if (parts.length >= 5) {
                // if the restaurant ID matches our target
                if (parts[1].equals(targetRestaurantId)) {
                    // convert rating from String to integer
                    int theRating = Integer.parseInt(parts[3]);
                    
                    // create object and add to list
                    Review r = new Review(parts[0], parts[1], parts[2], theRating, parts[4]);
                    reviewList.add(r);
                }
            }
        }
        return reviewList;
    }

    // Method to update an existing review
    public void updateReview(String targetRestaurantId, String targetUserEmail, int newRating, String newComment) {
        ArrayList<String> allLines = fh.readLines(fh.getReviewsFile());
        ArrayList<String> updatedList = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // find the review that belongs to this specific user for this specific restaurant
            if (parts.length >= 5 && parts[1].equals(targetRestaurantId) && parts[2].equals(targetUserEmail)) {
                // update the rating and comment
                parts[3] = String.valueOf(newRating);
                parts[4] = newComment;
                
                // reconstruct the line
                String modifiedLine = parts[0] + "|" + parts[1] + "|" + parts[2] + "|" + parts[3] + "|" + parts[4];
                updatedList.add(modifiedLine);
            } else {
                // keep the old line
                updatedList.add(currentLine);
            }
        }
        
        // overwrite the file with the changes
        fh.writeLines(fh.getReviewsFile(), updatedList);
    }

    // Method to completely delete a review
    public void deleteReview(String targetRestaurantId, String targetUserEmail) {
        ArrayList<String> allLines = fh.readLines(fh.getReviewsFile());
        ArrayList<String> listAfterDelete = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // find the review
            if (parts.length >= 5 && parts[1].equals(targetRestaurantId) && parts[2].equals(targetUserEmail)) {
                // skip it to delete it!
            } else {
                // add everyone else
                listAfterDelete.add(currentLine);
            }
        }
        
        // save to text file
        fh.writeLines(fh.getReviewsFile(), listAfterDelete);
    }
}
