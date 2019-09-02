package evaluation;

public class EvaluationDTO {

	int evaluationID;
	String userID;
	String siteName;
	String evaluationName;
	int siteYear;
	String seasonDivide;
	String siteDivide;
	String evaluationTitle;
	String evaluationContent;
	String totalScore;
	String functionalityScore;
	String comfortableScore;
	String creativityScore;
	int likeCount;
	
	public int getEvaluationID() {
		return evaluationID;
	}

	public void setEvaluationID(int evaluationID) {
		this.evaluationID = evaluationID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getSiteName() {
		return siteName;
	}

	public void setSiteName(String siteName) {
		this.siteName = siteName;
	}

	public String getEvaluationName() {
		return evaluationName;
	}

	public void setEvaluationName(String evaluationName) {
		this.evaluationName = evaluationName;
	}

	public int getSiteYear() {
		return siteYear;
	}

	public void setSiteYear(int siteYear) {
		this.siteYear = siteYear;
	}

	public String getSeasonDivide() {
		return seasonDivide;
	}

	public void setSeasonDivide(String seasonDivide) {
		this.seasonDivide = seasonDivide;
	}

	public String getSiteDivide() {
		return siteDivide;
	}

	public void setSiteDivide(String siteDivide) {
		this.siteDivide = siteDivide;
	}

	public String getEvaluationTitle() {
		return evaluationTitle;
	}

	public void setEvaluationTitle(String evaluationTitle) {
		this.evaluationTitle = evaluationTitle;
	}

	public String getEvaluationContent() {
		return evaluationContent;
	}

	public void setEvaluationContent(String evaluationContent) {
		this.evaluationContent = evaluationContent;
	}

	public String getTotalScore() {
		return totalScore;
	}

	public void setTotalScore(String totalScore) {
		this.totalScore = totalScore;
	}

	public String getFunctionalityScore() {
		return functionalityScore;
	}

	public void setFunctionalityScore(String functionalityScore) {
		this.functionalityScore = functionalityScore;
	}

	public String getComfortableScore() {
		return comfortableScore;
	}

	public void setComfortableScore(String comfortableScore) {
		this.comfortableScore = comfortableScore;
	}

	public String getCreativityScore() {
		return creativityScore;
	}

	public void setCreativityScore(String creativityScore) {
		this.creativityScore = creativityScore;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}

	public EvaluationDTO() {
		
	}

	public EvaluationDTO(int evaluationID, String userID, String siteName, String evaluationName, int siteYear,
			String seasonDivide, String siteDivide, String evaluationTitle, String evaluationContent, String totalScore,
			String functionalityScore, String comfortableScore, String creativityScore, int likeCount) {
		super();
		this.evaluationID = evaluationID;
		this.userID = userID;
		this.siteName = siteName;
		this.evaluationName = evaluationName;
		this.siteYear = siteYear;
		this.seasonDivide = seasonDivide;
		this.siteDivide = siteDivide;
		this.evaluationTitle = evaluationTitle;
		this.evaluationContent = evaluationContent;
		this.totalScore = totalScore;
		this.functionalityScore = functionalityScore;
		this.comfortableScore = comfortableScore;
		this.creativityScore = creativityScore;
		this.likeCount = likeCount;
	}
}
