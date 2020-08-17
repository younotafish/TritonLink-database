<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="./menu.html" />
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
                            "INSERT INTO Lab VALUES (?,?,?,?)");


                        PreparedStatement pstmt2 = conn.prepareStatement(
                            "INSERT INTO Course_lab (course_name, lab_name) VALUES (?, ?)");

                        pstmt.setString(1, request.getParameter("lab_name"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("lab_units")));
                        pstmt.setString(3, request.getParameter("grade_option"));

                        pstmt2.setString(1, request.getParameter("course_name"));
                        pstmt2.setString(2, request.getParameter("lab_name"));

                        int rowCount = pstmt.executeUpdate();
                        pstmt2.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                        out.println("successfully insert");
                    }
            %>

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
                <table border="1">
                    <tr>
                        <th>Course Name</th>
                        <th>Lab Name</th>
                        <th>Lab Units</th>
                        <th>Grade Option</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="lab.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="course_name" size="10"></th>
                            <th><input value="" name="lab_name" size="10"></th>
                            <th><input value="" name="lab_units" size="10"></th>
                            <th><input value="" name="grade_option" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

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
//                    // Close the ResultSet
//                    rs.close();
//
//                    // Close the Statement
//                    statement.close();
    
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
