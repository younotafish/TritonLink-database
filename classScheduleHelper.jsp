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
                    ResultSet rs3 = null;
                    int SID = 0;
                    if (action != null && action.equals("search")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Courses table.

                        PreparedStatement pstmt2 = conn.prepareStatement("with course_enrolled as (select session_date, start_time, q.course_name from section s2 inner join enrollment e on s2.section_id = e.section_id inner join weekly_section w on s2.section_id = w.section_id inner join quarter_courses q on s2.section_id = q.section_id where e.student_id= ?)select qc.course_name,c.course_title from section s inner join quarter_courses qc on s.section_id = qc.section_id inner join weekly_section ws on s.section_id = ws.section_id inner join courses c on qc.course_name = c.course_name where qc.quarter_id = 202001 and ws.session_date in (select session_date from course_enrolled) and ws.start_time in (select  start_time from course_enrolled) and s.section_id not in (select section_id from enrollment e where e.student_id = ?) and c.course_name not in (select ce.course_name from course_enrolled ce )group by qc.course_name, c.course_title HAVING count(qc.course_name) = (select count(qc2.section_id) from quarter_courses qc2 where qc2.course_name = qc.course_name and qc2.quarter_id = 202001)");
                        
                        SID = Integer.parseInt(request.getParameter("student_id"));
                        pstmt2.setInt(1, SID);
                        pstmt2.setInt(2, SID);

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

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery("select distinct s.student_id,s.first_name,s.middle_name,s.last_name from enrollment e inner join student s on e.student_id = s.student_id order by s.student_id");
            %>
            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Students</th>
                    </tr>
                    <tr>
                        <form action="classScheduleHelper.jsp" method="get"> 
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
                            <th>Courses cannot be taken are:</th>
                            <th>Conflicted with:</th>
                        </tr>
                        <tr>
                          <th>Course Name --- Course Title</th>
                          <th>Course Name --- Course Title</th>
                        </tr>
                        <%
	  	                    if (rs2 != null) {
	  		                    if (rs2.isBeforeFirst()) {
				                    while(rs2.next()) {
                                        //System.out.println("erre!");
                                        String courseNameIs = rs2.getString("course_name");

				        %>
				
		  			    <tr>
                            <td><%=rs2.getString("course_name") + " --- " + rs2.getString("course_title")%></td>
                                    <%
                                        PreparedStatement pstmt = conn.prepareStatement("select distinct c.course_name,c.course_title from enrollment e inner join weekly_section ws on e.section_id = ws.section_id inner join quarter_courses qc on e.section_id = qc.section_id inner join courses c on qc.course_name = c.course_name where e.student_id = ? and ws.start_time  in (select ws2.start_time from weekly_section ws2 inner join quarter_courses q on ws2.section_id = q.section_id where q.course_name = ?) and ws.session_date in (select ws3.session_date from weekly_section ws3 inner join quarter_courses qc2 on ws3.section_id = qc2.section_id where qc2.course_name = ?)");
                                        pstmt.setInt(1, SID);
                                        pstmt.setString(2, courseNameIs);
                                        pstmt.setString(3, courseNameIs);
                                        rs3 = pstmt.executeQuery();
                                        StringBuilder sb = new StringBuilder(); 
                                        while(rs3.next()) {
                                            sb.append(rs3.getString("course_name") + " --- " + rs3.getString("course_title") + ", ");
                                        }
                                        String res = sb.toString();
                                        if (res.length() == 0) res = "N/A Error happened!";
                                        else res = res.substring(0, res.length() - 2);
                                    %>
					        <td><%=res%></td>
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
                    if (rs3 != null) rs3.close();
    
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
