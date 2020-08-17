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
                            "INSERT INTO Review_section(review_session_date,start_time,session_place,section_id) VALUES (?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("review_session_date"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("start_time")));
                        pstmt.setString(3, request.getParameter("session_place"));
                        pstmt.setString(4, request.getParameter("section_id"));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                        out.println("successfully insert");
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                  Statement statement = conn.createStatement();


                   ResultSet rs = statement.executeQuery
                       ("SELECT * FROM Review_section");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Review Session Date</th>
                        <th>Start Time</th>
                        <th>Session Place</th>
                        <th>section ID</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="review_section.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="review_session_date" size="10"></th>
                            <th><input value="" name="start_time" size="15"></th>
                            <th><input value="" name="session_place" size="15"></th>
                            <th><input value="" name="section_id" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="review_section.jsp" method="get">
                            <td>
                                <%= rs.getString("review_session_date") %>
                            </td>

                            <td>
                                <%= rs.getInt("start_time") %>
                            </td>

                            <td>
                                <%= rs.getString("session_place") %>
                            </td>

                            <td>
                                <%= rs.getString("section_id") %>
                            </td>
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
