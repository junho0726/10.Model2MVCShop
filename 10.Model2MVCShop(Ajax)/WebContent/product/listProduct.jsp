<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page import="java.util.*"  %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 

<!DOCTYPE html>
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=euc-kr"></meta>
<title>��ǰ �����ȸ</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	
function fncGetUserList(currentPage) {
	//document.getElementById("currentPage").value = currentPage;
	$("#currentPage").val(currentPage)
   	//document.detailForm.submit();
	$("form").attr("method" , "POST").attr("action" , "/product/listProduct?menu=${param.menu }").submit();
}

$(function() {


$( "td.ct_btn01:contains('�˻�')" ).on("click" , function() {

	fncGetUserList(1);
});

$("a:contains('����ϱ�')").on("click" , function() {
	self.location ="/purchase/updateTranCodeByProd?prodNo="+$(this).attr("value")
});

$(".ct_list_pop td:nth-child(3)[name='manage']" ).on("click" , function() {
	self.location ="/product/updateProductView?prodNo="+$(this).attr("value")
});


$(".ct_list_pop td:nth-child(3)[name='search']" ).on("click" , function() {
	var prodNo = $(this).attr("value");
	$.ajax( 
			{
				url : "/product/json/getProduct/"+prodNo ,
				method : "GET" ,
				dataType : "json" ,
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},	
				success : function(JSONData , status) {
				var displayValue = "<h3>"
						+"��ǰ��ȣ: "+JSONData.prodNo+"<br/>"
						+"��ǰ�� : "+JSONData.prodName+"<br/>"
						+"��ǰ������ : "+JSONData.prodDetail+"<br/>"
						+"�������� : "+JSONData.manuDate+"<br/>"
						+"���� : "+JSONData.price+"<br/>"
						+"</h3>";
				
				$("h3").remove();
				$( "#"+prodNo+"" ).html(displayValue);
			}
	});
	////////////////////////////////////////////////////////////////////////////////////////////

});
$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
$("h7").css("color" , "red");

$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
});	


</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm">
<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
						<c:if test="${!empty param.menu}">
							<c:choose>
								<c:when test="${param.menu == 'search' }">
									��ǰ�����ȸ
								</c:when>
								<c:when test="${param.menu == 'manage' }">
									��ǰ����
								</c:when>
							</c:choose>
						</c:if>
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<c:if test="${!empty search}" >
			<td align="right">
				<select name="searchCondition" class="ct_input_g" style="width:80px">
					<option value="0" ${search.searchCondition==0 ? "selected":"" }>��ǰ��ȣ</option>
					<option value="1" ${search.searchCondition==1 ? "selected":"" }>��ǰ��</option>
					<option value="2" ${search.searchCondition==2 ? "selected":"" }>��ǰ����</option>
				</select>
		</c:if>
		<c:if test="${empty search }" >
			<td align="right">
				<select name="searchCondition" class="ct_input_g" style="width:80px">
					<option value="0">��ǰ��ȣ</option>
					<option value="1">��ǰ��</option>
					<option value="2">��ǰ����</option>	
				</select>
		</c:if>
		<c:if test="${empty param.searchKeyword }">
			<input type="text" name="searchKeyword"  class="ct_input_g" style="width:200px; height:19px" >
		</c:if>
		<c:if test="${!empty param.searchKeyword }">
			<input type="text" name="searchKeyword" value="${param.searchKeyword }" class="ct_input_g" style="width:200px; height:19px" >
		</c:if>
		
		</td>
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						�˻�
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >��ü ${resultPage.totalCount } �Ǽ�, ���� ${resultPage.currentPage } ������
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">��ǰ��</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">����</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">�����</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">�������</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
		<c:set var="i" value="0" />
	<c:forEach var="product" items="${list}">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
			<td align="center">${ i }</td>
			<td></td>
 		<c:if test="${!empty param.menu }">
				<c:if test="${param.menu == 'manage' }">
					<c:choose>
						<c:when test="${product.proTranCode =='0' }">
						<td align="left" name ="manage"  value ="${product.prodNo }"/>
						${product.prodName }
						</c:when>
						<c:otherwise>
						<td align="left">
						${product.prodName }</a></td>		
						</c:otherwise>
					</c:choose>	
				</c:if>
				<c:if test="${param.menu == 'search' }">
					<c:choose>
						<c:when test="${product.proTranCode== '0' }">
				<td align="left" name="search" value ="${product.prodNo }">
						${product.prodName }
						</c:when>
						<c:otherwise>
						<td align="left">${product.prodName }</td>
						</c:otherwise>
					</c:choose>
				</c:if>
				<td></td>
				<td align="left">${product.price }</td>
				<td></td>
				<td align="left">${product.regDate }</td>
				<td></td>
				<td align="left">
				<c:if test="${param.menu == 'manage' }">
					<c:choose>
						<c:when test="${product.proTranCode.charAt(0) == '1'.charAt(0) }">
							���� �Ϸ�<a value ="${product.prodNo }&tranCode=2">����ϱ�</a>
						</c:when>
						<c:when test="${product.proTranCode.charAt(0) == '2'.charAt(0) }">�����</c:when>
						<c:when test="${product.proTranCode.charAt(0) == '3'.charAt(0) }">��ۿϷ�</c:when>
						<c:otherwise>
							�Ǹ���
						</c:otherwise>
					</c:choose>
				</c:if>	
				<c:if test="${param.menu == 'search' }">
					<c:choose>
						<c:when test="${product.proTranCode == '0' }">
							�Ǹ���
						</c:when>
						<c:otherwise>
							������
						</c:otherwise>
					</c:choose>
				</c:if>	
					</td>	
				</tr>
			</c:if>  
			<tr>
				<td id="${product.prodNo }" colspan="11" bgcolor="D6D7D6" height="1"></td>
			</tr>
		</c:forEach>
		

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
			 <input type="hidden" id="currentPage" name="currentPage" value=""/>
			 
			<jsp:include page="../common/pageNavigator.jsp"/>	
	</tr>
</table>
<!--  ������ Navigator �� -->

</form>

</div>
</body>
</html>