package com.tablebook.servlet;

import com.tablebook.service.UserService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/auth/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    //using Post bcs sensitive data like passwords  should not appear in the URL
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        //CREATES new User
        userService.register(name, email, password, "CUSTOMER");
        //sends user to another page
        resp.sendRedirect(req.getContextPath() + "/login.jsp?success=Registration+Successful");
    }
}
