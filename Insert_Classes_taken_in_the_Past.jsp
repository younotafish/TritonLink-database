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
                            "insert into passclass (grade, student_id, quarter_id, course_name, unit, grade_option) VALUES (?, ?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("grade"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("student_id")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("quarter_id")));
                        pstmt.setString(4, request.getParameter("course_name"));
                        pstmt.setInt(5,Integer.parseInt(request.getParameter("unit")));
                        pstmt.setString(6,request.getParameter("grade_option"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                        out.println("successfully insert");


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
                        PreparedStatement pstmt2 = conn.prepareStatement(
                            "UPDATE passclass SET grade = ? WHERE student_id = ? AND quarter_id = ? AND course_name = ? AND unit = ? AND grade_option = ?");

                        pstmt2.setString(1, request.getParameter("grade"));
                        pstmt2.setInt(2, Integer.parseInt(request.getParameter("student_id")));
                        pstmt2.setInt(3, Integer.parseInt(request.getParameter("quarter_id")));
                        pstmt2.setString(4, request.getParameter("course_name"));
                        pstmt2.setInt(5,Integer.parseInt(request.getParameter("unit")));
                        pstmt2.setString(6,request.getParameter("grade_option"));

                        int rowCount = pstmt2.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>


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
                        <th>Unit</th>
                        <th>Grade Option</th>
                    </tr>
                    <tr>
                        <form action="Insert_Classes_taken_in_the_Past.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="student_id" size="10"></th>
                            <th><input value="" name="grade" size="10"></th>
                            <th><input value="" name="quarter_id" size="10"></th>
                            <th><input value="" name="course_name" size="10"></th>
                            <th><input value="" name="unit" size="10"></th>
                            <th><input value="" name="grade_option" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while ( rs2.next() ) {

                    %>

                    <tr>
                        <form action="Insert_Classes_taken_in_the_Past.jsp" method="get">
                            <input type="hidden" value="update" name="action">

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
                            <td>
                                <input value="<%= rs2.getString("unit") %>"
                                       name="unit" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString("grade_option") %>"
                                       name="grade_option" size="15">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                    </tr>
                    <%
                        }
                    %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                   if (rs2 != null) rs2.close();
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
