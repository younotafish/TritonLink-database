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
                    String faculty_time_conflict = "";
                    if (action != null && action.equals("insert")) {
                        // Begin transaction
                        try {
                            conn.setAutoCommit(false);

                            // Create the prepared statement and use it to
                            // INSERT the student attributes INTO the Student table.
                            PreparedStatement pstmt = conn.prepareStatement(
                                    "INSERT INTO Faculty_section(name,section_id) VALUES (?, ?)");

                            pstmt.setString(1, request.getParameter("name"));
                            pstmt.setString(2, request.getParameter("section_id"));
                            int rowCount = pstmt.executeUpdate();

                            // Commit transaction
                            conn.commit();
                            conn.setAutoCommit(true);
                            faculty_time_conflict = "successfully matched";
                        }catch (SQLException sqlException){
                            out.println(sqlException.getMessage());
                            faculty_time_conflict = "sorry, faculty time conflicted";
                        }


                    }
            %>

<%--            &lt;%&ndash; -------- UPDATE Code -------- &ndash;%&gt;--%>
<%--            <%--%>
<%--                    // Check if an update is requested--%>
<%--                    if (action != null && action.equals("update")) {--%>

<%--                        // Begin transaction--%>
<%--                        conn.setAutoCommit(false);--%>
<%--                        --%>
<%--                        // Create the prepared statement and use it to--%>
<%--                        // UPDATE the student attributes in the Student table.--%>
<%--                        PreparedStatement pstmt = conn.prepareStatement(--%>
<%--                            "UPDATE Faculty SET name = ?, title = ?");--%>

<%--                        pstmt.setString(1, request.getParameter("name"));--%>
<%--                        pstmt.setString(2, request.getParameter("title"));--%>
<%--                        int rowCount = pstmt.executeUpdate();--%>

<%--                        // Commit transaction--%>
<%--                        conn.commit();--%>
<%--                        conn.setAutoCommit(true);--%>
<%--                    }--%>
<%--            %>--%>

<%--            &lt;%&ndash; -------- DELETE Code -------- &ndash;%&gt;--%>
<%--            <%--%>
<%--                    // Check if a delete is requested--%>
<%--                    if (action != null && action.equals("delete")) {--%>

<%--                        // Begin transaction--%>
<%--                        conn.setAutoCommit(false);--%>
<%--                        --%>
<%--                        // Create the prepared statement and use it to--%>
<%--                        // DELETE the student FROM the Student table.--%>
<%--                        PreparedStatement pstmt = conn.prepareStatement(--%>
<%--                            "DELETE FROM Faculty WHERE name = ?");--%>

<%--                        pstmt.setString(--%>
<%--                            1, request.getParameter("name"));--%>
<%--                        int rowCount = pstmt.executeUpdate();--%>

<%--                        // Commit transaction--%>
<%--                         conn.commit();--%>
<%--                        conn.setAutoCommit(true);--%>
<%--                    }--%>
<%--            %>--%>

<%--            &lt;%&ndash; -------- SELECT Statement Code -------- &ndash;%&gt;--%>
<%--            <%--%>
<%--                    // Create the statement--%>
<%--                    Statement statement = conn.createStatement();--%>

<%--                    // Use the created statement to SELECT--%>
<%--                    // the student attributes FROM the Student table.--%>
<%--                    ResultSet rs = statement.executeQuery--%>
<%--                        ("SELECT * FROM Faculty");--%>
<%--            %>--%>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr><th>Status</th>
                        <th><input value="<%= faculty_time_conflict%>" name="name" size="30"></th>
                    </tr>
                    <tr>
                        <th>faculty name</th>
                        <th>section id</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="faculty_section.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="e.g." name="name" size="20"></th>
                            <th><input value="e.g." name="section_id" size="20"></th>

                            </th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

<%--            &lt;%&ndash; -------- Iteration Code -------- &ndash;%&gt;--%>
<%--            <%--%>
<%--                    // Iterate over the ResultSet--%>
<%--        --%>
<%--                    while ( rs.next() ) {--%>
<%--        --%>
<%--            %>--%>

<%--                    <tr>--%>
<%--                        <form action="faculty.jsp" method="get">--%>
<%--                            <input type="hidden" value="update" name="action">--%>

<%--                            &lt;%&ndash; Get the name &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input value="<%= rs.getString("name") %>"--%>
<%--                                    name="name" size="10">--%>
<%--                            </td>--%>
<%--    --%>
<%--                            &lt;%&ndash; Get the title &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input value="<%= rs.getString("title") %>"--%>
<%--                                    name="title" size="10">--%>
<%--                            </td>--%>

<%--                            &lt;%&ndash; Button &ndash;%&gt;--%>
<%--                            <td>--%>
<%--                                <input type="submit" value="Update">--%>
<%--                            </td>--%>
<%--                        </form>--%>
<%--                        <form action="faculty.jsp" method="get">--%>
<%--                            <input type="hidden" value="delete" name="action">--%>
<%--                            <input type="hidden" --%>
<%--                                value="<%= rs.getString("name") %>" name="name">--%>
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
