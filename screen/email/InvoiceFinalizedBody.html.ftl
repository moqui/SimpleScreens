<#assign dateFormat = dateFormat!"dd MMM yyyy">
<table border="0" cellpadding="8px" cellspacing="0" width="100%"><tr>
    <td width="50%">
        <h1>Invoice ${invoiceId}</h1><br/>
        <#if (finalizedStatusHistoryList?size > 1)>
            <h4>AMENDED ${ec.l10n.format(finalizedStatusHistoryList.get(0).changedDate, dateFormat)} (previous ${ec.l10n.format(finalizedStatusHistoryList.get(1).changedDate, dateFormat)})</h4>
        </#if>
        <#if detailLinkPath?has_content>
            <#list orderIdSet as orderId>
            <strong><a href="<#if detailLinkPath?starts_with("http")>${detailLinkPath}<#else>http://${storeDomain}/${detailLinkPath}</#if>?orderId=${orderId}">For Order ${orderId}</a></strong><br/>
            </#list>
        <#else>
            <#list orderIdSet as orderId><strong>For Order ${orderId}</strong><br/></#list>
        </#if>
        <strong>Invoice Date</strong> ${ec.l10n.format(invoice.invoiceDate, dateFormat)}<br/>
        <strong>Customer #</strong> ${toParty.pseudoId}<br/>
        <#if invoice.referenceNumber?has_content><strong>Ref #</strong> ${invoice.referenceNumber?html}<br/></#if>
        <#if invoice.otherPartyOrderId?has_content><strong>Your Order</strong> ${invoice.otherPartyOrderId?html}<br/></#if>
        <br/>
        <#if unpaidTotal == 0>
            <strong>PAID IN FULL</strong><br/>
        <#else>
            <strong>Balance Due</strong> ${ec.l10n.formatCurrency(unpaidTotal, invoice.currencyUomId)}<br/>
        </#if>
        <#if unpaidTotal != 0>
            <#if invoice.dueDate??>
                <strong>Due Date</strong> ${ec.l10n.format(invoice.dueDate, dateFormat)}<br/>
            </#if>
            <#if settlementTerm?has_content>
                <strong>Term</strong> ${settlementTerm.description?html}<br/>
            </#if>
        </#if>
    </td>
    <td width="50%">
    <#if fromContactInfo.postalAddress?has_content>
        <#if fromContactInfo.postalAddress.toName?has_content || fromContactInfo.postalAddress.attnName?has_content>
            <#if fromContactInfo.postalAddress.toName?has_content><strong>To: ${fromContactInfo.postalAddress.toName}</strong><br/></#if>
            <#if fromContactInfo.postalAddress.attnName?has_content><strong>Attn: ${fromContactInfo.postalAddress.attnName}</strong><br/></#if>
        <#else>
            <strong>${(fromParty.organizationName)!""} ${(fromParty.firstName)!""} ${(fromParty.middleName)!""} ${(fromParty.lastName)!""}</strong><br/>
        </#if>
    ${(fromContactInfo.postalAddress.address1)!""}<#if fromContactInfo.postalAddress.unitNumber?has_content> #${fromContactInfo.postalAddress.unitNumber}</#if><br/>
        <#if fromContactInfo.postalAddress.address2?has_content>${fromContactInfo.postalAddress.address2}<br/></#if>
    ${fromContactInfo.postalAddress.city!""}, ${(fromContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${fromContactInfo.postalAddress.postalCode!""}<#if fromContactInfo.postalAddress.postalCodeExt?has_content>-${fromContactInfo.postalAddress.postalCodeExt}</#if><#if fromContactInfo.postalAddress.countryGeoId?has_content> ${fromContactInfo.postalAddress.countryGeoId}</#if><br/>
    </#if>
    <#if fromContactInfo.telecomNumber?has_content>
        <#if fromContactInfo.telecomNumber.countryCode?has_content>Tel: ${fromContactInfo.telecomNumber.countryCode}-</#if><#if fromContactInfo.telecomNumber.areaCode?has_content>${fromContactInfo.telecomNumber.areaCode}-</#if>${fromContactInfo.telecomNumber.contactNumber!""}<br/>
    </#if>
    <#if fromContactInfo.faxTelecomNumber?has_content>
        <#if fromContactInfo.faxTelecomNumber.countryCode?has_content>Fax: ${fromContactInfo.faxTelecomNumber.countryCode}-</#if><#if fromContactInfo.faxTelecomNumber.areaCode?has_content>${fromContactInfo.faxTelecomNumber.areaCode}-</#if>${fromContactInfo.faxTelecomNumber.contactNumber!""}<br/>
    </#if>
    <#if fromContactInfo.emailAddress?has_content>
        ${fromContactInfo.emailAddress}<br/>
    </#if>
    </td>
</tr></table>

<strong>See details in attachment.</strong><br/><br/>

<#if invoice.invoiceMessage?has_content>
    ${invoice.invoiceMessage?html}<br/>
</#if>
