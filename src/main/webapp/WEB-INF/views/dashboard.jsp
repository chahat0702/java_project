<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Performance reviews | PeopleTrack</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/styles.css' />">
</head>
<body>
<a class="skip-link" href="#main-content">Skip to content</a>
<div class="app-shell">
    <aside class="sidebar" aria-label="Main navigation">
        <a class="brand" href="<c:url value='/dashboard' />">
            <span class="brand-mark" aria-hidden="true">P</span>
            <span>PeopleTrack</span>
        </a>
        <p class="nav-heading">WORKSPACE</p>
        <nav>
            <a class="nav-link nav-link--active" href="<c:url value='/dashboard' />">
                <span aria-hidden="true">▦</span> Overview
            </a>
            <a class="nav-link" href="#recent-reviews">
                <span aria-hidden="true">◎</span> Evaluations
            </a>
            <a class="nav-link" href="#review-cycle">
                <span aria-hidden="true">◷</span> Review cycles
            </a>
        </nav>
        <div class="sidebar-note">
            <span class="sidebar-note__dot" aria-hidden="true"></span>
            <span>Q4 2026 review cycle</span>
        </div>
    </aside>

    <main id="main-content" class="main-content">
        <header class="topbar">
            <div>
                <p class="eyebrow">PEOPLE OPERATIONS</p>
                <h1>Performance overview</h1>
            </div>
            <div class="profile">
                <span class="profile__avatar" aria-hidden="true">AM</span>
                <span class="profile__name">Alex Morgan</span>
            </div>
        </header>

        <section class="welcome-row" aria-labelledby="welcome-title">
            <div>
                <h2 id="welcome-title">Review progress</h2>
                <p>Track evaluation activity across your team.</p>
            </div>
            <a class="button button--primary" href="#recent-reviews">View evaluations</a>
        </section>

        <c:if test="${not databaseReady}">
            <div class="notice notice--warning" role="status">
                <strong>Database connection needed</strong>
                <span><c:out value="${databaseError}" /></span>
            </div>
        </c:if>

        <section class="metrics" aria-label="Review summary">
            <article class="metric">
                <div class="metric__label">Active employees</div>
                <div class="metric__value"><c:out value="${metrics.activeEmployees}" /></div>
                <p class="metric__note">In the employee directory</p>
            </article>
            <article class="metric">
                <div class="metric__label">Total evaluations</div>
                <div class="metric__value"><c:out value="${metrics.totalEvaluations}" /></div>
                <p class="metric__note">Across all review cycles</p>
            </article>
            <article class="metric">
                <div class="metric__label">Awaiting action</div>
                <div class="metric__value"><c:out value="${metrics.awaitingAction}" /></div>
                <p class="metric__note">Draft or in review</p>
            </article>
            <article class="metric">
                <div class="metric__label">Completed</div>
                <div class="metric__value"><c:out value="${metrics.completedEvaluations}" /></div>
                <p class="metric__note">Submitted or acknowledged</p>
            </article>
        </section>

        <section id="recent-reviews" class="review-section" aria-labelledby="reviews-title">
            <div class="section-heading">
                <div>
                    <p class="eyebrow">Q4 2026</p>
                    <h2 id="reviews-title">Recent evaluations</h2>
                </div>
                <span class="muted">Latest updates first</span>
            </div>
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th scope="col">Employee</th>
                        <th scope="col">Review cycle</th>
                        <th scope="col">Status</th>
                        <th scope="col">Avg. rating</th>
                        <th scope="col">Updated</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${recentReviews}" var="review">
                        <tr>
                            <td>
                                <span class="employee-name"><c:out value="${review.employeeName}" /></span>
                                <span class="employee-title"><c:out value="${review.jobTitle}" /></span>
                            </td>
                            <td><c:out value="${review.cycleName}" /></td>
                            <td>
                                <span class="status status--${review.status}">
                                    <c:out value="${review.status}" />
                                </span>
                            </td>
                            <td><c:out value="${review.averageRating}" /> / 5</td>
                            <td><c:out value="${review.updatedAtLabel}" /></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentReviews}">
                        <tr><td class="empty-state" colspan="5">No evaluations to show yet.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>

        <section id="review-cycle" class="cycle-note">
            <div>
                <p class="eyebrow">CURRENT CYCLE</p>
                <h2>Q4 2026</h2>
                <p>October 1 to December 31, 2026</p>
            </div>
            <div class="cycle-note__side">
                <span class="cycle-note__line" aria-hidden="true"></span>
                <span>Keep feedback specific, balanced, and tied to agreed goals.</span>
            </div>
        </section>
    </main>
</div>
</body>
</html>
