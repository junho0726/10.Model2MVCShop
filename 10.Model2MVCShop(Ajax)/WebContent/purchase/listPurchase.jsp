<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 

<!DOCTYPE html>

<html>
<head>
<title>구매 목록조회</title>
<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

function fncGetUserList(currentPage) {
	//document.getElementById("currentPage").value = currentPage;
	$("#currentPage").val(currentPage)
   	//document.detailForm.submit();
	$("form").attr("method" , "POST").attr("action" , "/purchase/listPurchase").submit();
}

$(function() {
$(".ct_list_pop td:nth-child(1)" ).on("click" , function() {
	self.location ="/purchase/getPurchase?tranNo="+$(this).attr("value")
});

$("a:contains('물건도착')").on("click" , function() {
	self.location ="/purchase/updateTranCode?tranNo="+$(this).attr("value")
});

$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
	//Debug..
	//alert(  $( this ).text().trim() );
	self.location ="/user/getUser?userId="+$(this).text().trim();
	});
});	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width: 98%; margin-left: 10px;">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">구매 목록조회</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td colspan="11">전체 ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage } 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">제품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원ID</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">전화번호</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">배송현황</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">정보수정</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	<c:forEach var="purchase" items= "${list}" >
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
		<td align="center" name="tranNo" value="${purchase.tranNo}">${i}</td>
		</td>
		<td></td>
		<td align="left">${purchase.buyer.userId }</td>
		<td></td>
		<td align="left">${purchase.receiverName}</td>
		<td></td>
		<td align="left">${purchase.receiverPhone}</td>		
		<td></td>
		<td align="left">
			<c:choose>
				<c:when test="${purchase.tranCode.charAt(0)=='3'.charAt(0) }">배송완료<td></c:when>
				<c:when test="${purchase.tranCode.charAt(0)=='2'.charAt(0) }">배송중<td></c:when>
				<c:otherwise>구매완료<td></c:otherwise>
			</c:choose>
	 		<td align="left"><!-- status에 따라 분기 나누세요. -->
			<c:choose>
				<c:when test="${purchase.tranCode.charAt(0)=='3'.charAt(0) }"/>
				<c:when test="${purchase.tranCode.charAt(0)=='2'.charAt(0) }">
<%-- 					<a href="/purchase/updateTranCode?tranNo=${purchase.tranNo }&tranCode=3">물건도착</a> --%>
				<a value ="${purchase.tranNo}&tranCode=3">물건도착</a>
				</c:when>
			</c:choose>
			</td>
	</c:forEach>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
	<tr>
		<td align="center">
			 <input type="hidden" id="currentPage" name="currentPage" value=""/>
				<jsp:include page="../common/pageNavigator.jsp"/>	
		</td>
	</tr>
</table>

<!--  페이지 Navigator 끝 -->
</form>

</div>

</body>
</html>