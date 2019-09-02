<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해 주세요.');");
		script.println("location.href = 'login.jsp'");
		script.println("</script>");
		script.close();
		return;
	}

	String siteName = null;
	String evaluationName = null;
	int siteYear = 0;
	String seasonDivide = null;
	String siteDivide = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	String totalScore = null;
	String functionalityScore = null;
	String comfortableScore = null;
	String creativityScore = null;

	if(request.getParameter("siteName") != null){
		siteName = request.getParameter("siteName");
	}
	if(request.getParameter("evaluationName") != null){
		evaluationName = request.getParameter("evaluationName");
	}
	if(request.getParameter("siteYear") != null){
		try{
			siteYear = Integer.parseInt(request.getParameter("siteYear"));
		} catch(Exception e){
			System.out.println("강의 연도 데이터 오류");
		}
	}
	if(request.getParameter("seasonDivide") != null){
		seasonDivide = request.getParameter("seasonDivide");
	}
	if(request.getParameter("siteDivide") != null){
		siteDivide = request.getParameter("siteDivide");
	}
	if(request.getParameter("evaluationTitle") != null){
		evaluationTitle = request.getParameter("evaluationTitle");
	}
	if(request.getParameter("evaluationContent") != null){
		evaluationContent = request.getParameter("evaluationContent");
	}
	if(request.getParameter("totalScore") != null){
		totalScore = request.getParameter("totalScore");
	}
	if(request.getParameter("functionalityScore") != null){
		functionalityScore = request.getParameter("functionalityScore");
	}
	if(request.getParameter("comfortableScore") != null){
		comfortableScore = request.getParameter("comfortableScore");
	}
	if(request.getParameter("creativityScore") != null){
		creativityScore = request.getParameter("creativityScore");
	}
	if(siteName == null || evaluationName == null || siteYear == 0 || seasonDivide == null || siteDivide == null || evaluationTitle == null || 
			evaluationContent == null || totalScore == null || functionalityScore == null || comfortableScore == null || creativityScore == null || evaluationTitle.equals("")
			|| evaluationContent.equals("")){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	int result = evaluationDAO.write(new EvaluationDTO(0, userID, siteName, evaluationName, siteYear, seasonDivide,
			siteDivide, evaluationTitle, evaluationContent, totalScore, functionalityScore, comfortableScore, creativityScore, 0));
	if(result == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('강의 평가 등록 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'evaluation.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>