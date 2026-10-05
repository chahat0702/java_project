USE employee_performance;

INSERT INTO departments (department_name)
VALUES ('Engineering'), ('Product Design')
ON DUPLICATE KEY UPDATE department_name = VALUES(department_name);

INSERT INTO roles (role_name)
VALUES ('ADMIN'), ('MANAGER'), ('EMPLOYEE')
ON DUPLICATE KEY UPDATE role_name = VALUES(role_name);

INSERT INTO review_cycles (cycle_name, start_date, end_date, cycle_status)
VALUES ('Q4 2026', '2026-10-01', '2026-12-31', 'ACTIVE')
ON DUPLICATE KEY UPDATE cycle_status = VALUES(cycle_status);

INSERT INTO competencies (competency_name, description, weight_percent)
VALUES
    ('Delivery', 'Plans work and completes agreed outcomes.', 20.00),
    ('Quality', 'Produces accurate, maintainable work.', 20.00),
    ('Collaboration', 'Works constructively with colleagues.', 20.00),
    ('Communication', 'Shares progress and risks clearly.', 20.00),
    ('Learning', 'Applies feedback and builds relevant skills.', 20.00)
ON DUPLICATE KEY UPDATE description = VALUES(description);

INSERT INTO employees (full_name, email, job_title, department_id, manager_id)
SELECT 'Alex Morgan', 'alex.morgan@example.test', 'Engineering Manager', d.department_id, NULL
FROM departments d WHERE d.department_name = 'Engineering'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name);

INSERT INTO employees (full_name, email, job_title, department_id, manager_id)
SELECT 'Jordan Lee', 'jordan.lee@example.test', 'Software Engineer', d.department_id, m.employee_id
FROM departments d
JOIN employees m ON m.email = 'alex.morgan@example.test'
WHERE d.department_name = 'Engineering'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name);

INSERT INTO employees (full_name, email, job_title, department_id, manager_id)
SELECT 'Casey Rivera', 'casey.rivera@example.test', 'Quality Engineer', d.department_id, m.employee_id
FROM departments d
JOIN employees m ON m.email = 'alex.morgan@example.test'
WHERE d.department_name = 'Engineering'
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name);

INSERT INTO employee_roles (employee_id, role_id)
SELECT e.employee_id, r.role_id
FROM employees e
JOIN roles r
  ON r.role_name = CASE
       WHEN e.email = 'alex.morgan@example.test' THEN 'MANAGER'
       ELSE 'EMPLOYEE'
     END
WHERE e.email IN ('alex.morgan@example.test', 'jordan.lee@example.test', 'casey.rivera@example.test')
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id);

INSERT INTO evaluations
    (employee_id, reviewer_id, cycle_id, evaluation_status, manager_summary, submitted_at)
SELECT employee.employee_id, reviewer.employee_id, cycle.cycle_id,
       'SUBMITTED', 'Strong delivery and clear collaboration in the sample review.',
       CURRENT_TIMESTAMP
FROM employees employee
JOIN employees reviewer ON reviewer.email = 'alex.morgan@example.test'
JOIN review_cycles cycle ON cycle.cycle_name = 'Q4 2026'
WHERE employee.email = 'jordan.lee@example.test'
ON DUPLICATE KEY UPDATE evaluation_status = VALUES(evaluation_status);

INSERT INTO evaluations
    (employee_id, reviewer_id, cycle_id, evaluation_status, manager_summary)
SELECT employee.employee_id, reviewer.employee_id, cycle.cycle_id,
       'IN_REVIEW', 'Draft sample review awaiting manager input.'
FROM employees employee
JOIN employees reviewer ON reviewer.email = 'alex.morgan@example.test'
JOIN review_cycles cycle ON cycle.cycle_name = 'Q4 2026'
WHERE employee.email = 'casey.rivera@example.test'
ON DUPLICATE KEY UPDATE evaluation_status = VALUES(evaluation_status);

INSERT INTO evaluation_scores (evaluation_id, competency_id, rating, evidence)
SELECT e.evaluation_id, c.competency_id, 4.00, 'Illustrative score for the demo dataset.'
FROM evaluations e
CROSS JOIN competencies c
JOIN employees employee ON employee.employee_id = e.employee_id
WHERE employee.email = 'jordan.lee@example.test'
ON DUPLICATE KEY UPDATE rating = VALUES(rating);

INSERT INTO goals (evaluation_id, goal_description, goal_status, due_date)
SELECT e.evaluation_id, 'Improve release handoff documentation', 'IN_PROGRESS', '2026-12-15'
FROM evaluations e
JOIN employees employee ON employee.employee_id = e.employee_id
JOIN review_cycles cycle ON cycle.cycle_id = e.cycle_id
WHERE employee.email = 'jordan.lee@example.test'
  AND cycle.cycle_name = 'Q4 2026'
  AND NOT EXISTS (SELECT 1 FROM goals g WHERE g.evaluation_id = e.evaluation_id);
