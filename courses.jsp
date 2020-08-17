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
                        // INSERT the student attributes INTO the Courses table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Courses VALUES (?, ?, ?, ?, ?)");

                        PreparedStatement pstmt2 = conn.prepareStatement(
                            "INSERT INTO Prerequisites (prerequisites_class_name, course_name) VALUES (?, ?)");

                        pstmt2.setString(1, request.getParameter("prerequisites_class_name"));
                        pstmt2.setString(2, request.getParameter("course_name"));

                        pstmt.setString(1, request.getParameter("course_name"));
                        pstmt.setString(2, request.getParameter("course_title"));
                        pstmt.setString(3, request.getParameter("course_units"));
                        pstmt.setString(4, request.getParameter("grade_option"));
                        pstmt.setString(5, request.getParameter("is_te"));

                        int rowCount = pstmt.executeUpdate();
                        pstmt2.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();
                    Statement statement2 = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Courses");
                    ResultSet rs2 = statement2.executeQuery
                        ("SELECT * FROM Prerequisites");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>NAME</th>
                        <th>TITLE</th>
                        <th>UNIT</th>
                        <th>GRADE OPTION</th>
                        <th>Technical Elective</th>
                        <th>Prerequisites Course(if none,N/A)</th>
                    </tr>
                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="e.g.CSE100" name="course_name" size="10"></th>
                            <th><input value="e.g.Description" name="course_title" size="10"></th>
                            <th><input value="e.g.4" name="course_units" size="15"></th>
                            <th><input value="e.g.letter or S/U" name="grade_option" size="20"></th>
                            <th><input value="e.g.Y/N" name="is_te" size="20"></th>
                            <th><input value="e.g.CSE8" name="prerequisites_class_name" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="courses.jsp" method="get">
    
                            <%-- Get the ID --%>
                            <td>
                                <%= rs.getString("course_name") %>
                            </td>
    
                            <td>
                                <%= rs.getString("course_title") %>
                            </td>

                            <td>
                                <%= rs.getString("course_units") %>
                            </td>

                            <td>
                                <%= rs.getString("grade_option") %>
                            </td>

                            <td>
                                <%= rs.getString("is_te") %>
                            </td>
                            <% if (rs2.next()) { 
                                 %>
                            <td>
                                <%= rs2.getString("prerequisites_class_name") %>
                            </td>
                            <% } else { %>
                            <td>
                                <%= "N/A"%>
                            </td>
                                <% } %>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
                    rs2.close();
    
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
