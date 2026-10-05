package edu.student.epes.web;

import edu.student.epes.dao.DashboardDao;
import edu.student.epes.model.DashboardData;
import edu.student.epes.service.DashboardService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/** Handles dashboard requests and keeps SQL work out of the JSP view. */
@WebServlet(urlPatterns = {"/", "/dashboard"})
public final class DashboardServlet extends HttpServlet {
    private DashboardService dashboardService;

    @Override
    public void init() {
        dashboardService = new DashboardService(new DashboardDao());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            DashboardData data = dashboardService.loadDashboard();
            request.setAttribute("metrics", data.getMetrics());
            request.setAttribute("recentReviews", data.getRecentReviews());
            request.setAttribute("databaseReady", true);
        } catch (SQLException | IllegalStateException exception) {
            getServletContext().log("Could not load the evaluation dashboard.", exception);
            DashboardData empty = DashboardData.empty();
            request.setAttribute("metrics", empty.getMetrics());
            request.setAttribute("recentReviews", empty.getRecentReviews());
            request.setAttribute("databaseReady", false);
            request.setAttribute("databaseError",
                    "The database is not available. Check the connection settings and try again.");
        }
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp")
                .forward(request, response);
    }
}
