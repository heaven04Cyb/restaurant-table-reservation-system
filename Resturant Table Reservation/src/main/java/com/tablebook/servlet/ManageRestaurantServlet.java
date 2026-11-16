package com.tablebook.servlet;

import com.tablebook.service.RestaurantService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/owner/restaurant")
public class ManageRestaurantServlet extends HttpServlet {
    private RestaurantService restaurantService;

    @Override
    public void init() {
        restaurantService = new RestaurantService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"OWNER".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String restaurantId = req.getParameter("restaurantId");

        if ("update".equals(action)) {
            String location = req.getParameter("location");
            String hours = req.getParameter("hours");
            restaurantService.updateRestaurant(restaurantId, location, hours);
            resp.sendRedirect(req.getContextPath() + "/owner/dashboard?success=Restaurant+Updated");
        } else if ("delete".equals(action)) {
            restaurantService.deleteRestaurant(restaurantId);
            resp.sendRedirect(req.getContextPath() + "/owner/dashboard?success=Restaurant+Deleted");
        }
    }
}
