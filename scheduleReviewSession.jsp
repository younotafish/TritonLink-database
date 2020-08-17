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
            <%@ page language="java" import="java.sql.*, java.util.*, java.text.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                
                Map<String, String> monthMap = new HashMap<>();
                monthMap.put("1", "January");
                monthMap.put("2", "February");
                monthMap.put("3", "March");
                monthMap.put("4", "April");
                monthMap.put("5", "May");
                monthMap.put("6", "June");
                monthMap.put("7", "July");
                monthMap.put("8", "August");
                monthMap.put("9", "September");
                monthMap.put("10", "October");
                monthMap.put("11", "November");
                monthMap.put("12", "December");

                Map<String, String> dateMap = new HashMap<>();
                dateMap.put("M", "Monday");
                dateMap.put("Tue", "Tuesday");
                dateMap.put("W", "Wednesday");
                dateMap.put("Thu", "Thursday");
                dateMap.put("F", "Friday");

                Map<String, Integer> howManyDays = new HashMap<>();
                howManyDays.put("1", 31);
                howManyDays.put("2", 29);
                howManyDays.put("3", 31);
                howManyDays.put("4", 30);
                howManyDays.put("5", 31);
                howManyDays.put("6", 30);
                howManyDays.put("7", 31);
                howManyDays.put("8", 31);
                howManyDays.put("9", 30);
                howManyDays.put("10", 31);
                howManyDays.put("11", 30);
                howManyDays.put("12", 31);


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
                    String SID = "";
                    if (action != null && action.equals("search")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Courses table.

                        PreparedStatement pstmt2 = conn.prepareStatement("select distinct ws.session_date,ws.start_time,ws.section_id,ws.session_type from enrollment e inner join weekly_section ws on e.section_id = ws.section_id where e.section_id in (select e1.section_id from enrollment e1 where e1.student_id in(select e3.student_id from enrollment e3 where e3.section_id = ? )) except select distinct w.session_date,w.start_time,w.section_id,w.session_type from enrollment e inner join weekly_section w on e.section_id = w.section_id where e.section_id = ?");
                        
                        SID = request.getParameter("section_id");
                        pstmt2.setString(1, SID);
                        pstmt2.setString(2, SID);

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
                    ResultSet rs = statement.executeQuery("select distinct f.name, fs.section_id, qc.course_name from Faculty f inner join Faculty_section fs on f.name = fs.name inner join Quarter_courses qc on qc.section_id = fs.section_id and qc.quarter_id = '202001' order by qc.course_name");
            %>
            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Professor --- Section --- Course</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                    </tr>
                    <tr>
                        <form action="scheduleReviewSession.jsp" method="get"> 
                            <input type="hidden" value="search" name="action">
                            <th>
                            <select name="section_id">
                                <%
                                        // Iterate over the ResultSet
                                        if (rs.isBeforeFirst()) {
                                            while ( rs.next() ) {
                            
                                %>
                                    <option value=<%=rs.getString("section_id")%>> <%=rs.getString("name")%> --- <%=rs.getString("section_id")%> --- <%=rs.getString("course_name")%></option>     
                                <%
                                            }
                                        }
                                %>
                            </select>
                            </th>
                            <th>
                                <select name="smonth">
                                    <option value="1">January</option>
                                    <option value="2">February</option>
                                    <option value="3">March</option>
                                    <option value="4">April</option>
                                    <option value="5">May</option>
                                    <option value="6">June</option>
                                    <option value="7">July</option>
                                    <option value="8">August</option>
                                    <option value="9">September</option>
                                    <option value="10">October</option>
                                    <option value="11">November</option>
                                    <option value="12">December</option>
                                </select> 
                                <select name="sday">
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                    <option value="13">13</option>
                                    <option value="14">14</option>
                                    <option value="15">15</option>
                                    <option value="16">16</option>
                                    <option value="17">17</option>
                                    <option value="18">18</option>
                                    <option value="19">19</option>
                                    <option value="20">20</option>
                                    <option value="21">21</option>
                                    <option value="22">22</option>
                                    <option value="23">23</option>
                                    <option value="24">24</option>
                                    <option value="25">25</option>
                                    <option value="26">26</option>
                                    <option value="27">27</option>
                                    <option value="28">28</option>
                                    <option value="29">29</option>
                                    <option value="30">30</option>
                                    <option value="31">31</option>
                                </select>
                            </th>
                            <th>
                                <select name="emonth">
                                    <option value="1">January</option>
                                    <option value="2">February</option>
                                    <option value="3">March</option>
                                    <option value="4">April</option>
                                    <option value="5">May</option>
                                    <option value="6">June</option>
                                    <option value="7">July</option>
                                    <option value="8">August</option>
                                    <option value="9">September</option>
                                    <option value="10">October</option>
                                    <option value="11">November</option>
                                    <option value="12">December</option>
                                </select>	
                                <select name="eday">
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                    <option value="13">13</option>
                                    <option value="14">14</option>
                                    <option value="15">15</option>
                                    <option value="16">16</option>
                                    <option value="17">17</option>
                                    <option value="18">18</option>
                                    <option value="19">19</option>
                                    <option value="20">20</option>
                                    <option value="21">21</option>
                                    <option value="22">22</option>
                                    <option value="23">23</option>
                                    <option value="24">24</option>
                                    <option value="25">25</option>
                                    <option value="26">26</option>
                                    <option value="27">27</option>
                                    <option value="28">28</option>
                                    <option value="29">29</option>
                                    <option value="30">30</option>
                                    <option value="31">31</option>
                                </select>
                            </th>
                            
                            <th><input type="submit" value="Search"></th>
                        </form>
                    </tr>


                    <table border="1">
                        <tr>
                            <th>Available Time slots</th>
                        </tr>
                        <%
                            String startM = request.getParameter("smonth");
                            String startD = request.getParameter("sday");
                            String endM = request.getParameter("emonth");
                            String endD = request.getParameter("eday");
                            int dateStartLimit = 8;
                            int dateEndLimit = 20;

                            HashMap<String, ArrayList<Integer>> conflictMap = new HashMap<>();

	  	                    if (rs2 != null) {
	  		                    if (rs2.isBeforeFirst()) {
				                    while(rs2.next()) {
                                        String conflictSDate = rs2.getString("session_date"); //"M,W,F"
                                        List<String> conSDateList = new ArrayList<>(Arrays.asList(conflictSDate.split("\\s*(\\s|=>|,)\\s*"))); // [M,W,F]
                                        for (String DDD : conSDateList) {
                                            String convertDDD = dateMap.get(DDD);
                                            //System.out.println(convertDDD);
                                            if (conflictMap.containsKey(convertDDD)) {
                                                ArrayList<Integer> tempList = conflictMap.get(convertDDD);
                                                if (!tempList.contains(rs2.getString("start_time"))) {
                                                    tempList.add(Integer.parseInt(rs2.getString("start_time")));
                                                    conflictMap.put(convertDDD, tempList);
                                                }
                                            }
                                            else {
                                                ArrayList<Integer> tempList = new ArrayList<>();
                                                tempList.add(Integer.parseInt(rs2.getString("start_time")));
                                                conflictMap.put(convertDDD, tempList);
                                            }
                                        }
                                    }                                  
                                }
                                while(true) {
                                    try { 
                                        Calendar c = Calendar.getInstance();
                                        String yourDate = startM + "/" + startD + "/2020";
                                        SimpleDateFormat format1 = new SimpleDateFormat("MM/dd/yyyy");
                                        SimpleDateFormat format2 = new SimpleDateFormat("EEEE");
                                        c.setTime(format1.parse(yourDate));
                                        String todayIs = format2.format(c.getTime()); // Wednesday
                                        if (!todayIs.equals("Saturday") && !todayIs.equals("Sunday")) {
                                            if (conflictMap.containsKey(todayIs)) { //may conflict
                                                ArrayList<Integer> tempCList = conflictMap.get(todayIs);
                                                
                                                for (int i = dateStartLimit; i < dateEndLimit; i++) {
                                                    if (!tempCList.contains(i)) {
                                                        String printSTime = String.valueOf(i) + ":00 AM";
                                                        String printETime = String.valueOf(i+1) + ":00 AM";
                                                        if (i >= 12) {
                                                            int tempI = i;
                                                            if (tempI > 12) tempI = tempI % 12;
                                                            printSTime = String.valueOf(tempI) + ":00 PM";
                                                        }
                                                        if (i+1 >= 12) {
                                                            int tempI1 = i+1;
                                                            if (tempI1 > 12) tempI1 = tempI1 % 12;
                                                            printETime = String.valueOf(tempI1) + ":00 PM";
                                                        }
                                                %>
                                                    <tr><td><%=monthMap.get(startM)%> <%=startD%> <%=todayIs%> <%=printSTime%> - <%=printETime%></td></tr>
                                                <%
                                                    }
                                                }
                                            }
                                            else {
                                                for (int i = dateStartLimit; i < dateEndLimit; i++) {
                                                    String printSTime = String.valueOf(i) + ":00 AM";
                                                    String printETime = String.valueOf(i+1) + ":00 AM";
                                                    if (i >= 12) {
                                                        int tempI = i;
                                                        if (tempI > 12) tempI = tempI % 12;
                                                        printSTime = String.valueOf(tempI) + ":00 PM";
                                                    }
                                                    if (i+1 >= 12) {
                                                        int tempI1 = i+1;
                                                        if (tempI1 > 12) tempI1 = tempI1 % 12;
                                                        printETime = String.valueOf(tempI1) + ":00 PM";
                                                    }
                                                %>                                      
                                                    <tr><td><%=monthMap.get(startM)%> <%=startD%> <%=todayIs%> <%=printSTime%> - <%=printETime%></td></tr>
                                                <%
                                                }
                                            }
                                        }
    
                                        int tempDNum = Integer.parseInt(startD) + 1;
                                        startD = String.valueOf(tempDNum);
                                        if (tempDNum > howManyDays.get(startM)) {
                                            tempDNum = tempDNum % howManyDays.get(startM);
                                            startM = String.valueOf(Integer.parseInt(startM) + 1);
                                            startD = String.valueOf(tempDNum);
                                        }
                                        
                                        if (startM.equals(endM) && startD.equals(String.valueOf(Integer.parseInt(endD) + 1))) break;
                                    } catch (ParseException excpt) { 
                                        excpt.printStackTrace(); 
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
