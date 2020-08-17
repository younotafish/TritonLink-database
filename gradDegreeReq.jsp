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
                class UnitAndGrade {
                    int x;
                    double y;
                    public UnitAndGrade(int x, double y) {
                        this.x = x;
                        this.y = y;
                    }
                }

                Map<String,String> quarterMap = new HashMap<>();
                quarterMap.put("01","SPRING");
                quarterMap.put("02","SUMMER");
                quarterMap.put("03","FALL");
                quarterMap.put("04","WINTER");

                Map<String, HashSet<String>> classTaken = new HashMap<>();
                Map<String, UnitAndGrade> classInfo = new HashMap<>();
                Map<String, List<String>> classForm = new HashMap<>(); 

                Map<String, List<String>> concentrationMap = new HashMap<>();

                Map<String, String> degreeMap = new HashMap<>();
                degreeMap.put("M.S. in Computer Science","4");

                Map<String, Double> gradeConvertMap = new HashMap<>();
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
                    ResultSet rs4 = null;
                    ResultSet rs5 = null;
                    if (action != null && action.equals("search")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Courses table.

                        PreparedStatement pstmt2 = conn.prepareStatement("SELECT c.concentration_id as concentration_name, c.concentrate_course_name, c.gpa_require, c.min_unit FROM Concentration c inner join degree_system d using(degree_id) WHERE d.degree_id=?");
                        pstmt2.setString(1, degreeMap.get(request.getParameter("degree_name").replaceAll("_", " ")));

                        rs4 = pstmt2.executeQuery();

                        if (rs4 != null) {

                            if (rs4.isBeforeFirst()) {

                                while ( rs4.next() ) {
                                    List<String> tempList = new ArrayList<>();
                                    tempList.add(rs4.getString("concentrate_course_name"));
                                    tempList.add(String.valueOf(rs4.getFloat("gpa_require")));
                                    tempList.add(String.valueOf(rs4.getInt("min_unit")));



                                    concentrationMap.put(rs4.getString("concentration_name"), tempList);
                                }
                            }
                        }
                        rs4.close();


                        PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT distinct p.course_name,p.unit,p.grade,p.grade_option FROM passclass p INNER JOIN courses c on p.course_name = c.course_name where p.student_id = ?");

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
                    Statement statement2 = conn.createStatement();
                    //Statement s3 = conn.createStatement();

                   /* rs5 = s3.executeQuery
                        ("select min(quarter_id) as next_time from quarter_courses where course_name = ? and quarter_id > 202001"); */

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT distinct s.student_id,s.first_name,s.middle_name,s.last_name FROM graduate g inner join student s on g.student_id = s.student_id");
                    ResultSet rs3 = statement2.executeQuery
                        ("SELECT DISTINCT d.degree_name FROM degree_system d WHERE d.degree_type = 'M.S.'");
            %>
            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Students</th>
                        <th>Degrees</th>
                    </tr>
                    <tr>
                        <form action="gradDegreeReq.jsp" method="get"> 
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
	  	                    if (rs2 != null) {
	  		                    if (rs2.isBeforeFirst()) {
                                    
                                    for (String conName : concentrationMap.keySet()) {
                                        String tempDataCourse = (String) concentrationMap.get(conName).get(0);
                                        List<String> conCourseList = new ArrayList<>(Arrays.asList(tempDataCourse.split("\\s*(\\s|=>|,)\\s*")));
                                        classForm.put(conName, conCourseList);
                                    }
				                    while(rs2.next()) {
                                        String decisionCourse = rs2.getString("course_name");
                                        Double sgpa = gradeConvertMap.get(rs2.getString("grade"));
                                        int sUnit = rs2.getInt("unit");
                                    
                                        for (String conName : concentrationMap.keySet()) {
                                            String tempDataCourse = (String) concentrationMap.get(conName).get(0);
                                            List<String> conCourseList = new ArrayList<>(Arrays.asList(tempDataCourse.split("\\s*(\\s|=>|,)\\s*")));
                                            //classForm.put(conName, conCourseList);
                                            if (conCourseList.contains(decisionCourse)) {
                                                HashSet<String> tempHashSet = classTaken.get(conName);
                                                if (tempHashSet == null) tempHashSet = new HashSet<>();
                                                tempHashSet.add(decisionCourse);
                                                classTaken.put(conName, tempHashSet);
                                                classInfo.put(decisionCourse, new UnitAndGrade(sUnit,sgpa));
                                                break;
                                            }
                                        }
                                    }

                                    for (String cN : concentrationMap.keySet()) {
                                        String tempDataCourse = (String) concentrationMap.get(cN).get(0);
                                        double tempDataCourseGPA = Double.parseDouble(concentrationMap.get(cN).get(1));
                                        int tempDataCourseUnit = Integer.parseInt(concentrationMap.get(cN).get(2));
                                        List<String> conCourseList = new ArrayList<>(Arrays.asList(tempDataCourse.split("\\s*(\\s|=>|,)\\s*")));
                                        int conCourseListSize = conCourseList.size();
                                        if (classTaken.containsKey(cN)) {
                                            HashSet<String> classInfoSet = classTaken.get(cN);

                                        if (!classInfoSet.isEmpty()) {
                                            double studentGPA = 0.0;
                                            for (String tempclassInfo : classInfoSet) {
                                                studentGPA += classInfo.get(tempclassInfo).y;
                                            }
                                            studentGPA /= classInfoSet.size();
                                            System.out.println("here should be 3.7: " + studentGPA);
                                            
                                            for (String c : conCourseList) {
                                                if (classInfo.containsKey(c)) {
                                                    if (classInfo.get(c).x < tempDataCourseUnit/conCourseListSize) continue;
                                                    if (studentGPA < tempDataCourseGPA) {
                                                        if (classInfo.get(c).y < tempDataCourseGPA) continue;
                                                    }
                                                    if (classForm.containsKey(cN)) {
                                                        classForm.get(cN).remove(c);
                                                    }
                                                }
                                            }
                                        }
                                        }
                                    }

                                    StringBuilder sb = new StringBuilder(); 
                                    for (String conName : concentrationMap.keySet()) {
                                        if (classForm.containsKey(conName)) {
                                            if (classForm.get(conName).isEmpty()) {
                                                sb.append(conName+", ");
                                            }
                                        }
                                    }
                                    String resCHC = sb.toString();
                                    if (resCHC.length() == 0) resCHC = "N/A";
                                    else resCHC = resCHC.substring(0, resCHC.length() - 2);

                        %>
                                    <tr>
                                        <th>Concentrations has completed: </th>
                                        <td><%=resCHC%></td>
                                    </tr>

                                    <tr>
                                        <th>Concentrations' course has not yet taken: </th>
                                        <th>next available course in: </th>
                                        <%
                                            for (String conName : concentrationMap.keySet()) {
                                                if (classForm.containsKey(conName)) {
                                                    if (!classForm.get(conName).isEmpty()) {
                                                        Iterator i = classForm.get(conName).iterator();
                                                        while(i.hasNext()) { 
                                                            String res = (String) i.next(); 
                                                            PreparedStatement pstmt5 = conn.prepareStatement("select min(quarter_id) as next_time from quarter_courses where course_name = ? and quarter_id > 202001");
                                                            pstmt5.setString(1, res);
                                                            rs5 = pstmt5.executeQuery();
                                                            rs5.next();
                                                            String yearY = Integer.toString(rs5.getInt("next_time")).substring(0,4);
                                                            String quarterT = quarterMap.get(Integer.toString(rs5.getInt("next_time")).substring(4,6));

                                        %> 
                                        <tr><td><%=conName + " - " + res%></td><td><%=quarterT + " " + yearY%></td></tr>                
                                        <%
                                                        }
                                                    }
                                                }
                                            } 
                                        %>
                                    </tr>

                        <%
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
