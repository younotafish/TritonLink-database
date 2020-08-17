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
                    if (action != null && action.equals("search")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Courses table.

                        PreparedStatement pstmt2 = conn.prepareStatement("select count(case when (p.grade LIKE 'A+') then 1 end ) as num_A_plus, count(case when (p.grade LIKE 'A') then 1 end ) as num_A, count(case when (p.grade LIKE 'A-') then 1 end ) as num_A_minus, count(case when (p.grade LIKE 'B+') then 1 end ) as num_B_plus, count(case when (p.grade LIKE 'B') then 1 end ) as num_B, count(case when (p.grade LIKE 'B-') then 1 end ) as num_B_minus, count(case when (p.grade LIKE 'C+') then 1 end ) as num_C_plus, count(case when (p.grade LIKE 'C') then 1 end ) as num_C, count(case when (p.grade LIKE 'C-') then 1 end ) as num_C_minus, count(case when (p.grade LIKE 'D') then 1 end ) as num_D, count(case when (p.grade LIKE 'F%') then 1 end ) as num_others from faculty_section fs inner join quarter_courses qc on fs.section_id = qc.section_id inner join passclass p on qc.course_name = p.course_name and p.quarter_id = qc.quarter_id where fs.name = ? and qc.course_name = ?");
                        
                        pstmt2.setString(1, request.getParameter("name").replaceAll("_", " "));
                        pstmt2.setString(2, request.getParameter("course_name"));

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
                        <form action="DecisionSupportD.jsp" method="get"> 
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
                                        int numAA = rs2.getInt("num_A_plus");
                                        int numA = rs2.getInt("num_A");
                                        int numAa = rs2.getInt("num_A_minus");

                                        int numBB = rs2.getInt("num_B_plus");
                                        int numB = rs2.getInt("num_B");
                                        int numBb = rs2.getInt("num_B_minus");

                                        int numCC = rs2.getInt("num_C_plus");
                                        int numC = rs2.getInt("num_C");
                                        int numCc = rs2.getInt("num_C_minus");
                                        
                                        int numD = rs2.getInt("num_D");
                                        int numF = rs2.getInt("num_others");

                                        double gpaNumAA = gradeConvertMap.get("A+") * numAA;
                                        double gpaNumA = gradeConvertMap.get("A") * numA;
                                        double gpaNumAa = gradeConvertMap.get("A-") * numAa;

                                        double gpaNumBB = gradeConvertMap.get("B+") * numBB;
                                        double gpaNumB = gradeConvertMap.get("B") * numB;
                                        double gpaNumBb = gradeConvertMap.get("B-") * numBb;

                                        double gpaNumCC = gradeConvertMap.get("C+") * numCC;
                                        double gpaNumC = gradeConvertMap.get("C") * numC;
                                        double gpaNumCc = gradeConvertMap.get("C-") * numCc;
                                        
                                        double gpaNumD = gradeConvertMap.get("D") * numD;
                                        double gpaNumF = gradeConvertMap.get("F") * numF;

                                        double totalGPA = gpaNumAA + gpaNumA + gpaNumAa + gpaNumBB + gpaNumB + gpaNumBb + gpaNumCC + gpaNumC + gpaNumCc + gpaNumD + gpaNumF;
                                        
                                        int totalNum = numAA + numA + numAa + numBB + numB + numBb + numCC + numC + numCc + numD + numF;

                                        float res = (float) totalGPA / totalNum;
                                    %>
                                        <tr><td>GPA for this course by this professor is: <%=res%></td></tr>
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