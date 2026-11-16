package com.tablebook.servlet;

import com.tablebook.service.ReservationService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/customer/book")
public class BookingServlet extends HttpServlet {
    private ReservationService reservationService;

    @Override
    public void init() {
        reservationService = new ReservationService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"CUSTOMER".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        String restaurantId = req.getParameter("restaurantId");
        String tableId = req.getParameter("tableId");
        String date = req.getParameter("date");
        String time = req.getParameter("time");
        int partySize = Integer.parseInt(req.getParameter("partySize"));

        reservationService.createReservation(userEmail, restaurantId, tableId, date, time, partySize);
        resp.sendRedirect(req.getContextPath() + "/customer/dashboard?success=Reservation+Confirmed");
    }
}
