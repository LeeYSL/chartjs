<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파이 그래프로 게시글 작성자의 건수 출력하기</title>
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>
</head>
<body>
	<sql:setDataSource var="conn" driver="org.mariadb.jdbc.Driver"
		url="jdbc:mariadb://localhost:3306/gdudb" user="gdu" password="1234" />
	<sql:query var="rs" dataSource="${conn}">
	
SELECT writer,COUNT(*) cnt 
from board
GROUP BY writer 
HAVING COUNT(*) > 1
ORDER BY 2 desc
 </sql:query>

	<div style="width: 75%">
		<canvas id="canvas"></canvas>
	</div>

	<script type="text/javascript">
  let randomColorFactor = function() {
	 return Math.round(Math.random()*225) //0~225 사이의 임의의 수
  }
   let randomColor = function(opacity) {
	 /*rgb(225,225,225) => 흰색.#FFFFFF
	   rgba(225,225,225) => 흰색.#FFFFFF1 => a: 투명도. 1:불투명,0:투명
	 */
	 return "rgba("+randomColorFactor() +"," 
			 + randomColorFactor() + ","
			 + randomColorFactor() + ","
			 + (opacity || '.3') +")"
 }
   let config = { 
		type : "pie",
		labels : //작성자 이름
		[<c:forEach items="${rs.rows}" var="m">"${m.writer}",</c:forEach>],
        datasets: [
        	{type :'pie',
        	 backgroundColor:[<c:forEach items="${rs.rows}" var="m">
        	         randomColor(1),</c:forEach>],
        	 label:'파이 그래프',
          data:[<c:forEach items="${rs.rows}" var="m">
        	                   "${m.cnt}",</c:forEach>]
        	}]
        	};
        
        	  window.onload=function() {
        		  var ctx = document.getElementById('canvas').getContext('2d');
        		  new Chart(ctx,{
        			  type:'pie', data:config,
        			  options: {
        				  responsive:true, //반응형
        				  title : {
        					  display : true, 
        					  text:"글쓴이별 게시판 등록 건수"
        					  },
        				  legend : {dispaly : true},
        				 
        		
        		  }
        		  })
        		  
        	  }       
</script>
</body>
</html>