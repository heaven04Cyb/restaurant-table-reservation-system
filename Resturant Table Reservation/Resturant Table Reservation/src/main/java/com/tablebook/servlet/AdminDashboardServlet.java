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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet { //inherit
    private UserService userService;
    private RestaurantService restaurantService;
    private ReservationService reservationService;
    //test123

    @Override
    public void init() {
        userService = new UserService();
        restaurantService = new RestaurantService();
        reservationService = new ReservationService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        ArrayList<User> users = userService.getAllUsers();
        ArrayList<Restaurant> restaurants = restaurantService.getAllRestaurants();
        int totalReservations = reservationService.getTotalCount();

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
        if ("createOwner".equals(action)) {
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            userService.register(name, email, password, "OWNER");
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
