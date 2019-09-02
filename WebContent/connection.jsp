<!DOCTYPE html>
<html>
<head>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, javax.naming.InitialContext, javax.naming.Context" %>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<% 
		InitialContext initCtx = new InitialContext();
		Context envContext = (Context) initCtx.lookup("java:/comp/env");
		DataSource ds = (DataSource) envContext.lookup("jdbc/UserChat");
		Connection conn = ds.getConnection();
		Statement stmt = conn.createStatement();
		ResultSet rest = stmt.executeQuery("SELECT VERSION();");
		while(rest.next()){
			out.println("MySQL Version: " + rest.getString("version()"));
		}
		rest.close();
		stmt.close();
		conn.close();
		initCtx.close();
	%>
</body>
</html>