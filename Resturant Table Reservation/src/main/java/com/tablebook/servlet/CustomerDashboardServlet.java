package com.tablebook.servlet;

import com.tablebook.model.Reservation;
import com.tablebook.model.Restaurant;
import com.tablebook.model.Table;
import com.tablebook.service.ReservationService;
import com.tablebook.service.RestaurantService;
import com.tablebook.service.TableService;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/customer/dashboard")
public class CustomerDashboardServlet extends HttpServlet {
    private RestaurantService restaurantService;
    private TableService tableService;
    private ReservationService reservationService;

    @Override
    public void init() {
        restaurantService = new RestaurantService();
        tableService = new TableService();
        reservationService = new ReservationService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"CUSTOMER".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        
        ArrayList<Restaurant> restaurants = restaurantService.getAllRestaurants();
        req.setAttribute("restaurants", restaurants);

        String selId = req.getParameter("restaurantId");
        if (selId != null && !selId.isEmpty()) {
            ArrayList<Table> tables = tableService.getAvailableTables(selId);
            System.out.println("DEBUG: RestaurantID selected: '" + selId + "'");
            System.out.println("DEBUG: Tables found: " + tables.size());
            req.setAttribute("tables", tables);
            req.setAttribute("selectedRestaurantId", selId);
        }

        ArrayList<Reservation> myReservations = reservationService.getUserReservations(userEmail);
        req.setAttribute("myReservations", myReservations);

        req.getRequestDispatcher("/customer-dashboard.jsp").forward(req, resp);
    }
}
