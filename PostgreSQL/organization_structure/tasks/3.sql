WITH Subordinates AS (
    SELECT ManagerID, COUNT(*) AS TotalSubordinates
    FROM "Employees"
    GROUP BY ManagerID
),
EmployeeProjects AS (
    SELECT e.EmployeeID, string_agg(DISTINCT p.ProjectName, ', ') AS ProjectNames
    FROM "Employees" e
    LEFT JOIN "Tasks" t ON e.EmployeeID = t.AssignedTo
    LEFT JOIN "Projects" p ON t.ProjectID = p.ProjectID
    GROUP BY e.EmployeeID
),
EmployeeTasks AS (
    SELECT e.EmployeeID, string_agg(t.TaskName, ', ') AS TaskNames
    FROM "Employees" e
    LEFT JOIN "Tasks" t ON e.EmployeeID = t.AssignedTo
    GROUP BY e.EmployeeID
)
SELECT e.EmployeeID,
       e.Name AS EmployeeName,
       e.ManagerID,
       d.DepartmentName,
       r.RoleName,
       ep.ProjectNames,
       et.TaskNames,
       COALESCE(s.TotalSubordinates, 0) AS TotalSubordinates
FROM "Employees" e
JOIN "Departments" d ON e.DepartmentID = d.DepartmentID
JOIN "Roles" r ON e.RoleID = r.RoleID
LEFT JOIN Subordinates s ON e.EmployeeID = s.ManagerID
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
LEFT JOIN EmployeeTasks et ON e.EmployeeID = et.EmployeeID
WHERE r.RoleName = 'Менеджер'
  AND s.TotalSubordinates > 0
ORDER BY e.EmployeeID;