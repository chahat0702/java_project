# Employee Performance Evaluation System

An initial Java web prototype for a student project review. It demonstrates the project structure, relational data model, JDBC read path, and a responsive review dashboard.

## Current scope

- Java Servlet controller, service, DAO, model, JSP, and CSS layers.
- MySQL schema for employees, roles, review cycles, evaluations, competencies, scores, and goals.
- JDBC dashboard query using prepared statements and try-with-resources.
- Responsive dashboard layout with a clear database-connection error state.
- Fictional sample records for local demonstration.

This is an early review prototype. It does not yet implement sign-in, authorization, evaluation creation or editing, audit history, or production deployment controls. Performance data is sensitive; do not deploy this prototype with real employee records.

## Requirements

- JDK 17 or later
- Apache Maven 3.9 or later
- MySQL Server 8.0 or later
- Apache Tomcat 10.1.x

Tomcat 10.1 supports Jakarta Servlet 6.0 and requires Java 11 or later. This project compiles for Java 17. MySQL Connector/J is declared through Maven.

## Database setup

Create the database and tables, then load the fictional sample data:

~~~powershell
Get-Content .\database\schema.sql | mysql -u root -p
Get-Content .\database\sample-data.sql | mysql -u root -p
~~~

The sample SQL is intended for an empty local project database. It uses example.test addresses and fictional people.

## Configure the JDBC connection

Set environment variables in the same PowerShell window used to start Tomcat:

~~~powershell
$env:EPES_DB_URL = "jdbc:mysql://localhost:3306/employee_performance?serverTimezone=UTC"
$env:EPES_DB_USER = "epes_user"
$env:EPES_DB_PASSWORD = "your-local-database-password"
~~~

EPES_DB_URL defaults to the local URL shown above. EPES_DB_USER is required. The application does not store database credentials in source files.

## Build and run

Build the WAR:

~~~powershell
mvn clean package
~~~

Copy target\employee-performance-evaluation.war into the Tomcat webapps directory, start Tomcat, and open:

~~~text
http://localhost:8080/employee-performance-evaluation/dashboard
~~~

If the dashboard shows a database warning, confirm that MySQL is running, the schema and sample data are loaded, and the environment variables are set in the process that launched Tomcat.

## Project structure

~~~text
database/                         MySQL schema and fictional sample data
docs/                             Planning and review notes
src/main/java/edu/student/epes/
  config/                         JDBC connection configuration
  dao/                            SQL queries
  model/                          Dashboard data objects
  service/                        Use-case coordination
  web/                            Servlet request handling
src/main/webapp/
  WEB-INF/views/                  JSP views
  assets/css/                     Responsive visual styles
~~~

## Next development steps

1. Add login and role-based authorization for administrators, managers, and employees.
2. Add validated evaluation and goal forms with transactional JDBC writes.
3. Add employee self-review and manager feedback workflows.
4. Add audit events, input validation, and accessibility review.
5. Add automated tests after the workflows and acceptance criteria are agreed.

## Technology references

- [Maven standard directory layout](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html)
- [Apache Tomcat 10.1 migration guide](https://tomcat.apache.org/migration-10.1.html)
- [MySQL Connector/J Maven installation](https://dev.mysql.com/doc/connector-j/en/connector-j-installing-maven.html)
