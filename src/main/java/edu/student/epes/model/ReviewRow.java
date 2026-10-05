package edu.student.epes.model;

import java.math.BigDecimal;

/** One evaluation row for the dashboard's recent-review table. */
public final class ReviewRow {
    private final String employeeName;
    private final String jobTitle;
    private final String cycleName;
    private final String status;
    private final String updatedAtLabel;
    private final BigDecimal averageRating;

    public ReviewRow(String employeeName, String jobTitle, String cycleName,
                     String status, String updatedAtLabel, BigDecimal averageRating) {
        this.employeeName = employeeName;
        this.jobTitle = jobTitle;
        this.cycleName = cycleName;
        this.status = status;
        this.updatedAtLabel = updatedAtLabel;
        this.averageRating = averageRating;
    }

    public String getEmployeeName() { return employeeName; }
    public String getJobTitle() { return jobTitle; }
    public String getCycleName() { return cycleName; }
    public String getStatus() { return status; }
    public String getUpdatedAtLabel() { return updatedAtLabel; }
    public BigDecimal getAverageRating() { return averageRating; }
}
