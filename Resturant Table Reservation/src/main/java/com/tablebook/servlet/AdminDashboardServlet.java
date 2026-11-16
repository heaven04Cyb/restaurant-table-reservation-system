package com.tablebook.servlet;

import com.tablebook.model.Restaurant;
import com.tablebook.model.User;
import com.tablebook.service.ReservationService;
import com.tablebook.service.RestaurantService;
import com.tablebook.service.UserService;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Map this servlet to the URL "/admin/dashboard"
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet { //inherit
    // Service objects for handling business logic
    private UserService userService;
    private RestaurantService restaurantService;
    private ReservationService reservationService;


    // Initialize services when servlet starts
    @Override
    public void init() {
        userService = new UserService();
        restaurantService = new RestaurantService();
        reservationService = new ReservationService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get existing session
        HttpSession session = req.getSession(false);
        // Check whether user is logged in as ADMIN
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Get all users from database
        ArrayList<User> users = userService.getAllUsers();
        ArrayList<Restaurant> restaurants = restaurantService.getAllRestaurants();
        int totalReservations = reservationService.getTotalCount();

        // Send data to JSP page
        req.setAttribute("users", users);
        req.setAttribute("restaurants", restaurants);
        req.setAttribute("totalReservations", totalReservations);

        req.getRequestDispatcher("/admin-dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        // Create new restaurant owner
        if ("createOwner".equals(action)) {

            // Get form values
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            // Register owner with OWNER role
            userService.register(name, email, password, "OWNER");
            // Redirect with success message
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Owner+Created");
        } else if ("deleteUser".equals(action)) {
            String userId = req.getParameter("userId");
            userService.deleteUser(userId);
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?success=User+Deleted");
        } else if ("deleteRestaurant".equals(action)) {
            String restaurantId = req.getParameter("restaurantId");
            restaurantService.deleteRestaurant(restaurantId);
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Restaurant+Deleted");
        }
    }
}
