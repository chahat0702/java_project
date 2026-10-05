CREATE DATABASE IF NOT EXISTS employee_performance
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE employee_performance;

CREATE TABLE IF NOT EXISTS departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(140) NOT NULL,
    email VARCHAR(190) NOT NULL UNIQUE,
    job_title VARCHAR(120) NOT NULL,
    department_id BIGINT NOT NULL,
    manager_id BIGINT NULL,
    employment_status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id),
    CONSTRAINT fk_employee_manager
        FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE IF NOT EXISTS roles (
    role_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS employee_roles (
    employee_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (employee_id, role_id),
    CONSTRAINT fk_employee_roles_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_employee_roles_role
        FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE IF NOT EXISTS review_cycles (
    cycle_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cycle_name VARCHAR(80) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    cycle_status ENUM('PLANNED', 'ACTIVE', 'CLOSED') NOT NULL DEFAULT 'PLANNED',
    CONSTRAINT chk_review_cycle_dates CHECK (end_date >= start_date)
);

CREATE TABLE IF NOT EXISTS evaluations (
    evaluation_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_id BIGINT NOT NULL,
    reviewer_id BIGINT NOT NULL,
    cycle_id BIGINT NOT NULL,
    evaluation_status ENUM('DRAFT', 'IN_REVIEW', 'SUBMITTED', 'ACKNOWLEDGED')
        NOT NULL DEFAULT 'DRAFT',
    manager_summary TEXT NULL,
    employee_response TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    submitted_at TIMESTAMP NULL,
    CONSTRAINT uq_employee_cycle UNIQUE (employee_id, cycle_id),
    CONSTRAINT fk_evaluation_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_evaluation_reviewer
        FOREIGN KEY (reviewer_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_evaluation_cycle
        FOREIGN KEY (cycle_id) REFERENCES review_cycles(cycle_id)
);

CREATE TABLE IF NOT EXISTS competencies (
    competency_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    competency_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500) NOT NULL,
    weight_percent DECIMAL(5,2) NOT NULL DEFAULT 20.00,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_competency_weight
        CHECK (weight_percent > 0 AND weight_percent <= 100)
);

CREATE TABLE IF NOT EXISTS evaluation_scores (
    evaluation_id BIGINT NOT NULL,
    competency_id BIGINT NOT NULL,
    rating DECIMAL(3,2) NOT NULL,
    evidence TEXT NULL,
    PRIMARY KEY (evaluation_id, competency_id),
    CONSTRAINT chk_rating_range CHECK (rating >= 1.00 AND rating <= 5.00),
    CONSTRAINT fk_score_evaluation
        FOREIGN KEY (evaluation_id) REFERENCES evaluations(evaluation_id),
    CONSTRAINT fk_score_competency
        FOREIGN KEY (competency_id) REFERENCES competencies(competency_id)
);

CREATE TABLE IF NOT EXISTS goals (
    goal_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    evaluation_id BIGINT NOT NULL,
    goal_description VARCHAR(500) NOT NULL,
    goal_status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')
        NOT NULL DEFAULT 'NOT_STARTED',
    due_date DATE NULL,
    CONSTRAINT fk_goal_evaluation
        FOREIGN KEY (evaluation_id) REFERENCES evaluations(evaluation_id)
);
