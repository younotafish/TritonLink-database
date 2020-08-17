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

                ResultSet rs = null;
                ResultSet rs2 = null;
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql://localhost:5432/postgres";
                    Connection conn = DriverManager.getConnection(dbURL);
                    Statement statement = conn.createStatement();

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
                            "INSERT INTO passClass(grade, student_id, quarter_id, course_name) VALUES (?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("grade"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("student_id")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("quarter_id")));
                        pstmt.setString(4, request.getParameter("course_name"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                        out.println("successfully insert");


                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%      

                    if (action != null && action.equals("search")) {

                        rs = statement.executeQuery
                        ("SELECT DISTINCT * FROM Section s, Quarter q, Quarter_courses qc, Courses c WHERE q.quarter_year = '"
                                + request.getParameter("year")
                                + "' AND q.quarter_type = '" + request.getParameter("quarter_type")
                                + "' AND q.quarter_id = qc.quarter_id AND qc.section_id = s.section_id AND c.course_name = '"
                                + request.getParameter("course_search")
                                + "' AND qc.course_name = '"
                                + request.getParameter("course_search")
                                +"'");
                    }

            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Course Name</th>
                        <th>Quarter (SPRING, WINTER, FALL, SUMMER)</th>
                        <th>Year</th>
                    </tr>
                    <tr>
                        <form action="Classes_taken_in_the_Past.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <th><input value="" name="course_search" size="10"></th>
                            <th><input value="" name="quarter_type" size="10"></th>
                            <th><input value="" name="year" size="10"></th>
                            <th><input type="submit" value="Search"></th>
                        </form>
                    </tr>
                    <tr>
                        <th>Section list:</th>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Classes_taken_in_the_Past.jsp" method="get">
    
                            <%-- Get the ID --%>
                            <td>
                                <%= rs.getString("section_id") %>
                            </td>
                            <%-- Button --%>
                        </form>
                    </tr>
            <%
                }
            %>
                </table>

            <%
                    // Create the statement

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    rs2 = statement.executeQuery
                        ("SELECT * FROM passClass order by student_id");
            %>

                <table border="1">
                    <tr>
                        <th>Student ID</th>
                        <th>Grade</th>
                        <th>Quarter ID</th>
                        <th>Course_name</th>
                    </tr>
                    <tr>
                        <form action="Classes_taken_in_the_Past.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="student_id" size="10"></th>
                            <th><input value="" name="grade" size="10"></th>
                            <th><input value="" name="quarter_id" size="10"></th>
                            <th><input value="" name="course_name" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
             <%
                    // Iterate over the ResultSet
                    while ( rs2.next() ) {
        
            %>

                    <tr>
                        <form action="Classes_taken_in_the_Past.jsp" method="get">
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs2.getInt("student_id") %>" 
                                    name="student_id" size="15">
                            </td>

                            <td>
                                <input value="<%= rs2.getString("grade") %>" 
                                    name="grade" size="15">
                            </td>

                            <%-- Get the COLLEGE --%>
                            <td>
                                <input value="<%= rs2.getInt("quarter_id") %>" 
                                    name="quarter_id" size="15">
                            </td>

                            <td>
                                <input value="<%= rs2.getString("course_name") %>" 
                                    name="course_name" size="15">
                            </td>
    
                            <%-- Button --%>
                        </form>
                    </tr>
            <%
                    }
            %>

                </table>
            <%-- -------- UPDATE Code -------- --%>
<%--            <%--%>
<%--                    // Check if an update is requested--%>
<%--                    if (action != null && action.equals("update")) {--%>

<%--                        // Begin transaction--%>
<%--                        conn.setAutoCommit(false);--%>
<%--                        --%>
<%--                        // Create the prepared statement and use it to--%>
<%--                        // UPDATE the student attributes in the Student table.--%>
<%--                        PreparedStatement pstmt = conn.prepareStatement(--%>
<%--                            "UPDATE Student SET ssn = ?, first_name = ?, " +--%>
<%--                            "middle_name = ?, last_name = ?, residency = ?, enrolled = ? WHERE student_id = ?");--%>

<%--                        pstmt.setString(1, request.getParameter("ssn"));--%>
<%--                        pstmt.setString(2, request.getParameter("first_name"));--%>
<%--                        pstmt.setString(3, request.getParameter("middle_name"));--%>
<%--                        pstmt.setString(4, request.getParameter("last_name"));--%>
<%--                        pstmt.setString(5, request.getParameter("residency"));--%>
<%--                        pstmt.setString(6, request.getParameter("enrolled"));--%>
<%--                        pstmt.setInt(--%>
<%--                            7, Integer.parseInt(request.getParameter("student_id")));--%>
<%--                        int rowCount = pstmt.executeUpdate();--%>

<%--                        // Commit transaction--%>
<%--                        conn.commit();--%>
<%--                        conn.setAutoCommit(true);--%>
<%--                    }--%>
<%--            %>--%>

            <%-- -------- DELETE Code -------- --%>
<%--            <%--%>
<%--                    // Check if a delete is requested--%>
<%--                    if (action != null && action.equals("delete")) {--%>

<%--                        // Begin transaction--%>
<%--                        conn.setAutoCommit(false);--%>
<%--                        --%>
<%--                        // Create the prepared statement and use it to--%>
<%--                        // DELETE the student FROM the Student table.--%>
<%--                        PreparedStatement pstmt = conn.prepareStatement(--%>
<%--                            "DELETE FROM Student WHERE student_id = ?");--%>

<%--                        pstmt.setInt(--%>
<%--                            1, Integer.parseInt(request.getParameter("student_id")));--%>
<%--                        int rowCount = pstmt.executeUpdate();--%>

<%--                        // Commit transaction--%>
<%--                         conn.commit();--%>
<%--                        conn.setAutoCommit(true);--%>
<%--                    }--%>
<%--            %>--%>

            <%-- -------- SELECT Statement Code -------- --%>
<%--            <%--%>
<%--                    // Create the statement--%>
<%--                    Statement statement = conn.createStatement();--%>

<%--                    // Use the created statement to SELECT--%>
<%--                    // the student attributes FROM the Student table.--%>
<%--                    ResultSet rs = statement.executeQuery--%>
<%--                        ("SELECT * FROM Student");--%>
<%--            %>--%>

            <!-- Add an HTML table header row to format the results -->
            

            <%-- -------- Iteration Code -------- --%>
<%--            <%--%>
<%--                    // Iterate over the ResultSet--%>
<%--        --%>
<%--                    while ( rs.next() ) {--%>
<%--        --%>
<%--            %>--%>

<%--                    <tr>--%>
<%--                        <form action="students.jsp" method="get">--%>
<%--                            <input type="hidden" value="update" name="action">--%>

<%--                            &lt;%&ndash; Get the SSN, which is a number &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input value="<%= rs.getString("ssn") %>" --%>
<%--                                    name="ssn" size="10">--%>
<%--                            </td>--%>
<%--    --%>
<%--                            &lt;%&ndash; Get the ID &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input value="<%= rs.getString("student_id") %>" --%>
<%--                                    name="student_id" size="10">--%>
<%--                            </td>--%>
<%--    --%>
<%--                            &lt;%&ndash; Get the FIRSTNAME &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input value="<%= rs.getString("first_name") %>"--%>
<%--                                    name="first_name" size="15">--%>
<%--                            </td>--%>
<%--    --%>
<%--                            &lt;%&ndash; Get the LASTNAME &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input value="<%= rs.getString("middle_name") %>" --%>
<%--                                    name="middle_name" size="15">--%>
<%--                            </td>--%>
<%--    --%>
<%--			    &lt;%&ndash; Get the LASTNAME &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input value="<%= rs.getString("last_name") %>" --%>
<%--                                    name="last_name" size="15">--%>
<%--                            </td>--%>

<%--                            &lt;%&ndash; Get the COLLEGE &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input value="<%= rs.getString("residency") %>" --%>
<%--                                    name="residency" size="15">--%>
<%--                            </td>--%>

<%--                            <td>--%>
<%--                                <input value="<%= rs.getString("enrolled") %>" --%>
<%--                                    name="enrolled" size="15">--%>
<%--                            </td>--%>
<%--    --%>
<%--                            &lt;%&ndash; Button &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input type="submit" value="Update">--%>
<%--                            </td>--%>
<%--                        </form>--%>
<%--                        <form action="students.jsp" method="get">--%>
<%--                            <input type="hidden" value="delete" name="action">--%>
<%--                            <input type="hidden" --%>
<%--                                value="<%= rs.getInt("student_id") %>" name="student_id">--%>
<%--                            &lt;%&ndash; Button &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input type="submit" value="Delete">--%>
<%--                            </td>--%>
<%--                        </form>--%>
<%--                    </tr>--%>
<%--            <%--%>
<%--                    }--%>
<%--            %>--%>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                   rs.close();
                   rs2.close();
//
//                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
            </td>
        </tr>
    </table>
</body>

</html>
