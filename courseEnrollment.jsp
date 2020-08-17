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
                    String enrollStatus = "enroll_Status";
                    if (action != null && action.equals("insert")) {
                        boolean exceedCapacity = false;
                        PreparedStatement prepstmt = conn.prepareStatement("select count(student_id) as num_enrolled from enrollment where section_id = ?");
                        PreparedStatement prepstmt2 = conn.prepareStatement("select enroll_number from section where section_id = ?");
                        prepstmt.setString(1,request.getParameter("section_id"));
                        ResultSet countResult = prepstmt.executeQuery();
                        prepstmt2.setString(1,request.getParameter("section_id"));
                        ResultSet courseCapacity = prepstmt2.executeQuery();
                        if(countResult != null && courseCapacity != null){
                            if (countResult.next() && courseCapacity.next()){
                                if(countResult.getInt("num_enrolled") >= courseCapacity.getInt("enroll_number")){
                                    exceedCapacity = true;
                                    enrollStatus = "sorry,_there_is_no_seat_left";
                                }

                            }
                        }
                        if(! exceedCapacity) {
                            // Begin transaction
                            conn.setAutoCommit(false);

                            // Create the prepared statement and use it to
                            // INSERT the student attributes INTO the Courses table.

                            PreparedStatement pstmt = conn.prepareStatement(
                                    "INSERT INTO Enrollment (student_id, section_id, status, unit, grade_option) VALUES (?, ?, ?, ?, ?)");

                            pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));
                            pstmt.setString(2, request.getParameter("section_id"));
                            pstmt.setString(3, request.getParameter("status"));
                            pstmt.setString(4, request.getParameter("unit"));
                            pstmt.setString(5, request.getParameter("grade_option"));

                            int rowCount = pstmt.executeUpdate();

                            // Commit transaction
                            conn.commit();
                            conn.setAutoCommit(true);
                            enrollStatus = "successfully enrolled";
                        }





                        //out.println("successfully inserted");
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%      

                    if (action != null && action.equals("search")) {

                        rs = statement.executeQuery
                        ("SELECT DISTINCT * FROM Section s, Quarter q, Quarter_courses qc, Courses c WHERE q.quarter_year = 2020 AND q.quarter_type = 'SPRING' AND q.quarter_id = qc.quarter_id AND qc.section_id = s.section_id AND c.course_name = '" + request.getParameter("course_search") + "' AND qc.course_name = '" + request.getParameter("course_search") + "'");
                    }

            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Enroll Status</th>
                        <th><input value=<%= enrollStatus %>  size="30"></th>
                    </tr>
                    <tr>
                        <form action="courseEnrollment.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <th><input value="" name="course_search" size="10"></th>
                            <th><input type="submit" value="Search"></th>
                        </form>
                    </tr>
                    <tr>
                        <th>Course Name</th>
                        <th>Section ID</th>
                        <th>Enrollment Limit</th>
                        <th>UNIT</th>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="courseEnrollment.jsp" method="get">
    
                            <%-- Get the ID --%>
                            <td>
                                <%= rs.getString("course_name") %>
                            </td>

                            <td>
                                <%= rs.getString("section_id") %>
                            </td>

                            <td>
                                <%= rs.getInt("enroll_number") %>
                            </td>

    
                            <td>
                                <%= rs.getString("course_units") %>
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
                        ("SELECT * FROM Enrollment e, Quarter_courses qc WHERE e.section_id = qc.section_id AND qc.course_name = '" + request.getParameter("course_search") + "'");
            %>

                <table border="1">

                    <tr>
                        <th>Student ID</th>
                        <th>Section ID</th>
                        <th>Enroll Status</th>
                        <th>UNIT</th>
                        <th>Grade Option</th>
                    </tr>
                    <tr>
                        <form action="courseEnrollment.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="student_id" size="10"></th>
                            <th><input value="" name="section_id" size="10"></th>
                            <th><input value="" name="status" size="10"></th>
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
                        <form action="courseEnrollment.jsp" method="get">
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs2.getInt("student_id") %>" 
                                    name="student_id" size="20">
                            </td>

                            <td>
                                <input value="<%= rs2.getString("section_id") %>" 
                                    name="section_id" size="20">
                            </td>

                            <%-- Get the COLLEGE --%>
                            <td>
                                <input value="<%= rs2.getString("status") %>" 
                                    name="status" size="20">
                            </td>

                            <td>
                                <input value="<%= rs2.getString("unit") %>" 
                                    name="unit" size="20">
                            </td>

                            <td>
                                <input value="<%= rs2.getString("grade_option") %>" 
                                    name="grade_option" size="20">
                            </td>
    
                            <%-- Button --%>
                        </form>
                    </tr>
            <%
                    }
            %>

                </table>
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
                
            </td>
        </tr>
    </table>
</body>

</html>
