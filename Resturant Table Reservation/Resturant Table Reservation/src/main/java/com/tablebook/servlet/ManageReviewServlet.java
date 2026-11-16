package com.tablebook.servlet;

import com.tablebook.service.ReviewService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/customer/manage-review")
public class ManageReviewServlet extends HttpServlet {
    private ReviewService reviewService;

    @Override
    public void init() {
        reviewService = new ReviewService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"CUSTOMER".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        String userEmail = (String) session.getAttribute("userEmail");

        String action = req.getParameter("action");
        String restaurantId = req.getParameter("restaurantId");

        if ("update".equals(action)) {
            int rating = Integer.parseInt(req.getParameter("rating"));
            String comment = req.getParameter("comment");
            reviewService.updateReview(restaurantId, userEmail, rating, comment);
            resp.sendRedirect(req.getContextPath() + "/customer/dashboard?success=Review+Updated");
        } else if ("delete".equals(action)) {
            reviewService.deleteReview(restaurantId, userEmail);
            resp.sendRedirect(req.getContextPath() + "/customer/dashboard?success=Review+Deleted");
        }
    }
}
