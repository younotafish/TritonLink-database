<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql://localhost:5432/postgres";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));
                        pstmt.setString(2, request.getParameter("first_name"));
                        pstmt.setString(3, request.getParameter("last_name"));
                        pstmt.setString(4, request.getParameter("middle_name"));
                        pstmt.setString(5, request.getParameter("ssn"));
                        pstmt.setString(6, request.getParameter("residency"));
                        pstmt.setString(7, request.getParameter("enrolled"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Student SET ssn = ?, first_name = ?, " +
                            "middle_name = ?, last_name = ?, residency = ?, enrolled = ? WHERE student_id = ?");

                        pstmt.setString(1, request.getParameter("ssn"));
                        pstmt.setString(2, request.getParameter("first_name"));
                        pstmt.setString(3, request.getParameter("middle_name"));
                        pstmt.setString(4, request.getParameter("last_name"));
                        pstmt.setString(5, request.getParameter("residency"));
                        pstmt.setString(6, request.getParameter("enrolled"));
                        pstmt.setInt(
                            7, Integer.parseInt(request.getParameter("student_id")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Student WHERE student_id = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("student_id")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Student");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>SSN</th>
                        <th>ID</th>
                        <th>First</th>
			<th>Middle</th>
                        <th>Last</th>
                        <th>Residency</th>
                        <th>Enrolled</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="e.g.123-45-6789" name="ssn" size="20"></th>
                            <th><input value="e.g.53313783" name="student_id" size="20"></th>
                            <th><input value="" name="first_name" size="15"></th>
			    <th><input value="" name="middle_name" size="15"></th>
                            <th><input value="" name="last_name" size="15"></th>
                            <th><input value="" name="residency" size="15"></th>
                            <th><input value="" name="enrolled" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("ssn") %>" 
                                    name="ssn" size="20">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getInt("student_id") %>" 
                                    name="student_id" size="20">
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("first_name") %>"
                                    name="first_name" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("middle_name") %>" 
                                    name="middle_name" size="15">
                            </td>
    
			    <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("last_name") %>" 
                                    name="last_name" size="15">
                            </td>

                            <%-- Get the COLLEGE --%>
                            <td>
                                <input value="<%= rs.getString("residency") %>" 
                                    name="residency" size="15">
                            </td>

                            <td>
                                <input value="<%= rs.getString("enrolled") %>" 
                                    name="enrolled" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("student_id") %>" name="student_id">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
