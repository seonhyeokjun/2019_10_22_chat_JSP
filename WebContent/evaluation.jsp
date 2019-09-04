<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
	<%
		request.setCharacterEncoding("UTF-8");
		String siteDivide = "전체";
		String searchType = "최신순";
		String search = "";
		int pageNumber = 0;
		if(request.getParameter("siteDivide") != null){
			siteDivide = request.getParameter("siteDivide");
		}
		if(request.getParameter("searchType") != null){
			searchType = request.getParameter("searchType");
		}
		if(request.getParameter("search") != null){
			search = request.getParameter("search");
		}
		if(request.getParameter("pageNumber") != null){
			try{
				pageNumber = Integer.parseInt(request.getParameter("pageNumber")); 
			} catch (Exception e){
				System.out.println("검색 페이지 번호 오류");
			}
		}
		String userID = null;
		if (session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지않는 상태입니다.");
			response.sendRedirect("index.jsp");
			return;
		}
	%>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>JSP Ajax 실시간 회원제 채팅 서비스</title>
	<!-- 부트스트랩 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css">
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.js"></script>
	<script type="text/javascript">
		function getUnread(){
			$.ajax({
				 type: "POST",
				 url: "./chatUnread",
				 data: {
					 userID: encodeURIComponent('<%= userID %>'),
				 },
				 success: function(result){
					 if(result >= 1){
						 showUnread(result);
					 } else {
						 showUnread("");
					 }
				 }
			});
		}
		function getInfiniteUnread(){
			setInterval(function(){
				getUnread();
			}, 4000);
		}
		function showUnread(result){
			$('#unread').html(result);
		}
		function active(){
			$('.nav-container li:nth-child(5)').addClass('active');
		}
	</script>
</head>
<body>
	<%@ include file="nav_list.jsp" %>
	<section class="container">
		<form method="get" action="./evaluation.jsp" class="form-inline" style="margin-bottom: 20px;">
			<select name="siteDivide" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="친구찾기" <% if(siteDivide.equals("친구찾기")) out.println("selected"); %>>친구찾기</option>
				<option value="메세지함" <% if(siteDivide.equals("메세지함")) out.println("selected"); %>>메세지함</option>
				<option value="자유게시판" <% if(siteDivide.equals("자유게시판")) out.println("selected"); %>>자유게시판</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<option value="추천순" <% if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록하기</a>
		</form>
		<%
		ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
		evaluationList = new EvaluationDAO().getList(siteDivide, searchType, search, pageNumber);
		if(evaluationList != null)
			for(int i = 0; i < evaluationList.size(); i++){
				if(i == 5) break;
				EvaluationDTO evaluation = evaluationList.get(i);
		%>
		<div class="panel panel-default">
			<div class="panel-heading">
				<div class="row">
					<div class="col-xs-4 col-sm-4 col-md-8 text-left"><%= evaluation.getSiteName() %>&nbsp;<small><%= evaluation.getEvaluationName() %></small></div>
					<div class="col-xs-8 col-md-4 text-right">
						종합 <span style="color:red;"><%= evaluation.getTotalScore() %></span>
					</div>
				</div>
			</div>
			<div class="panel-body">
				<h5 class="card-title">
					<%= evaluation.getEvaluationTitle() %>&nbsp;<small>(<%= evaluation.getSiteYear() %>년 <%= evaluation.getSeasonDivide() %>)</small>
				</h5>
				<p class="card-text"><%= evaluation.getEvaluationContent() %></p>
				<div class="row">
					<div class="col-xs-6 col-sm-6 col-md-8 text-left">
						친구찾기 <span style="color: red;"><%= evaluation.getFunctionalityScore() %></span>
						메세지함 <span style="color: red;"><%= evaluation.getComfortableScore() %></span>
						자유게시판 <span style="color: red;"><%= evaluation.getCreativityScore() %></span>
						<span style="color: green;">(추천: <%= evaluation.getLikeCount() %>)</span>
					</div>
					<div class="col-xs-6 col-md-4 text-right">
						<a style="color: #337ab7;" onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">추천</a>
						<a style="color: #337ab7;" onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">삭제</a>
					</div>
				</div>
			</div>
		</div>
		<%
			}       
		%>
	</section>
	<ul	class="pagination justify-content-center" style="display: flex;">
		<li class="page-item">
		<%
			if(pageNumber <= 0){
		%>
			<a class="page-link" style="color: #000;">이전</a>
		<%
			} else {
		%>
			<a class="page-link" href="./evaluation.jsp?siteDivide=<%= URLEncoder.encode(siteDivide, "UTF-8") %>&searchType=
			<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
			<%= pageNumber - 1 %>">이전</a>
		<%
			}
		%>
		</li>
		<li>
		<%
			if(evaluationList.size() < 6){
		%>
			<a class="page-link" style="color: #000;">다음</a>
		<%
			} else {
		%>
			<a class="page-link" href="./evaluation.jsp?siteDivide=<%= URLEncoder.encode(siteDivide, "UTF-8") %>&searchType=
			<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
			<%= pageNumber + 1 %>">다음</a>
		<%
			}
		%>
		</li>
	</ul>
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h5 class="modal-title" id="modal">평가 등록</h5>
				</div>
				<div class="modal-body">
					<form action="./evaluationRegisterAction.jsp" method="post">
						<div class="row">
							<div class="form-group col-sm-6">
								<label>아이디</label>
								<input type="text" name="siteName" class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-6">
								<label>이름</label>
								<input type="text" name="evaluationName" class="form-control" maxlength="20">
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-4">
								<label>연도</label>
								<select name="siteYear" class="form-control">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019" selected>2019</option>
									<option value="2020">2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023">2023</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>계절</label>
								<select name="seasonDivide" class="form-control">
									<option value="봄" selected>봄</option>
									<option value="여름">여름</option>
									<option value="가을">가을</option>
									<option value="겨울">겨울</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>게시판</label>
								<select name="siteDivide" class="form-control">
									<option value="친구찾기" selected>친구찾기</option>
									<option value="메세지함">메세지함</option>
									<option value="자유게시판">자유게시판</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="evaluationTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="evaluationContent" class="form-control" maxlength="2048" style="height:180px;"></textarea>
						</div>
						<div class="row">
							<div class="form-group col-sm-3">
								<label>종합</label>
								<select name="totalScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>기능성</label>
								<select name="functionalityScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>편의성</label>
								<select name="comfortableScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>창의성</label>
								<select name="creativityScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<%
		String messageContent = null;
		if(session.getAttribute("messageContent") != null){
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if(session.getAttribute("messageType") != null){
			messageType = (String) session.getAttribute("messageType");
		}
		if(messageContent != null){
	%>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content <% if(messageType.equals("오류 메시지")) out.println("panel-warning"); else out.println("panel-success"); %>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%= messageType %>
						</h4>
					</div>
					<div class="modal-body">
						<%= messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<script type="text/javascript">
		$('#messageModal').modal("show");
	</script>
	<%
		if(userID != null){
	%>
	<script type="text/javascript">
		$(document).ready(function(){
			getUnread();
			getInfiniteUnread();
			active();
		});
	</script>
	<%
		}
	%>
<!-- 파퍼 자바스크립트 추가하기 -->
<script src="./js/popper.js" type="text/javascript"></script>
</body>
</html>