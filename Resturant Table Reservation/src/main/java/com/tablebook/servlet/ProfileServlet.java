package com.tablebook.servlet;

import com.tablebook.service.UserService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/auth/profile")
public class ProfileServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        //Checks user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        //READS UserID from session
        String userId = (String) session.getAttribute("userId");
        String action = req.getParameter("action");

        if ("update".equals(action)) {
            String name = req.getParameter("name");
            String password = req.getParameter("password");
            //UPDATES User Info
            userService.updateProfile(userId, name, password);
            resp.sendRedirect(req.getContextPath() + "/login.jsp?success=Profile+Updated.+Please+login+again");
            //after passwrd update user must log again
            session.invalidate();
        } else if ("delete".equals(action)) {
            userService.deleteUser(userId);
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?success=Account+Deleted");
        }
    }
}
