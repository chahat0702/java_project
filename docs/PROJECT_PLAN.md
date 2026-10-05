# Project Review 1: Planning, Database, and UI

## Project goal

Provide a clear, consistent process for managers to evaluate employee outcomes, record competency evidence, and agree on follow-up goals. Employees should be able to review feedback and add a response.

## Users and first workflow

| User | Primary need |
| --- | --- |
| Administrator | Maintain employees, roles, and review cycles |
| Manager | Review assigned employees and record ratings with evidence |
| Employee | Read a completed evaluation and respond |

Initial flow:

1. An administrator creates a review cycle and maintains employee records.
2. A manager opens an evaluation for an employee in that cycle.
3. The manager rates each competency and records evidence and goals.
4. The manager submits the review.
5. The employee reads the result and acknowledges or responds.

## First review scope

The supplied prototype covers the dashboard's database read path and responsive layout. Authentication and review write workflows are planned next, so the prototype must use only the fictional local sample data.

## Architecture

~~~mermaid
flowchart LR
  Browser[Responsive browser UI]
  Servlet[DashboardServlet]
  Service[DashboardService]
  DAO[DashboardDao]
  JDBC[JDBC / PreparedStatement]
  DB[(MySQL)]
  Browser --> Servlet --> Service --> DAO --> JDBC --> DB
~~~

The servlet handles HTTP requests and forwards prepared view data to JSP. The DAO owns SQL and JDBC resource handling. The service coordinates the dashboard use case. JSP renders the response, while CSS handles responsive presentation.

## Data model

~~~mermaid
erDiagram
  DEPARTMENTS ||--o{ EMPLOYEES : groups
  EMPLOYEES o|--o{ EMPLOYEES : manages
  EMPLOYEES ||--o{ EMPLOYEE_ROLES : assigned
  ROLES ||--o{ EMPLOYEE_ROLES : grants
  EMPLOYEES ||--o{ EVALUATIONS : receives
  EMPLOYEES ||--o{ EVALUATIONS : reviews
  REVIEW_CYCLES ||--o{ EVALUATIONS : contains
  EVALUATIONS ||--o{ EVALUATION_SCORES : has
  COMPETENCIES ||--o{ EVALUATION_SCORES : measures
  EVALUATIONS ||--o{ GOALS : tracks
~~~

| Table | Purpose | Main integrity rule |
| --- | --- | --- |
| departments | Organization grouping | Department name is unique |
| employees | Employee profile and manager relationship | Email is unique; department is required |
| roles / employee_roles | Assign one or more access roles | Composite key prevents duplicate assignment |
| review_cycles | Evaluation period and status | End date cannot precede start date |
| evaluations | One employee review in one cycle | Unique employee-cycle pair |
| competencies | Shared rating dimensions and weights | Weight is between 0 and 100 |
| evaluation_scores | Rating and evidence by competency | Rating is between 1 and 5 |
| goals | Follow-up actions for an evaluation | Each goal belongs to an evaluation |

## JDBC path

DashboardServlet calls DashboardService, which calls DashboardDao. The DAO obtains a connection from DatabaseConnection, runs bounded SELECT queries with PreparedStatement, maps rows into model objects, and closes JDBC resources with try-with-resources. The servlet catches configuration and SQL failures and renders a useful connection message instead of exposing SQL details.

## UI and accessibility choices

- Desktop: persistent left navigation, page title, summary measures, and recent-evaluation table.
- Tablet: summary measures change from four columns to two.
- Mobile: navigation moves above the content, the summary remains two columns, and the table can scroll horizontally.
- Semantic headings and table headers give the page a clear reading order.
- A skip link, visible keyboard focus, readable contrast, and a status message support accessibility.
- CSS uses flexible widths and spacing so content remains usable at narrow viewports.

## Review checkpoint

- Project structure: present.
- Relational schema and fictional seed data: present.
- JDBC connection and dashboard SELECT path: present; local MySQL credentials are required to run it.
- Responsive dashboard design: present.
- Authentication, authorization, write flows, and production safeguards: planned, not implemented.
