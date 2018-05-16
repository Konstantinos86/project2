<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <%@include file="../fragments/head.jspf" %>
  <title>Cart</title>
</head>

<body>

<%--Header--%>
<%@include file="../fragments/topbar.jspf" %>

<%
  List<String> path = new ArrayList<>(Collections.singletonList("Cart"));
  pageContext.setAttribute("path", path);
%>

<%--Breadcrumbs--%>
<%@include file="../fragments/breadcrumbs.jspf" %>

<jsp:useBean id="cart" scope="session" class="model.Cart"/>

<!-- checkout -->
<div class="checkout">
  <div class="container">
    <h2>Your shopping cart contains: <span>${cart.totalQuantity} Products</span></h2>
    <%--@elvariable id="error" type="java.lang.String"--%>
    <c:if test="${error ne null and error.length() gt 0}">
      <h2 style="color: red">Failed to checkout - Insufficient Balance</h2>
    </c:if>
    <div class="checkout-right">

      <table class="timetable_sub">

        <thead>
        <tr>
          <th>SL No.</th>
          <th>Image</th>
          <th>Product Name</th>
          <th>Vendor</th>
          <th>Available</th>
          <th>Quantity</th>
          <th>PPU</th>
          <th>Price</th>
          <th>Remove</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach items="${cart.items}" var="l">
          <tr id="row_${l.listingId}" class="rem1">
            <td class="invert"><div class="common">${l.listingId}</div></td>
            <td class="invert-image"><a
                href="${pageContext.request.contextPath}/listings/${l.productByProductId.productId}"><img
                src="${l.productByProductId.imagePath}" alt=" " class="img-responsive"/></a>
            </td>
            <td class="invert"><div class="common">${l.listingName}</div></td>
            <td class="invert"><div class="common">${l.userByUserId.name}</div></td>
            <td class="invert"><div class="common">${l.listingQuantity}</div></td>
            <td id="cart_${l.listingId}" class="invert">
              <div class="btn-group mybtn">
                  <button type="button" class="btn btn-default btn-danger"
                       onclick="modifyCart('subtract',${l.listingId})">
                    <span style="color: white" class="glyphicon glyphicon-minus"></span>
                  </button>

                <button style="cursor: text" class="btn disabled"><span><div class="common">${l.cartQuantity}</div></span></button>
                  <button type="button" class="btn btn-default btn-success"
                       onclick="modifyCart('add',${l.listingId})">
                    <span style="color: white" class="glyphicon glyphicon-plus"></span>
                  </button>
              </div>
            </td>
            <td id="price_${l.listingId}" class="invert"><div class="common">${l.pricePerUnit}&euro;</div></td>
            <td id="total_${l.listingId}" class="invert"><div class="common">${l.cartQuantity * l.pricePerUnit}&euro;</div></td>
            <td class="invert">
              <div class="rem">
                <button type="button"
                        class="btn btn-primary"
                        onclick="modifyCart('remove',${l.listingId})">
                  <span style="color: #ffffff" class="glyphicon glyphicon-minus"></span>
                </button>
              </div>
            </td>
          </tr>
        </c:forEach>
        </tbody>

      </table>

    </div>
    <div class="checkout-left">
      <div class="checkout-left-basket">
        <ul>
          <%--<li>Product1 <i>-</i> <span>$15.00 </span></li>--%>
          <%--<li>Product2 <i>-</i> <span>$25.00 </span></li>--%>
          <%--<li>Product3 <i>-</i> <span>$29.00 </span></li>--%>
          <li style="font-size: 22px">Total Price<i> :</i> <span>$${cart.totalPrice}</span></li>
        </ul>
        <a href="${pageContext.request.contextPath}/cart/checkout"><h4>Proceed to Checkout</h4></a>
        <button onclick="modifyCart('clear', -1)">Clear Cart</button>
      </div>
      <div class="checkout-right-basket">
        <a href="${pageContext.request.contextPath}/products">
          <span class="glyphicon glyphicon-menu-left"
                aria-hidden="true"></span>
          Continue Shopping
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

    function modifyCart(action, id) {
        $
            .post("${pageContext.request.contextPath}/cart/" + action + "/" + id)
            .always(location.reload())
    }

</script>

</body>
</html>