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
                Map<String, Double> gradeConvertMap = new HashMap<>();
                Map<String,String> quarterMap = new HashMap<>();
                quarterMap.put("01","SPRING");
                quarterMap.put("02","SUMMER");
                quarterMap.put("03","FALL");
                quarterMap.put("04","WINTER");
                gradeConvertMap.put("A+",4.0);
                gradeConvertMap.put("A",4.0);
                gradeConvertMap.put("A-",3.7);
                gradeConvertMap.put("B+",3.3);
                gradeConvertMap.put("B",3.0);
                gradeConvertMap.put("B-",2.7);
                gradeConvertMap.put("C+",2.3);
                gradeConvertMap.put("C",2.0);
                gradeConvertMap.put("C-",1.7);
                gradeConvertMap.put("D",1.0);
                gradeConvertMap.put("F",0.0);
                Double sumGpa = 0.0;

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
                            "SELECT c.course_title, p.course_name, p.unit, grade, p.grade_option,p.quarter_id FROM passClass p inner join courses c on p.course_name = c.course_name where student_id = ? GROUP BY quarter_id,c.course_title,p.course_name,p.unit,grade,p.grade_option order by quarter_id asc");

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
                    ResultSet rs = statement.executeQuery
                        ("SELECT DISTINCT s.student_id, s.first_name, s.middle_name, s.last_name FROM Student s, passClass p WHERE s.student_id = p.student_id");
            %>
            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Students</th>
                    </tr>
                    <tr>
                        <form action="gradeReportByStudent.jsp" method="get"> 
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
                          <th>Quarter</th>
                          <th>Year</th>
                          <th>Grade</th>
                          <th>Units</th>
                          <th>GPA</th>
                        </tr>
                        <%
                            int prevQ = 0;
                            int classNum = 0;
                            int totalClassNum = 0;
                            double tTGpa = 0.0;
	  	                    if (rs2 != null) {
	  		                    if (rs2.isBeforeFirst()) {
				                    while(rs2.next()) {
                                        int quarterID = rs2.getInt("quarter_id");
                                        String q_year = Integer.toString(quarterID);
                                        q_year = q_year.substring(0,4);
                                        String q_type = Integer.toString(quarterID);
                                        q_type = q_type.substring(4,6);
                                        q_type = quarterMap.get(q_type); 
                                        if (prevQ == 0) prevQ = quarterID;
                                        else if(prevQ != quarterID) {
                        %>
                        <tr>
                            <th>Quarter GPA:</th>
							<td><%= sumGpa/classNum%></td>
						</tr>
                        <%
                                            classNum = 0;
                                            sumGpa = 0.0;
                                            prevQ = quarterID;
                                        }
				        %>
		  			    <tr>
                            <td><%=rs2.getString("course_name") %></td>
                            <td><%=rs2.getString("course_title") %></td>
                            <td><%=q_type %></td>
                            <td><%=q_year %></td>
					        <td><%=rs2.getString("grade") %></td>
                            <td><%=rs2.getString("unit") %></td>
                            <% Double sgpa = gradeConvertMap.get(rs2.getString("grade")); %>
                            <td><%=sgpa %></td>
                            <% sumGpa += sgpa;
                            tTGpa += sgpa; 
                            classNum++;
                            totalClassNum++;%>
					    </tr>
						
				        <%
                                    }
                                    %>
                                    <tr>
                                        <th>Quarter GPA:</th>
                                        <td><%= sumGpa/classNum%></td>
                                    </tr>
                                    <%
			                    }	
	  	                    }
	                    %>
                    </table>

                    <table border="1">
                        <tr>
                            <th>Cumulative GPA: </th>
                            <td><%=tTGpa/totalClassNum %></td>
                        </tr>
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
