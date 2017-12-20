<table border="0" cellpadding="8px" cellspacing="0" width="100%"><tr>
    <td width="50%">
        <h1>Shipment ${shipmentId}</h1>
        <#if detailLinkPath?has_content><#list orderIdSet as orderId>
            <h2><a href="<#if detailLinkPath?starts_with("http")>${detailLinkPath}<#else>http://${storeDomain}/${detailLinkPath}</#if>?orderId=${orderId}">Order ${orderId}</a></h2><br/>
        </#list></#if>
        <#if invoiceList?has_content>
            <h3>Invoice <#list invoiceList as invoice>${invoice.invoiceId}<#if invoice.otherPartyOrderId?has_content || invoice.referenceNumber?has_content> - PO ${invoice.otherPartyOrderId!invoice.referenceNumber}</#if><#sep>, </#list></h3>
        </#if>
        <#if originFacility?has_content><h4>Shipping from ${originFacility.facilityName}</h4></#if>
    </td>
    <td width="50%">
    <#if firstShipmentMethodEnum?has_content><strong>Ship By</strong> ${firstShipmentMethodEnum.description}<br/></#if>
    <#if toContactInfo.postalAddress?has_content>
        <#if toContactInfo.postalAddress.toName?has_content || toContactInfo.postalAddress.attnName?has_content>
            <#if toContactInfo.postalAddress.toName?has_content><strong>To: ${toContactInfo.postalAddress.toName}</strong><br/></#if>
            <#if toContactInfo.postalAddress.attnName?has_content><strong>Attn: ${toContactInfo.postalAddress.attnName}</strong><br/></#if>
        <#else>
            <strong>${(toPartyDetail.organizationName)!""} ${(toPartyDetail.firstName)!""} ${(toPartyDetail.middleName)!""} ${(toPartyDetail.lastName)!""}</strong><br/>
        </#if>
    ${(toContactInfo.postalAddress.address1)!""}<#if toContactInfo.postalAddress.unitNumber?has_content> #${toContactInfo.postalAddress.unitNumber}</#if><br/>
        <#if toContactInfo.postalAddress.address2?has_content>${toContactInfo.postalAddress.address2}<br/></#if>
    ${toContactInfo.postalAddress.city!""}, ${(toContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${toContactInfo.postalAddress.postalCode!""}<#if toContactInfo.postalAddress.postalCodeExt?has_content>-${toContactInfo.postalAddress.postalCodeExt}</#if><#if toContactInfo.postalAddress.countryGeoId?has_content> ${toContactInfo.postalAddress.countryGeoId}</#if><br/>
    </#if>
    <#if toContactInfo.telecomNumber?has_content>
        <#if toContactInfo.telecomNumber.countryCode?has_content>${toContactInfo.telecomNumber.countryCode}-</#if><#if toContactInfo.telecomNumber.areaCode?has_content>${toContactInfo.telecomNumber.areaCode}-</#if>${toContactInfo.telecomNumber.contactNumber!""}<br/>
    </#if>
    <#if toContactInfo.emailAddress?has_content>
        ${toContactInfo.emailAddress}<br/>
    </#if>
    </td>
</tr></table>

<#list shipmentPackageList as shipmentPackage>
    <#-- <#assign shipmentBoxType = shipmentPackage.boxType!> -->
    <#assign weightUom = shipmentPackage.weightUom!>
    <#assign shipmentPackageContentList = shipmentPackage.contents>
    <#assign packageRouteSeg = ec.entity.find("mantle.shipment.ShipmentPackageRouteSeg").condition("shipmentId", shipmentId).condition("shipmentPackageSeqId", shipmentPackage.shipmentPackageSeqId).condition("shipmentRouteSegmentSeqId", firstRouteSegment.shipmentRouteSegmentSeqId).one()!>
    <h2>Package ${shipmentPackage.shipmentPackageSeqId}</h2>

    <#if shipmentPackage.weight?has_content>Weight ${ec.l10n.format(shipmentPackage.weight, "")} ${(weightUom.description)!""}<br/></#if>
    <strong>Tracking ${(firstCarrierDetail.pseudoId)!""} ${(packageRouteSeg.trackingCode)!"N/A"}</strong><br/>

    <table border="0" cellpadding="8px" cellspacing="0" width="100%">
        <tr>
            <td><strong>Description</strong></td>
            <td align="right"><strong>Quantity</strong></td>
        </tr>
        <#list shipmentPackageContentList as shipmentPackageContent>
            <#assign product = shipmentPackageContent.product>
            <tr>
                <td>${product.productName!shipmentPackageContent.productId}</td>
                <td align="right">${shipmentPackageContent.quantity}</td>
            </tr>
        </#list>
    </table>
</#list>
<#if shipment.handlingInstructions?has_content>
    <strong>Shipping Instructions</strong><br/>
    ${shipment.handlingInstructions}<br/>
</#if>
