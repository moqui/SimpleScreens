<#list orderPartInfoList as orderPartInfo>
    <#assign orderPart = orderPartInfo.orderPart>
    <#assign contactInfo = orderPartInfo>

    <table border="0" cellpadding="8px" cellspacing="0" width="100%"><tr>
        <td width="50%">
            <h3>Order ${orderId} Part ${orderPart.orderPartSeqId}</h3>
            <h4>Total ${ec.l10n.formatCurrency(orderPart.partTotal, orderHeader.currencyUomId)}</h4>
            <h4>Placed on ${ec.l10n.format(orderHeader.placedDate, "dd MMM yyyy")}</h4>
        </td>
        <td width="50%">
            <#if orderPartInfo.shipmentMethodEnum?has_content>
                <strong>Ship By</strong> ${orderPartInfo.shipmentMethodEnum.description}<br/>
            </#if>
            <strong>${(orderPartInfo.customerDetail.firstName)!""} ${(orderPartInfo.customerDetail.middleName)!""} ${(orderPartInfo.customerDetail.lastName)!""}</strong><br/>
            <#if contactInfo.postalAddress?has_content>
                ${(contactInfo.postalAddress.address1)!""}<#if contactInfo.postalAddress.unitNumber?has_content> #${contactInfo.postalAddress.unitNumber}</#if><br/>
                <#if contactInfo.postalAddress.address2?has_content>${contactInfo.postalAddress.address2}<br/></#if>
                ${contactInfo.postalAddress.city!""}, ${(contactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${contactInfo.postalAddress.postalCode!""}<#if contactInfo.postalAddress.postalCodeExt?has_content>-${contactInfo.postalAddress.postalCodeExt}</#if><#if contactInfo.postalAddress.countryGeoId?has_content> ${contactInfo.postalAddress.countryGeoId}</#if><br/>
            </#if>
            <#if contactInfo.telecomNumber?has_content>
                <#if contactInfo.telecomNumber.countryCode?has_content>${contactInfo.telecomNumber.countryCode}-</#if><#if contactInfo.telecomNumber.areaCode?has_content>${contactInfo.telecomNumber.areaCode}-</#if>${contactInfo.telecomNumber.contactNumber!""}<br/>
            </#if>
            <#if contactInfo.emailAddress?has_content>
                ${contactInfo.emailAddress}<br/>
            </#if>
        </td>
    </tr></table>
    <table border="0" cellpadding="8px" cellspacing="0" width="100%">
        <tr>
            <td align="center"><strong>Item</strong></td>
            <td><strong>Type</strong></td>
            <td><strong>Description</strong></td>
            <#-- <td><strong>Ship By</strong></td> -->
            <td align="center"><strong>Qty</strong></td>
            <td align="right"><strong>Amount</strong></td>
            <td align="right"><strong>Total</strong></td>
        </tr>
        <#list orderPartInfo.partOrderItemList as orderItem>
            <#assign itemTypeEnum = orderItem.findRelatedOne("ItemType#moqui.basic.Enumeration", true, false)>
            <#assign orderItemTotalOut = ec.service.sync().name("mantle.order.OrderServices.get#OrderItemTotal").parameter("orderItem", orderItem).call()>
            <tr>
                <td align="center">${orderItem.orderItemSeqId}</td>
                <td>${(itemTypeEnum.description)!""}</td>
                <td>${orderItem.itemDescription!""}</td>
                <#-- <td>${ec.l10n.format(orderItem.requiredByDate, "dd MMM yyyy")}</td> -->
                <td align="center">${orderItem.quantity!"1"}</td>
                <td align="right">${ec.l10n.formatCurrency(orderItem.unitAmount!0, orderHeader.currencyUomId)}</td>
                <td align="right">${ec.l10n.formatCurrency(orderItemTotalOut.itemTotal, orderHeader.currencyUomId)}</td>
            </tr>
        </#list>
    </table>

    <#if orderPartInfo.orderPart.shippingInstructions?has_content>
        <strong>Shipping Instructions</strong><br/>
        ${orderPartInfo.orderPart.shippingInstructions}<br/>
    </#if>
    <#if orderPartInfo.orderPart.giftMessage?has_content>
        <strong>Gift Message</strong><br/>
        ${orderPartInfo.orderPart.giftMessage}<br/>
    </#if>
</#list>
