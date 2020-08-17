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

                        PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT DISTINCT first_name, middle_name, last_name, unit, grade_option FROM Student AS s INNER JOIN Enrollment AS e using (student_id) WHERE section_id = ?");

                        pstmt.setString(1, request.getParameter("section_id"));

                        rs2 = pstmt.executeQuery();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT DISTINCT * FROM Courses c, Quarter q, Quarter_courses qc WHERE c.course_name = qc.course_name AND qc.quarter_id = q.quarter_id");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Courses</th>
                    </tr>
                    <tr>
                        <form action="displayRosterClass.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <th>
                            <select name="section_id">
                                <%
                                        // Iterate over the ResultSet
                                        if (rs.isBeforeFirst()) {
                                            while ( rs.next() ) {
                            
                                %>
                                    <option value=<%=rs.getString("section_id")%>> <%=rs.getString("course_title")%> - <%=rs.getString("course_name")%> - <%=rs.getString("section_id")%> - <%=rs.getString("quarter_type")%> - <%=rs.getString("quarter_year")%></option>     
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
                          <th>Student First Name</th>
                          <th>Student Middle Name</th>
                          <th>Student Last Name</th>
                          <th>Grade Option Selected</th>
                          <th>Units</th>
                        </tr>

                        <%
	  	                    if (rs2 != null) {
	  		                    if (rs2.isBeforeFirst()) {
				                    while(rs2.next()) { 
				        %>
				
		  			    <tr>
                            <td><%=rs2.getString("first_name") %></td>
					        <td><%=rs2.getString("middle_name")==null? " " : rs2.getString("middle_name")%></td>
					        <td><%=rs2.getString("last_name") %></td>
                            <td><%=rs2.getString("grade_option") %></td>
                            <td><%=rs2.getString("unit") %></td>
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
