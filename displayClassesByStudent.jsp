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
                            "select distinct C.course_title,C.course_name,e.unit,e.grade_option,e.section_id from enrollment e inner join quarter_courses qc on e.section_id = qc.section_id inner join Courses C on qc.course_name = C.course_name where quarter_id=202001 and student_id = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));

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
                    ResultSet rs = statement.executeQuery("select distinct s.student_id,s.first_name,s.middle_name,s.last_name from enrollment e inner join student s on e.student_id = s.student_id");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Students</th>
                    </tr>
                    <tr>
                        <form action="displayClassesByStudent.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <th>
                            <select name="student_id">
                                <%
                                        // Iterate over the ResultSet
                                        if (rs.isBeforeFirst()) {
                                            while ( rs.next() ) {
                            
                                %>
                                    <option value=<%=rs.getInt("student_id")%>> <%=rs.getInt("student_id")%> - <%=rs.getString("first_name")%> <%=rs.getString("middle_name")==null? " " : rs.getString("middle_name")%> <%=rs.getString("last_name")%></option>     
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
                          <th>Course Number</th>
                          <th>Course Title</th>
                          <th>Grade Option Selected</th>
                          <th>Units</th>
                          <th>Section Id</th>
                        </tr>
                        <%
	  	                    if (rs2 != null) {
	  		                    if (rs2.isBeforeFirst()) {
				                    while(rs2.next()) { 
				        %>
				
		  			    <tr>
                            <td><%=rs2.getString("course_name") %></td>
					        <td><%=rs2.getString("course_title") %></td>
					        <td><%=rs2.getString("grade_option") %></td>
                            <td><%=rs2.getString("unit") %></td>
                            <td><%=rs2.getString("section_id") %></td>
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
