<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html>
<head>
  <%@include file="../fragments/head.jspf" %>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/heart.css">
  <title>Products</title>
</head>

<body>

<%--Header--%>
<%@include file="../fragments/topbar.jspf" %>

<%
  List<String> path = new ArrayList<>(Collections.singletonList("Products"));
  pageContext.setAttribute("path", path);
%>

<%--Breadcrumbs--%>
<%@include file="../fragments/breadcrumbs.jspf" %>

<%--Products--%>
<div class="products">

  <div class="container">

    <div class="col-md-4 products-left">
      <div class="categories">
        <h2>Categories</h2>
        <ul class="cate">
          <c:forEach items="${categories}" var="c">
            <li><a href="${pageContext.request.contextPath}/products/${c.categoryId}">
              <i class="fa fa-arrow-right"
                 aria-hidden="true"></i>${c.categoryName}
            </a></li>
            <ul>
              <c:forEach items="${c.productsByCategoryId}" var="p">
                <li><a href="${pageContext.request.contextPath}/listings/${p.productId}">
                  <i class="fa fa-arrow-right"
                     aria-hidden="true"></i>${p.productName}
                </a></li>
              </c:forEach>
            </ul>
          </c:forEach>
        </ul>
      </div>
    </div>

    <div class="col-md-8 products-right">
      <div class="products-right-grid">
        <div class="products-right-grids">
          <div class="product-title">${selected}</div>
          <div class="clearfix"></div>
        </div>
      </div>

      <c:choose>
        <c:when test="${listings ne null and listings.size() > 0}">
          <c:forEach var="i" begin="0" end="${listings.size() - 1}">
            <c:if test="${i eq 0 or i mod 3 eq 0}">
              <div class="agile_top_brands_grids">
            </c:if>
            <div class="col-md-4 top_brand_left">
              <div class="hover14 column">
                <div class="agile_top_brand_left_grid">
                  <c:if test="${listings[i].productByProductId.discount > 1}">
                    <div class="agile_top_brand_left_grid_pos">
                      <img src="${pageContext.request.contextPath}/resources/images/offer.png" alt="offer" class="img-responsive">
                    </div>
                  </c:if>
                  <div class="agile_top_brand_left_grid1">
                    <figure>
                      <div class="snipcart-item block">
                        <div class="snipcart-thumb">
                          <a href="#"><img title=" " alt=" " src="<c:choose>
                              <c:when test="${listings[i].image ne null and listings[i].image.length() > 0}">
                                ${pageContext.request.contextPath}/listings/image/${listings[i].listingId}
                              </c:when>
                              <c:otherwise>
                                ${pageContext.request.contextPath}/products/image/${listings[i].productByProductId.productId}
                              </c:otherwise>
                            </c:choose>"></a>
                          <div style="color:#fe9126" class="product-name">${listings[i].listingName}<br>
                            <div style="color: #3399cc"> by ${listings[i].userByUserId.name}</div>
                          </div>
                          <fmt:formatNumber var="ppu" minFractionDigits="0" maxFractionDigits="2"
                                            value="${listings[i].pricePerUnit}"/>
                          <fmt:formatNumber var="discounted" minFractionDigits="0" maxFractionDigits="2"
                                            value="${ppu * ((100 - listings[i].productByProductId.discount) / 100)}"/>
                          <h4><c:choose><c:when test="${listings[i].productByProductId.discount > 1}">${discounted}</c:when><c:otherwise>${ppu}</c:otherwise></c:choose>&euro; <c:if test="${listings[i].productByProductId.discount > 1}">
                            <span>
                              ${ppu}&euro;
                            </span>
                          </c:if>
                            <div class="product-name" style="padding:0;margin-top:5px">per ${listings[i].productByProductId.unitByUnitId.unitName}</div>
                          </h4>
                        </div>
                        <div class="snipcart-details top_brand_home_details">
                          <form action="${pageContext.request.contextPath}/cart/add/${listings[i].listingId}"
                                method="post">
                            <fieldset>
                              <input type="button" onclick="addToCart(${listings[i].listingId})" name="submit"
                                     value="add to cart" class="button">
                            </fieldset>
                          </form>
                        </div>
                      </div>
                    </figure>
                  </div>
                </div>
              </div>
            </div>
            <c:if test="${i eq listings.size() - 1 or i mod 3 eq 2}">
              <div class="clearfix"></div>
              </div>
            </c:if>
          </c:forEach>
        </c:when>
        <c:when test="${products ne null and products.size() > 0}">
          <c:forEach var="i" begin="0" end="${products.size() - 1}">
            <c:if test="${i eq 0 or i mod 3 eq 0}">
              <div class="agile_top_brands_grids">
            </c:if>
            <div class="col-md-4 top_brand_left">
              <div class="hover14 column">
                <div class="agile_top_brand_left_grid">
                  <c:if test="${products[i].discount > 1}">
                    <div class="agile_top_brand_left_grid_pos">
                      <img src="${pageContext.request.contextPath}/resources/images/offer.png" alt=" " class="img-responsive">
                    </div>
                  </c:if>
                  <c:if test="${sessionScope.user ne null}">
                    <input id="_${products[i].productId}" class="heart-checkbox" type="checkbox"
                        <c:if test="${wishlist.contains(products[i])}">
                          checked
                        </c:if>
                    />
                    <label for="_${products[i].productId}" class="heart" onclick="toggleWish(${products[i].productId})">❤</label>
                  </c:if>
                  <div class="agile_top_brand_left_grid1">
                    <figure>
                      <div class="snipcart-item block">
                        <div class="snipcart-thumb">
                          <a href="${pageContext.request.contextPath}/listings/${products[i].productId}">
                            <img title=" " alt=" "
                                 src="${pageContext.request.contextPath}/products/image/${products[i].productId}">
                          </a>
                          <div class="product-name">${products[i].productName}</div>
                        </div>
                      </div>
                    </figure>
                  </div>
                </div>
              </div>
            </div>
            <c:if test="${i eq products.size() - 1 or i mod 3 eq 2}">
              <div class="clearfix"></div>
              </div>
            </c:if>
          </c:forEach>
        </c:when>
      </c:choose>

    </div>
    <div class="clearfix"></div>
  </div>
</div>
<%--//Products--%>

<%--Footer--%>
<%@include file="../fragments/footer.jspf" %>

<script>

    function addToCart(id) {
        window.event.stopPropagation();
        $.post("${pageContext.request.contextPath}/cart/add/" + id, (data) => {
            $("#cart_quantity").text(data);
        });
    }

    function toggleWish(productId) {
        // Stop Event Propagation
        let e = window.event;
        e.cancelBubble = true;
        if (e.stopPropagation) e.stopPropagation();

        $.post("${pageContext.request.contextPath}/wishlist/" + productId)
    }

</script>

</body>
</html>
