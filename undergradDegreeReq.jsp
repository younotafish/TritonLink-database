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
                Map<String, String> degreeMap = new HashMap<>();
                Set<String> courseSet = new HashSet<>();
                degreeMap.put("B.S. in Computer Science","1");
                degreeMap.put("B.A. in Philosophy","2");
                degreeMap.put("B.S. in Mechanical Engineering","3");
                degreeMap.put("M.S. in Computer Science","4");


                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql://localhost:5432/postgres";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>
            
            <%-- -------- Search Statement Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    String studentid = "";
                    // search action
                    ResultSet rs2 = null;
                    ResultSet rs4 = null;
                    ResultSet rs5 = null;
                    if (action != null && action.equals("search")) {

                        studentid = request.getParameter("student_id");
                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Courses table.

                        PreparedStatement pstmt2 = conn.prepareStatement("SELECT course_name from department_course dc inner join Department D on dc.department_id = D.department_id inner join Department_degree Dd on D.department_id = Dd.department_id inner join Degree_system Ds on Dd.degree_id = Ds.degree_id where Ds.degree_id=?");
                        pstmt2.setString(1, degreeMap.get(request.getParameter("degree_name").replaceAll("_", " ")));
                        rs4 = pstmt2.executeQuery();
                        if (rs4 != null) {
                            if (rs4.isBeforeFirst()) {
                                while ( rs4.next() ) {
                                    //System.out.println(rs4.getString("course_name"));
                                    courseSet.add(rs4.getString("course_name"));
                                }
                            }
                        }
                        rs4.close();

                        PreparedStatement pstmt = conn.prepareStatement(
                            "select distinct p.grade,p.grade_option,c.course_name,c.course_title,c.is_te, p.unit from passclass p inner join courses c on p.course_name = c.course_name where p.student_id = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));

                        rs2 = pstmt.executeQuery();

                        PreparedStatement pstmt5 = conn.prepareStatement(
                            "SELECT DISTINCT d.total_units,Ud.upper_units,Ld.lower_units,te.te_units FROM (degree_system d INNER JOIN Upper_division Ud on d.degree_id = Ud.degree_id INNER JOIN Lower_division Ld on d.degree_id = Ld.degree_id INNER JOIN technical_elective te on d.degree_id = te.degree_id) where d.degree_id = ?");

                        pstmt5.setString(1, degreeMap.get(request.getParameter("degree_name").replaceAll("_", " ")));

                        rs5 = pstmt5.executeQuery();

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
                    ResultSet rs = statement.executeQuery
                        ("select distinct S.student_id, S.first_name, S.middle_name,S.last_name FROM Student S inner join Enrollment E on s.student_id = E.student_id inner join undergraduate u on E.student_id = u.student_id order by S.student_id");
                    ResultSet rs3 = statement2.executeQuery
                        ("SELECT DISTINCT d.degree_name FROM degree_system d WHERE not d.degree_type = 'M.S.'");
            %>
            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Students</th>
                        <th>Degrees</th>
                    </tr>
                    <tr>
                        <form action="undergradDegreeReq.jsp" method="get"> 
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
                            <th>
                            <select name="degree_name">
                                <%
                                        // Iterate over the ResultSet
                                        if (rs3.isBeforeFirst()) {
                                            while ( rs3.next() ) {
                                                String degreeName = rs3.getString("degree_name").replaceAll(" ", "_");
                            
                                %>
                                    <option value=<%=degreeName%>> <%=rs3.getString("degree_name")%> </option>     
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
                        <%
                            int totalUnits = 0;
                            int upperUnits = 0;
                            int lowerUnits = 0;
                            int technicalUnits = 0;
                            if (rs5 != null) {
                                if (rs5.next()) {
                                    totalUnits = Integer.parseInt(rs5.getString("total_units"));
                                    upperUnits = Integer.parseInt(rs5.getString("upper_units"));
                                    lowerUnits = Integer.parseInt(rs5.getString("lower_units"));
                                    technicalUnits = Integer.parseInt(rs5.getString("te_units"));
                                }
                            }   
	  	                    if (rs2 != null) {
	  		                    if (rs2.isBeforeFirst()) {
				                    while(rs2.next()) {
                                        String courseName = rs2.getString("course_name");
                                        int courseUnit = Integer.parseInt(rs2.getString("unit"));
                                        String courseNameParse = courseName.replaceAll("[^\\d.]", "");
                                        int courseDivision = Integer.parseInt(courseNameParse);
                                        String isTechnical = rs2.getString("is_TE");
                                        //System.out.println(courseName);
                                        //System.out.println("have course in major: " + courseSet.contains(courseName));
                                        if (courseDivision >= 0 && courseDivision <= 99) {
                                            if (courseSet.contains(courseName)) lowerUnits -= courseUnit;
                                            if (isTechnical.equals("Y")) technicalUnits -= courseUnit;
                                        }
                                        else if (courseDivision >= 100 && courseDivision <= 199) {
                                            if (courseSet.contains(courseName)) upperUnits -= courseUnit;
                                            if (isTechnical.equals("Y")) technicalUnits -= courseUnit;
                                        } 
                                        else {System.out.println("Unknow division!");}
                                        //System.out.println("minus: " + courseUnit);
                                        totalUnits -= courseUnit;
                                    }
			                    }	
                            }
                            if (lowerUnits < 0) lowerUnits = 0;
                            if (upperUnits < 0) upperUnits = 0;
                            if (technicalUnits < 0) technicalUnits = 0;
                            if (totalUnits < 0) totalUnits = 0;
                            int unitToGraduate = totalUnits > (upperUnits+lowerUnits) ? totalUnits : (upperUnits+lowerUnits);
                            unitToGraduate = unitToGraduate > technicalUnits ? unitToGraduate : technicalUnits;
                        %>
                        
                        <tr>
                            <th>Student id</th>
                            <td><%=studentid%></td>
                            <th>Units need to graduate: </th>
                            <td><%= unitToGraduate%></td>
                        </tr>
                        <tr>
                          <th>Minmum Lower units to take: </th>
                          <td><%= lowerUnits%></td>
                          <th>Minmum Upper units to take: </th>
                          <td><%= upperUnits%></td>
                          <th>Minmum Technical units to take: </th>
                          <td><%= technicalUnits%></td>
                        </tr>
                    </table>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
                    if (rs2 != null) rs2.close();
                    if (rs3 != null) rs3.close();
                    if (rs5 != null) rs5.close();
     
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
