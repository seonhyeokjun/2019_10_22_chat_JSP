package board;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BoardDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html'charset=UTF-8");
		HttpSession session = request.getSession();
		String userID = (String) session.getAttribute("userID");
		String boardID = request.getParameter("boardID");
		if(boardID == null || boardID.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO board = boardDAO.getBoard(boardID);
		if(!userID.equals(board.getUserID())) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		String savaPath = request.getRealPath("/upload").replaceAll("\\\\", "/");
		String prev = boardDAO.getRealFile(boardID);
		int result = boardDAO.delete(boardID);
		if(result == -1) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		} else {
			File prevFile = new File(savaPath + "/" + prev);
			if(prevFile.exists()) {
				prevFile.delete();
			}
			request.getSession().setAttribute("messageType", "성공 메시지");
			request.getSession().setAttribute("messageContent", "삭제에 성공했습니다.");
			response.sendRedirect("boardView.jsp");
			return;
		}
	}
}
