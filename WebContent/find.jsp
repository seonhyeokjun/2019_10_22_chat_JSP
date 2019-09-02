<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지 않습니다.");
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
		function findFunction(){
			var userID = $('#findID').val();
			$.ajax({
				type: "POST",
				url: './UserFindServlet',
				data: {userID: userID},
				success: function(result){
					if(result == -1){
						$('#checkMessage').html('친구를 찾을수 없습니다.');
						$('#checkType').attr('class', 'modal-content panel-warning');
						failFriend();
					} else{
						$('#checkMessage').html('친구찾기에 성공했습니다.');
						$('#checkType').attr('class', 'modal-content panel-success');
						var data = JSON.parse(result);
						var profile = data.userProfile;
						getFriend(userID, profile);
					}
					$('#checkModal').modal("show");
				}
			});
		}
		function getFriend(findID, userProfile){
			$('#friendResult').html(
				'<thead>' +
				'<tr>' +
				'<th><h4>검색 결과</h4></th>' +
				'</tr>' +
				'</thead>' +
				'<tbody>' +
				'<tr>' +
				'<td style="text-align: center;">' +
				'<img class="media-object img-circle" style="max-width: 300px; margin: 0 auto;" src="' + userProfile + '">' +
				'<h3>' +
				findID +
				'</h3><a href="chat.jsp?toID=' +
				encodeURIComponent(findID) +
				'" class="btn btn-primary pull-right">' +
				'메세지 보내기</a></td>' +
				'</tr>' +
				'</tbody>'
			);
		}
		function failFriend(){
			$('#friendResult').html('');
		}
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
	</script>
</head>
<body>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.jsp">실시간 회원제 채팅 서비스</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">메인</a></li>
				<li class="active"><a href="find.jsp">친구찾기</a></li>
				<li><a href="box.jsp">메세지함<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">자유게시판</a></li>
				<li><a href="evaluation.jsp">사이트 평가</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
						회원관리<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="update.jsp">회원정보수정</a></li>
						<li><a href="profileUpdate.jsp">프로필 수정</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #ddd">
			<thead>
				<tr>
					<th colspan="2"><h4>검색으로 친구찾기</h4></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width: 110px;"><h5>친구 아이디</h5></td>
					<td><input class="form-control" type="text" id="findID" maxlength="20" placeholder="찾을 아이디를 입력하세요."></td>
				</tr>
				<tr>
					<td colspan="2"><button class="btn btn-primary pull-right" onclick="findFunction();">검색</button></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="container">
		<table id="friendResult" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #ddd;">
		</table>
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
	<script type="text/javascript">
		$('#messageModal').modal("show");
	</script>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div id="checkType" class="modal-content panel-info">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							확인 메시지
						</h4>
					</div>
					<div id="checkMessage" class="modal-body">
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
		if(userID != null){
	%>
	<script type="text/javascript">
		$(document).ready(function(){
			getUnread();
			getInfiniteUnread();
		});
	</script>
	<%
		}
	%>
</body>
</html>