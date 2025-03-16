WITH RECURSIVE EmployeeHierarchy AS (
    SELECT
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM "Employees" e
    WHERE e.EmployeeID = 1
    UNION ALL
    SELECT
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM "Employees" e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    STRING_AGG(DISTINCT p.ProjectName, ', ') AS ProjectNames,
    STRING_AGG(DISTINCT t.TaskName, ', ') AS TaskNames,
    COUNT(DISTINCT t.TaskID) AS TotalTasks,
    (SELECT COUNT(*)
     FROM "Employees" e2
     WHERE e2.ManagerID = e.EmployeeID) AS TotalSubordinates
FROM EmployeeHierarchy eh
JOIN "Employees" e ON eh.EmployeeID = e.EmployeeID
LEFT JOIN "Departments" d ON e.DepartmentID = d.DepartmentID
LEFT JOIN "Roles" r ON e.RoleID = r.RoleID
LEFT JOIN "Projects" p ON p.DepartmentID = e.DepartmentID
LEFT JOIN "Tasks" t ON t.AssignedTo = e.EmployeeID
GROUP BY
    e.EmployeeID,
    e.Name,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName
ORDER BY e.Name;