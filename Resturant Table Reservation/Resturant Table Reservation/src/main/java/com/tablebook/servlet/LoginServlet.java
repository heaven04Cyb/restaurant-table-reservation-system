package com.tablebook.servlet;

import com.tablebook.model.User;
import com.tablebook.service.UserService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// This servlet handles when a user tries to log in
@WebServlet("/auth/login")
public class LoginServlet extends HttpServlet {
    // we need the user service to check the text file
    private UserService myUserService;

    // init runs once when the server starts
    @Override
    public void init() {
        myUserService = new UserService();
    }

    // doPost happens when the user clicks the login button on the form
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // get the email and password from the text boxes in the HTML form
        String inputEmail = req.getParameter("email");
        String inputPassword = req.getParameter("password");

        // ask the service to see if these match anyone in our system
        User loggedInUser = myUserService.login(inputEmail, inputPassword);
        
        // if loggedInUser is NOT null, it means login was successful!
        if (loggedInUser != null) {
            
            // create a new session to remember they are logged in
            HttpSession mySession = req.getSession();
            
            // save their info in the session variables
            mySession.setAttribute("userId", loggedInUser.getId());
            mySession.setAttribute("userEmail", loggedInUser.getEmail());
            mySession.setAttribute("userRole", loggedInUser.getRole());

            // check their role to decide which page to send them to
            if (loggedInUser.getRole().equals("ADMIN")) {
                // send admins to the admin dashboard
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                
            } else if (loggedInUser.getRole().equals("OWNER")) {
                // send restaurant owners to the owner portal
                resp.sendRedirect(req.getContextPath() + "/owner/dashboard");
                
            } else {
                // if they are not admin or owner, they must be a normal customer
                resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
            }
            
        } else {
            // if login failed (loggedInUser is null), send them back to login page with an error message
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+Credentials");
        }
    }
}
