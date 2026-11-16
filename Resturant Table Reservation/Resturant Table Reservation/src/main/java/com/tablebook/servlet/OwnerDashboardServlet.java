package com.tablebook.servlet;

import com.tablebook.model.Restaurant;
import com.tablebook.model.Table;
import com.tablebook.service.RestaurantService;
import com.tablebook.service.TableService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/owner/dashboard")
public class OwnerDashboardServlet extends HttpServlet {
    private RestaurantService restaurantService;
    private TableService tableService;

    @Override
    public void init() {
        restaurantService = new RestaurantService();
        tableService = new TableService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"OWNER".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String ownerId = (String) session.getAttribute("userId");
        ArrayList<Restaurant> restaurants = restaurantService.getRestaurantsByOwnerId(ownerId);
        
        HashMap<String, ArrayList<Table>> tablesMap = new HashMap<>();
        if (restaurants != null && !restaurants.isEmpty()) {
            for (Restaurant r : restaurants) {
                ArrayList<Table> tables = tableService.getAllTables(r.getId());
                tablesMap.put(r.getId(), tables);
            }
        }
        req.setAttribute("restaurants", restaurants);
        req.setAttribute("tablesMap", tablesMap);

        req.getRequestDispatcher("/owner-dashboard.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"OWNER".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String ownerId = (String) session.getAttribute("userId");
        
        if ("addRestaurant".equals(action)) {
            String name = req.getParameter("name");
            String location = req.getParameter("location");
            String hours = req.getParameter("hours");
            restaurantService.addRestaurant(name, location, hours, ownerId);
        } else if ("addTable".equals(action)) {
            String restaurantId = req.getParameter("restaurantId");
            String tableNumber = req.getParameter("tableNumber");
            int capacity = Integer.parseInt(req.getParameter("capacity"));
            tableService.addTable(restaurantId, tableNumber, capacity);
        }
        
        resp.sendRedirect(req.getContextPath() + "/owner/dashboard?success=Operation+Successful");
    }
}
