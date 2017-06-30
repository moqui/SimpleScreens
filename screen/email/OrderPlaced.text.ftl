<#list orderPartInfoList as orderPartInfo><#assign orderPart = orderPartInfo.orderPart><#assign contactInfo = orderPartInfo>

Order ${orderId} Part ${orderPart.orderPartSeqId}
Total ${ec.l10n.formatCurrency(orderPart.partTotal, orderHeader.currencyUomId)}
Placed on ${ec.l10n.format(orderHeader.placedDate, "dd MMM yyyy")}
Placed by ${(orderPartInfo.customerDetail.firstName)!""} ${(orderPartInfo.customerDetail.middleName)!""} ${(orderPartInfo.customerDetail.lastName)!""}
<#if orderPart.otherPartyOrderId?has_content>PO ${orderPart.otherPartyOrderId}</#if>

<#if orderPartInfo.shipmentMethodEnum?has_content>
Ship By ${orderPartInfo.shipmentMethodEnum.description}
</#if>
<#if contactInfo.postalAddress?has_content>
    <#if contactInfo.postalAddress.toName?has_content || contactInfo.postalAddress.attnName?has_content>
<#if contactInfo.postalAddress.toName?has_content>To: ${contactInfo.postalAddress.toName}</#if>
<#if contactInfo.postalAddress.attnName?has_content>Attn: ${contactInfo.postalAddress.attnName}</#if>
    <#else>
${(orderPartInfo.customerDetail.organizationName)!""}${(orderPartInfo.customerDetail.firstName)!""} ${(orderPartInfo.customerDetail.middleName)!""} ${(orderPartInfo.customerDetail.lastName)!""}
    </#if>
${(contactInfo.postalAddress.address1)!""}<#if contactInfo.postalAddress.unitNumber?has_content> #${contactInfo.postalAddress.unitNumber}</#if><#if contactInfo.postalAddress.address2?has_content>
${contactInfo.postalAddress.address2}</#if>
${contactInfo.postalAddress.city!""}, ${(contactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${contactInfo.postalAddress.postalCode!""}<#if contactInfo.postalAddress.postalCodeExt?has_content>-${contactInfo.postalAddress.postalCodeExt}</#if><#if contactInfo.postalAddress.countryGeoId?has_content> ${contactInfo.postalAddress.countryGeoId}</#if>
</#if>
<#if contactInfo.telecomNumber?has_content>
<#if contactInfo.telecomNumber.countryCode?has_content>${contactInfo.telecomNumber.countryCode}-</#if><#if contactInfo.telecomNumber.areaCode?has_content>${contactInfo.telecomNumber.areaCode}-</#if>${contactInfo.telecomNumber.contactNumber!""}
</#if>
<#if contactInfo.emailAddress?has_content>
${contactInfo.emailAddress}
</#if>

<#list orderPartInfo.partOrderItemList as orderItem>
<#assign itemTypeEnum = orderItem.findRelatedOne("ItemType#moqui.basic.Enumeration", true, false)>
<#assign orderItemTotalOut = ec.service.sync().name("mantle.order.OrderServices.get#OrderItemTotal").parameter("orderItem", orderItem).call()>
Item ${orderItem.orderItemSeqId}
Type: ${(itemTypeEnum.description)!""}
${orderItem.itemDescription!""}
Quantity: ${orderItem.quantity!"1"}
Amount: ${ec.l10n.formatCurrency(orderItem.unitAmount!0, orderHeader.currencyUomId)}
Total: ${ec.l10n.formatCurrency(orderItemTotalOut.itemTotal, orderHeader.currencyUomId)}
<#-- <#if orderItem.requiredByDate?has_content>Ship By ${ec.l10n.format(orderItem.requiredByDate, "dd MMM yyyy")}</#if> -->

</#list>
<#if orderPartInfo.orderPart.shippingInstructions?has_content>

Shipping Instructions

${orderPartInfo.orderPart.shippingInstructions}
</#if>
<#if orderPartInfo.orderPart.giftMessage?has_content>

Gift Message

${orderPartInfo.orderPart.giftMessage}
</#if>
</#list>
