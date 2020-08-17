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
                            "INSERT INTO Section VALUES (?, ?)");

                        pstmt.setString(1, request.getParameter("section_id"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("enroll_number")));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                        out.println("successfully inserted");
                    }
            %>

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
            <%
                    // Create the statement
                  Statement statement = conn.createStatement();


                   ResultSet rs = statement.executeQuery
                       ("SELECT * FROM Section");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Section ID</th>
                        <th>Enroll number</th>>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="class.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="i.e.202001CSE100A00" name="section_id" size="20"></th>
                            <th><input value="i.e.70" name="enroll_number" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Section.jsp" method="get">
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <%= rs.getString("section_id") %>
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <%= rs.getInt("enroll_number") %>
                            </td>
    
                <%-- Get the LASTNAME --%>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
//                    // Close the ResultSet
                    rs.close();
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
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
