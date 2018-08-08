<#assign dateFormat = dateFormat!"dd MMM yyyy">

Invoice ${invoiceId}
<#if (finalizedStatusHistoryList?size > 1)>
AMENDED ${ec.l10n.format(finalizedStatusHistoryList.get(0).changedDate, dateFormat)} (previous ${ec.l10n.format(finalizedStatusHistoryList.get(1).changedDate, dateFormat)})
</#if>
<#list orderIdSet as orderId>
For Order ${orderId}
</#list>
Invoice Date ${ec.l10n.format(invoice.invoiceDate, dateFormat)}
Customer # ${toParty.pseudoId}
<#if invoice.referenceNumber?has_content>Ref # ${invoice.referenceNumber?html}</#if>
<#if invoice.otherPartyOrderId?has_content>Your Order ${invoice.otherPartyOrderId?html}</#if>

<#if unpaidTotal == 0>
PAID IN FULL
<#else>
Balance Due ${ec.l10n.formatCurrency(unpaidTotal, invoice.currencyUomId)}
</#if>
<#if unpaidTotal != 0>
    <#if invoice.dueDate??>
Due Date ${ec.l10n.format(invoice.dueDate, dateFormat)}
    </#if>
    <#if settlementTerm?has_content>
Term: ${settlementTerm.description}
    </#if>
</#if>

<#if fromContactInfo.postalAddress?has_content>
    <#if fromContactInfo.postalAddress.toName?has_content || fromContactInfo.postalAddress.attnName?has_content>
<#if fromContactInfo.postalAddress.toName?has_content>To: ${fromContactInfo.postalAddress.toName}</#if><#if fromContactInfo.postalAddress.attnName?has_content>
Attn: ${fromContactInfo.postalAddress.attnName}</#if>
    <#else>
${(fromParty.organizationName)!""} ${(fromParty.firstName)!""} ${(fromParty.middleName)!""} ${(fromParty.lastName)!""}
    </#if>
${(fromContactInfo.postalAddress.address1)!""}<#if fromContactInfo.postalAddress.unitNumber?has_content> #${fromContactInfo.postalAddress.unitNumber}</#if><#if fromContactInfo.postalAddress.address2?has_content>
${fromContactInfo.postalAddress.address2}</#if>
${fromContactInfo.postalAddress.city!""}, ${(fromContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${fromContactInfo.postalAddress.postalCode!""}<#if fromContactInfo.postalAddress.postalCodeExt?has_content>-${fromContactInfo.postalAddress.postalCodeExt}</#if><#if fromContactInfo.postalAddress.countryGeoId?has_content> ${fromContactInfo.postalAddress.countryGeoId}</#if>
</#if>
<#if fromContactInfo.telecomNumber?has_content>
<#if fromContactInfo.telecomNumber.countryCode?has_content>Tel: ${fromContactInfo.telecomNumber.countryCode}-</#if><#if fromContactInfo.telecomNumber.areaCode?has_content>${fromContactInfo.telecomNumber.areaCode}-</#if>${fromContactInfo.telecomNumber.contactNumber!""}
</#if>
<#if fromContactInfo.faxTelecomNumber?has_content>
<#if fromContactInfo.faxTelecomNumber.countryCode?has_content>Fax: ${fromContactInfo.faxTelecomNumber.countryCode}-</#if><#if fromContactInfo.faxTelecomNumber.areaCode?has_content>${fromContactInfo.faxTelecomNumber.areaCode}-</#if>${fromContactInfo.faxTelecomNumber.contactNumber!""}
</#if>
<#if fromContactInfo.emailAddress?has_content>
${fromContactInfo.emailAddress}
</#if>

<#if invoice.invoiceMessage?has_content>
${invoice.invoiceMessage}
</#if>
