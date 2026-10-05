package edu.student.epes.model;

/** Summary values shown at the top of the review dashboard. */
public final class DashboardMetrics {
    private final long activeEmployees;
    private final long totalEvaluations;
    private final long awaitingAction;
    private final long completedEvaluations;

    public DashboardMetrics(long activeEmployees, long totalEvaluations,
                            long awaitingAction, long completedEvaluations) {
        this.activeEmployees = activeEmployees;
        this.totalEvaluations = totalEvaluations;
        this.awaitingAction = awaitingAction;
        this.completedEvaluations = completedEvaluations;
    }

    public long getActiveEmployees() { return activeEmployees; }
    public long getTotalEvaluations() { return totalEvaluations; }
    public long getAwaitingAction() { return awaitingAction; }
    public long getCompletedEvaluations() { return completedEvaluations; }
}
