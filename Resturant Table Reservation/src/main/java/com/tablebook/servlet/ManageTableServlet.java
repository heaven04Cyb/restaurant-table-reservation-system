package com.tablebook.servlet;

import com.tablebook.service.TableService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/owner/table")
public class ManageTableServlet extends HttpServlet {
    private TableService tableService;

    @Override
    public void init() {
        tableService = new TableService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"OWNER".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String tableId = req.getParameter("tableId");

        if ("delete".equals(action)) {
            tableService.deleteTable(tableId);
            resp.sendRedirect(req.getContextPath() + "/owner/dashboard?success=Table+Deleted");
        }
    }
}
