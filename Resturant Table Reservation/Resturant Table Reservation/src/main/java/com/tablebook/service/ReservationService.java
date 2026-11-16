package com.tablebook.service;

import com.tablebook.model.Reservation;
import java.util.ArrayList;

// Service class to handle customer bookings
public class ReservationService {
    // we use FileHandler to read text files
    private FileHandler fh;
    // we also need TableService to change table availability
    private TableService tableService;
    
    // pipe symbol separates data in the text file
    private String delimiter = "\\|";

    // Constructor creates the objects we need
    public ReservationService() {
        this.fh = new FileHandler();
        this.tableService = new TableService();
    }

    // Method to create a new booking
    public void createReservation(String userEmail, String restaurantId, String tableId, String date, String time, int partySize) {
        // generate a random unique ID
        String newId = "RESV" + System.currentTimeMillis();
        
        // combine all variables into one long string separated by pipes
        // initial status is always Confirmed
        String newBooking = newId + "|" + userEmail + "|" + restaurantId + "|" + tableId + "|" + date + "|" + time + "|" + partySize + "|Confirmed";
        
        // save it to the text file
        fh.appendLine(fh.getReservationsFile(), newBooking);
        
        // we must change the table status to RESERVED so no one else can book it
        tableService.updateStatus(tableId, "RESERVED");
    }

    // Method to get a list of all bookings for a specific customer
    public ArrayList<Reservation> getUserReservations(String targetEmail) {
        ArrayList<String> allLines = fh.readLines(fh.getReservationsFile());
        ArrayList<Reservation> userBookings = new ArrayList<>();
        
        // basic loop through the text file
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // check if there are 8 parts (id, email, restId, tableId, date, time, size, status)
            if (parts.length >= 8) {
                // if the email matches our target email
                if (parts[1].equals(targetEmail)) {
                    // create an object and add it to the list
                    int size = Integer.parseInt(parts[6]);
                    Reservation r = new Reservation(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], size, parts[7]);
                    userBookings.add(r);
                }
            }
        }
        
        return userBookings;
    }

    // Method to count total reservations (for the admin dashboard)
    public int getTotalCount() {
        // just read all lines and get the size
        return fh.readLines(fh.getReservationsFile()).size();
    }

    // Method to cancel a booking (but keep the record)
    public void cancelReservation(String targetReservationId) {
        ArrayList<String> allLines = fh.readLines(fh.getReservationsFile());
        ArrayList<String> newUpdatedList = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // if we find the booking we want to cancel
            if (parts.length >= 8 && parts[0].equals(targetReservationId)) {
                // update the status to Cancelled
                parts[7] = "Cancelled";
                
                // put the string back together
                String modifiedLine = parts[0] + "|" + parts[1] + "|" + parts[2] + "|" + parts[3] + "|" + parts[4] + "|" + parts[5] + "|" + parts[6] + "|" + parts[7];
                newUpdatedList.add(modifiedLine);
                
                // CRITICAL: we must make the table AVAILABLE again so someone else can book it!
                tableService.updateStatus(parts[3], "AVAILABLE");
            } else {
                // keep the old line if it's not the one we are cancelling
                newUpdatedList.add(currentLine);
            }
        }
        
        // save the changes back to the text file
        fh.writeLines(fh.getReservationsFile(), newUpdatedList);
    }

    // Method to completely delete a booking record
    public void deleteReservation(String targetReservationId) {
        ArrayList<String> allLines = fh.readLines(fh.getReservationsFile());
        ArrayList<String> listAfterDelete = new ArrayList<>();
        
        for (int i = 0; i < allLines.size(); i++) {
            String currentLine = allLines.get(i);
            String[] parts = currentLine.split(delimiter);
            
            // if we find the record
            if (parts.length >= 8 && parts[0].equals(targetReservationId)) {
                // we do nothing! this removes it from the final list
            } else {
                // we keep everyone else
                listAfterDelete.add(currentLine);
            }
        }
        
        // overwrite the file without the deleted record
        fh.writeLines(fh.getReservationsFile(), listAfterDelete);
    }
}
