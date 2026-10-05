package edu.student.epes.dao;

import edu.student.epes.config.DatabaseConnection;
import edu.student.epes.model.DashboardData;
import edu.student.epes.model.DashboardMetrics;
import edu.student.epes.model.ReviewRow;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Database queries used by the first review dashboard. */
public final class DashboardDao {
    public DashboardData loadDashboard() throws SQLException {
        return new DashboardData(loadMetrics(), loadRecentReviews());
    }

    private DashboardMetrics loadMetrics() throws SQLException {
        String sql = """
                SELECT
                    (SELECT COUNT(*) FROM employees
                     WHERE employment_status = 'ACTIVE') AS active_employees,
                    COUNT(*) AS total_evaluations,
                    COALESCE(SUM(CASE
                        WHEN evaluation_status IN ('DRAFT', 'IN_REVIEW') THEN 1
                        ELSE 0 END), 0) AS awaiting_action,
                    COALESCE(SUM(CASE
                        WHEN evaluation_status IN ('SUBMITTED', 'ACKNOWLEDGED') THEN 1
                        ELSE 0 END), 0) AS completed_evaluations
                FROM evaluations
                """;
        try (Connection connection = DatabaseConnection.open();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {
            if (result.next()) {
                return new DashboardMetrics(
                        result.getLong("active_employees"),
                        result.getLong("total_evaluations"),
                        result.getLong("awaiting_action"),
                        result.getLong("completed_evaluations"));
            }
        }
        return new DashboardMetrics(0, 0, 0, 0);
    }

    private List<ReviewRow> loadRecentReviews() throws SQLException {
        String sql = """
                SELECT employee.full_name,
                       employee.job_title,
                       cycle.cycle_name,
                       evaluation.evaluation_status,
                       DATE_FORMAT(evaluation.updated_at, '%b %e, %Y') AS updated_at_label,
                       COALESCE(AVG(score.rating), 0.00) AS average_rating
                FROM evaluations evaluation
                JOIN employees employee
                  ON employee.employee_id = evaluation.employee_id
                JOIN review_cycles cycle
                  ON cycle.cycle_id = evaluation.cycle_id
                LEFT JOIN evaluation_scores score
                  ON score.evaluation_id = evaluation.evaluation_id
                GROUP BY evaluation.evaluation_id, employee.full_name,
                         employee.job_title, cycle.cycle_name,
                         evaluation.evaluation_status, evaluation.updated_at
                ORDER BY evaluation.updated_at DESC
                LIMIT 8
                """;
        List<ReviewRow> rows = new ArrayList<>();
        try (Connection connection = DatabaseConnection.open();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {
            while (result.next()) {
                rows.add(new ReviewRow(
                        result.getString("full_name"),
                        result.getString("job_title"),
                        result.getString("cycle_name"),
                        result.getString("evaluation_status"),
                        result.getString("updated_at_label"),
                        result.getBigDecimal("average_rating")));
            }
        }
        return rows;
    }
}
