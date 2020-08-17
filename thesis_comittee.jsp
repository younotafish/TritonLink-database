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
                            "INSERT INTO Thesis_committee VALUES (?, ?, ?, ?, ?, ?, ?,?,?,?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("thesis_committee_id")));
                        pstmt.setString(2, request.getParameter("thesis_committee_type"));
                        pstmt.setString(3, request.getParameter("name_professor1"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("department_professor1")));
                        pstmt.setString(5, request.getParameter("name_professor2"));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("department_professor2")));
                        pstmt.setString(7, request.getParameter("name_professor3"));
                        pstmt.setInt(8, Integer.parseInt(request.getParameter("department_professor3")));
                        pstmt.setString(9, request.getParameter("name_professor4"));
                        pstmt.setInt(10, Integer.parseInt(request.getParameter("department_professor4")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                        out.println("successfully insert");
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
                        <th>thesis_committee_id</th>
                        <th>thesis_committee_type</th>
                        <th>name_professor1</th>
			            <th>department_professor1</th>
                        <th>name_professor2</th>
                        <th>department_professor2</th>
                        <th>name_professor3</th>
                        <th>department_professor3</th>
                        <th>name_professor4</th>
                        <th>department_professor4</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="thesis_comittee.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="e.g.0000001" name="thesis_committee_id" size="10"></th>
                            <th><select name = "thesis_committee_type">
                                <option value="master">master</option>
                                <option value="phd">phd</option>
                            </select>
                            </th>
                            <th><input value="e.g.Alin Bernard Deutsch" name="name_professor1" size="20"></th>
                            <th><input value="e.g.001" name="department_professor1" size="10"></th>
                            <th><input value="e.g.Joseph Pasquale" name="name_professor2" size="20"></th>
                            <th><input value="e.g.001" name="department_professor2" size="10"></th>
                            <th><input value="e.g.Paul Cao" name="name_professor3" size="20"></th>
                            <th><input value="e.g.001" name="department_professor3" size="10"></th>
                            <th><input value="e.g.Michael Thomas Tolley" name="name_professor4" size="20"></th>
                            <th><input value="e.g.002" name="department_professor4" size="10"></th>
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
