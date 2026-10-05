package edu.student.epes.model;

import java.util.List;

/** Immutable data transfer object passed from the service to the web view. */
public final class DashboardData {
    private final DashboardMetrics metrics;
    private final List<ReviewRow> recentReviews;

    public DashboardData(DashboardMetrics metrics, List<ReviewRow> recentReviews) {
        this.metrics = metrics;
        this.recentReviews = List.copyOf(recentReviews);
    }

    public DashboardMetrics getMetrics() { return metrics; }
    public List<ReviewRow> getRecentReviews() { return recentReviews; }

    public static DashboardData empty() {
        return new DashboardData(new DashboardMetrics(0, 0, 0, 0), List.of());
    }
}
