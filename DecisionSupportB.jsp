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
            <%@ page language="java" import="java.sql.*, java.util.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql://localhost:5432/postgres";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>
            
            <%-- -------- Search Statement Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // search action
                    ResultSet rs2 = null;
                    if (action != null && action.equals("search")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Courses table.

                        PreparedStatement pstmt2 = conn.prepareStatement("select grade, num_grade from cpg where course_name = ? and  faculty_name = ? order by grade");
                        
                        pstmt2.setString(2, request.getParameter("name").replaceAll("_", " "));
                        pstmt2.setString(1, request.getParameter("course_name"));

                        rs2 = pstmt2.executeQuery();

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
                    ResultSet rs = statement.executeQuery("select distinct name from faculty_section");
                    ResultSet rs3 = statement2.executeQuery("select distinct c.course_name from passclass p inner join courses c on p.course_name = c.course_name");
            %>
            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Professors</th>
                        <th>Courses</th>
                    </tr>
                    <tr>
                        <form action="DecisionSupportB.jsp" method="get"> 
                            <input type="hidden" value="search" name="action">
                            <th>
                            <select name="name">
                                <%
                                        // Iterate over the ResultSet
                                        if (rs.isBeforeFirst()) {
                                            while ( rs.next() ) {
                                                String profname = rs.getString("name").replaceAll(" ", "_");
                            
                                %>
                                    <option value=<%=profname%>> <%=rs.getString("name")%></option>     
                                <%
                                            }
                                        }
                                %>
                            </select>
                            </th>

                            <th>
                            <select name="course_name">
                                <%
                                        // Iterate over the ResultSet
                                        if (rs3.isBeforeFirst()) {
                                            while ( rs3.next() ) {
                            
                                %>
                                    <option value=<%=rs3.getString("course_name")%>><%=rs3.getString("course_name")%></option>     
                                <%
                                            }
                                        }
                                %>
                            </select>
                            </th>
                            
                            <th><input type="submit" value="Search"></th>
                        </form>
                    </tr>


                    <table border="1">
                        <tr>
                            <th>Grade distribution</th>
                        </tr>
                        <%
                            if (rs2 != null) {
                                if (rs2.isBeforeFirst()) {
                                    while(rs2.next()) {
                                    %>
                                        <tr>
                                            <td>Grade: <%=rs2.getString("grade")%></td>
                                            <td>Number: <%=rs2.getInt("num_grade")%></td>
                                        </tr>
                                    <%
                                    }
                                }
                            }
                        %>
                    </table>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
                    rs3.close();
                    if (rs2 != null) rs2.close();
    
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