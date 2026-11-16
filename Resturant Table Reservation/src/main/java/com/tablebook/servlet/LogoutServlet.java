package com.tablebook.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/auth/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //dont create new session. only return existing one.
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate(); //DELETES session. user logs out.
        }
        resp.sendRedirect(req.getContextPath() + "/login.jsp?success=Logged+Out");
    }
}
