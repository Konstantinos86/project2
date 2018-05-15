<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <%@include file="../fragments/head.jspf" %>
  <title>Management</title>
</head>

<body>

<%--Header--%>
<%@include file="../fragments/topbar.jspf" %>

<%
  List<String> path = new ArrayList<>(Collections.singletonList("Management"));
  pageContext.setAttribute("path", path);
%>

<%--Breadcrumbs--%>
<%@include file="../fragments/breadcrumbs.jspf" %>

<!-- checkout -->
<div class="checkout">
  <div class="container">

    <div class="btn-group btn-group-justified">
      <a href="${pageContext.request.contextPath}/admin/listings/all" class="btn btn-primary">All</a>
      <a href="${pageContext.request.contextPath}/admin/listings/available" class="btn btn-primary">Active</a>
      <a href="${pageContext.request.contextPath}/admin/listings/inactive" class="btn btn-primary">Inactive</a>
      <a href="${pageContext.request.contextPath}/admin/listings/depleted" class="btn btn-primary">Depleted</a>
      <a href="${pageContext.request.contextPath}/admin/listings/pending" class="btn btn-primary">Pending</a>
    </div>

    <div class="btn-group-justified">
      <a href="${pageContext.request.contextPath}/admin/listings/all" class="button-admin-choice-middle"
         style="border-radius: 10px 0 0 0">All</a>
      <a href="${pageContext.request.contextPath}/admin/listings/available"
         class="button-admin-choice-middle">Active</a>
      <a href="${pageContext.request.contextPath}/admin/listings/inactive"
         class="button-admin-choice-middle">Inactive</a>
      <a href="${pageContext.request.contextPath}/admin/listings/depleted"
         class="button-admin-choice-middle">Depleted</a>
      <a href="${pageContext.request.contextPath}/admin/listings/pending" class="button-admin-choice-middle"
         style="border-radius: 0 10px 0 0">Pending</a>
    </div>

    <div class="checkout-right">

      <table class="timetable_sub">

        <thead>
        <tr>
          <th>ID</th>
          <th>Username</th>
          <th>Unit</th>
          <th>Quantity</th>
          <th>Price Per Unit</th>
          <th>Base Price In</th>
          <th>Base Price Out</th>
          <th>Date Listed</th>
          <th>Total Price</th>
          <th>Status</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${listings}" var="l">
          <tr>
            <td>${l.listingId}</td>
            <td>${l.userByUserId.email}</td>
            <td>${l.unitByUnitId.unitName}</td>
            <td>${l.listingQuantity}</td>
            <td>${l.pricePerUnit}&euro;</td>
            <td>${l.productByProductId.basePriceIn}&euro;</td>
            <td>${l.productByProductId.basePriceOut}&euro;</td>
            <td>${l.listingDate}</td>
            <td>${l.pricePerUnit * l.listingQuantity}&euro;</td>
            <td>
              <button class="btn btn-info" onclick="changeStatusId(${l.listingId})" id="status_${l.listingId}">
                  ${l.statusByStatusId.statusName}
              </button>
            </td>
          </tr>
        </c:forEach>
        </tbody>

      </table>

    </div>
    <div class="checkout-left">
      <div class="checkout-right-basket">
        <a href="${pageContext.request.contextPath}/">
          <span class="glyphicon glyphicon-menu-left"
                aria-hidden="true"></span>
          Back to Home
        </a>
      </div>
      <div class="clearfix"></div>
    </div>
  </div>
</div>
<!-- //checkout -->

<%--Footer--%>
<%@include file="../fragments/footer.jspf" %>

<script>

    function changeStatusId(id) {
        $.post("${pageContext.request.contextPath}/admin/change_listing_status/" + id,
            function (data) {
                $("#status_" + id).text(data);
                $.post("${pageContext.request.contextPath}/admin/balance",
                    function (data) {
                        $("#user_balance").text("Balance: " + data + "\u20AC");
                    }
                );
            }
        );
    }

</script>

</body>
</html>