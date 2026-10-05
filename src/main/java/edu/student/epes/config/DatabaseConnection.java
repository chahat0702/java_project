package edu.student.epes.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Opens JDBC connections using environment configuration, keeping secrets out of source. */
public final class DatabaseConnection {
    private static final String DEFAULT_URL =
            "jdbc:mysql://localhost:3306/employee_performance?serverTimezone=UTC";

    private DatabaseConnection() {
    }

    public static Connection open() throws SQLException {
        String url = environmentOrDefault("EPES_DB_URL", DEFAULT_URL);
        String username = System.getenv("EPES_DB_USER");
        String password = System.getenv("EPES_DB_PASSWORD");
        if (username == null || username.isBlank()) {
            throw new IllegalStateException("Set EPES_DB_USER before starting the application.");
        }
        return DriverManager.getConnection(url, username, password == null ? "" : password);
    }

    private static String environmentOrDefault(String name, String fallback) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? fallback : value;
    }
}
