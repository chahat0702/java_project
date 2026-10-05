package edu.student.epes.service;

import edu.student.epes.dao.DashboardDao;
import edu.student.epes.model.DashboardData;

import java.sql.SQLException;

/** Application service for dashboard use cases. */
public final class DashboardService {
    private final DashboardDao dashboardDao;

    public DashboardService(DashboardDao dashboardDao) {
        this.dashboardDao = dashboardDao;
    }

    public DashboardData loadDashboard() throws SQLException {
        return dashboardDao.loadDashboard();
    }
}
