package com.tablebook.servlet;

import com.tablebook.service.ReservationService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/customer/reservation")
public class ManageReservationServlet extends HttpServlet {
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

        String action = req.getParameter("action");
        String reservationId = req.getParameter("reservationId");

        if ("cancel".equals(action)) {
            reservationService.cancelReservation(reservationId);
            resp.sendRedirect(req.getContextPath() + "/customer/dashboard?success=Reservation+Cancelled");
        } else if ("delete".equals(action)) {
            reservationService.deleteReservation(reservationId);
            resp.sendRedirect(req.getContextPath() + "/customer/dashboard?success=Reservation+Deleted");
        }
    }
}
