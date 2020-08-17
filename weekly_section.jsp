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
                    String inputStatus = "";
                    if (action != null && action.equals("insert")) {
                        PreparedStatement prestml = conn.prepareStatement("select session_date, start_time from weekly_section where section_id = ?");
                        prestml.setString(1,request.getParameter("section_id"));
                        ResultSet rs = prestml.executeQuery();
                        boolean timeConflict = false;
                        String [] getSession_data = request.getParameter("session_date").split(",");
                        int newStartTime = Integer.parseInt(request.getParameter("start_time"));

                        here:
                        while (rs.next()){
                            String [] getOldSessionDate = rs.getString("session_date").split(",");
                            int oldStartTime = rs.getInt("start_time");
                            for (String s: getSession_data) {
                                for(String st : getOldSessionDate){
                                    if(s.equals(st) && oldStartTime == newStartTime){
                                        timeConflict = true;
                                        inputStatus = "time conflicted, please re enter";
                                        break here;
                                    }
                                }
                            }
                        }

                        if(! timeConflict){
                            // Begin transaction
                            conn.setAutoCommit(false);

                            // Create the prepared statement and use it to
                            // INSERT the student attributes INTO the Student table.
                            PreparedStatement pstmt = conn.prepareStatement(
                                    "INSERT INTO Weekly_section(session_type,session_date,start_time,session_place," +
                                            "mandatory,section_id) VALUES (?, ?,?,?,?,?)");

                            pstmt.setString(1, request.getParameter("session_type"));
                            pstmt.setString(2, request.getParameter("session_date"));
                            pstmt.setInt(3, Integer.parseInt(request.getParameter("start_time")));
                            pstmt.setString(4, request.getParameter("session_place"));
                            pstmt.setString(5, request.getParameter("mandatory"));
                            pstmt.setString(6, request.getParameter("section_id"));
                            int rowCount = pstmt.executeUpdate();

                            // Commit transaction
                            conn.commit();
                            conn.setAutoCommit(true);
                            System.out.println("successfully insert");
                            inputStatus = "input Successfully";
                        }

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
                        <th>InputStatus</th>
                        <th><input value="<%= inputStatus %>" name="InputStatus" size="30"></th>
                    </tr>
                    <tr>
                        <th>Session Type</th>
                        <th>Session Date</th>
                        <th>Start Time</th>
                        <th>Session Place</th>
                        <th>Whether Mandatory</th>
                        <th>Section ID</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="weekly_section.jsp" method="get">
                            <input type="hidden" value="insert" name="action">

                            <th><input value="" name="session_type" size="10"></th>
                            <th><input value="" name="session_date" size="10"></th>
                            <th><input value="" name="start_time" size="15"></th>
                            <th><input value="" name="session_place" size="15"></th>
                            <th><input value="" name="mandatory" size="15"></th>
                            <th><input value="" name="section_id" size="15"></th>
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
