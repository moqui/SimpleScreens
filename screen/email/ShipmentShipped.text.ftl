
Shipment ${shipmentId}
<#list orderIdSet as orderId>
Order ${orderId}
</#list>
<#if invoiceList?has_content>
Invoice <#list invoiceList as invoice>${invoice.invoiceId}<#if invoice.otherPartyOrderId?has_content || invoice.referenceNumber?has_content> - PO ${invoice.otherPartyOrderId!invoice.referenceNumber}</#if><#sep>, </#list>
</#if>
<#if originFacility?has_content>Shipping from ${originFacility.facilityName}</#if>

<#if firstShipmentMethodEnum?has_content>Ship By ${firstShipmentMethodEnum.description}</#if>
<#if toContactInfo.postalAddress?has_content>
    <#if toContactInfo.postalAddress.toName?has_content || toContactInfo.postalAddress.attnName?has_content>
<#if toContactInfo.postalAddress.toName?has_content>To: ${toContactInfo.postalAddress.toName}</#if><#if toContactInfo.postalAddress.attnName?has_content>
Attn: ${toContactInfo.postalAddress.attnName}</#if>
    <#else>
${(toPartyDetail.organizationName)!""} ${(toPartyDetail.firstName)!""} ${(toPartyDetail.middleName)!""} ${(toPartyDetail.lastName)!""}
    </#if>
${(toContactInfo.postalAddress.address1)!""}<#if toContactInfo.postalAddress.unitNumber?has_content> #${toContactInfo.postalAddress.unitNumber}</#if><#if toContactInfo.postalAddress.address2?has_content>
${toContactInfo.postalAddress.address2}</#if>
${toContactInfo.postalAddress.city!""}, ${(toContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${toContactInfo.postalAddress.postalCode!""}<#if toContactInfo.postalAddress.postalCodeExt?has_content>-${toContactInfo.postalAddress.postalCodeExt}</#if><#if toContactInfo.postalAddress.countryGeoId?has_content> ${toContactInfo.postalAddress.countryGeoId}</#if>
</#if>
<#if toContactInfo.telecomNumber?has_content>
<#if toContactInfo.telecomNumber.countryCode?has_content>${toContactInfo.telecomNumber.countryCode}-</#if><#if toContactInfo.telecomNumber.areaCode?has_content>${toContactInfo.telecomNumber.areaCode}-</#if>${toContactInfo.telecomNumber.contactNumber!""}
</#if>
<#if toContactInfo.emailAddress?has_content>
${toContactInfo.emailAddress}
</#if>

<#list shipmentPackageList as shipmentPackage>
<#-- <#assign shipmentBoxType = shipmentPackage.boxType!> -->
    <#assign weightUom = shipmentPackage.weightUom!>
    <#assign shipmentPackageContentList = shipmentPackage.contents>
    <#assign packageRouteSeg = ec.entity.find("mantle.shipment.ShipmentPackageRouteSeg").condition("shipmentId", shipmentId).condition("shipmentPackageSeqId", shipmentPackage.shipmentPackageSeqId).condition("shipmentRouteSegmentSeqId", firstRouteSegment.shipmentRouteSegmentSeqId).one()!>
Package ${shipmentPackage.shipmentPackageSeqId}<#if shipmentPackage.weight?has_content>
Weight ${ec.l10n.format(shipmentPackage.weight, "")} ${(weightUom.description)!""}</#if>
Tracking ${(firstCarrierDetail.organizationName)!""} ${(packageRouteSeg.trackingCode)!"N/A"}

<#list shipmentPackageContentList as shipmentPackageContent>
    <#assign product = shipmentPackageContent.product>
Description: ${product.productName!shipmentPackageContent.productId}
Quantity: ${shipmentPackageContent.quantity}
</#list>
</#list>
<#if shipment.handlingInstructions?has_content>
Shipping Instructions

${shipment.handlingInstructions}
</#if>
