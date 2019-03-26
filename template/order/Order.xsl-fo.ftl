<#--
This software is in the public domain under CC0 1.0 Universal plus a Grant of Patent License.

To the extent possible under law, the author(s) have dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide. This software is distributed without any
warranty.

You should have received a copy of the CC0 Public Domain Dedication
along with this software (see the LICENSE.md file). If not, see
<http://creativecommons.org/publicdomain/zero/1.0/>.
-->

<#-- See the mantle.order.OrderInfoServices.get#OrderDisplayInfo service for data preparation -->

<#assign cellPadding = "1pt">
<#assign dateFormat = "dd MMM yyyy">
<#macro encodeText textValue>${Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(textValue!"", false)}</#macro>

<#assign firstPartInfo = orderPartInfoList?first>
<#if showUpc?has_content><#assign showUpc = (showUpc == "true")><#else><#assign showUpc = firstPartInfo.isCustomerInternalOrg></#if>


<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Helvetica, sans-serif" font-size="10pt">
    <fo:layout-master-set>
        <fo:simple-page-master master-name="letter-portrait" page-width="8.5in" page-height="11in"
                               margin-top="0.5in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
            <fo:region-body margin-top="1.2in" margin-bottom="0.6in"/>
            <fo:region-before extent="1.2in"/>
            <fo:region-after extent="0.5in"/>
        </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="letter-portrait" id="mainSequence">
        <fo:static-content flow-name="xsl-region-before">
            <fo:block font-size="14pt" text-align="center" margin-bottom="0.1in"><#if firstPartInfo.isCustomerInternalOrg>Purchase<#else>Sales</#if> Order #${orderId}</fo:block>
            <fo:table table-layout="fixed" margin-bottom="0.1in" width="7.5in">
                <fo:table-body><fo:table-row>
                    <fo:table-cell padding="3pt" width="3.75in">
                        <fo:block font-weight="bold">Vendor</fo:block>
                        <fo:block><@encodeText (firstPartInfo.vendorDetail.organizationName)!""/><@encodeText (firstPartInfo.vendorDetail.firstName)!""/> <@encodeText (firstPartInfo.vendorDetail.lastName)!""/></fo:block>
                        <fo:block font-weight="bold">Customer</fo:block>
                        <fo:block><@encodeText (firstPartInfo.customerDetail.organizationName)!""/><@encodeText (firstPartInfo.customerDetail.firstName)!""/> <@encodeText (firstPartInfo.customerDetail.lastName)!""/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt" width="2in">
                        <fo:block font-weight="bold">Date</fo:block>
                        <fo:block><#if orderHeader.placedDate??>${ec.l10n.format(orderHeader.placedDate, dateFormat)}<#else>Not yet placed</#if></fo:block>
                        <fo:block font-weight="bold">Total</fo:block>
                        <fo:block>${ec.l10n.formatCurrency(orderHeader.grandTotal, orderHeader.currencyUomId)}</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt" width="1.75in">
                        <fo:block text-align="right">
                            <fo:instream-foreign-object>
                                <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="${orderId}">
                                    <barcode:code128>
                                        <barcode:height>0.4in</barcode:height>
                                        <barcode:module-width>0.3mm</barcode:module-width>
                                    </barcode:code128>
                                    <barcode:human-readable>
                                        <barcode:placement>bottom</barcode:placement>
                                        <barcode:font-name>Helvetica</barcode:font-name>
                                        <barcode:font-size>12pt</barcode:font-size>
                                        <barcode:display-start-stop>false</barcode:display-start-stop>
                                        <barcode:display-checksum>false</barcode:display-checksum>
                                    </barcode:human-readable>
                                </barcode:barcode>
                            </fo:instream-foreign-object>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row></fo:table-body>
            </fo:table>
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after" font-size="8pt">
            <fo:block border-top="thin solid black">
                <#-- TODO: show vendor's contact info (customer service or billing address, phone, email)? -->
                <fo:block text-align="center">Order #${orderId} -- <#if orderHeader.placedDate??>${ec.l10n.format(orderHeader.placedDate, "dd MMM yyyy")}<#else>Not yet placed</#if> -- Page <fo:page-number/></fo:block>
            </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">

            <#list orderPartInfoList as orderPartInfo>
                <#assign orderPart = orderPartInfo.orderPart>
                <#if orderPartInfo.isCustomerInternalOrg><#assign contactInfo = orderPartInfo.facilityContactInfo>
                    <#else><#assign contactInfo = orderPartInfo></#if>

                <fo:table table-layout="fixed" margin-bottom="0.1in" width="7.5in">
                    <fo:table-body><fo:table-row>
                        <fo:table-cell padding="3pt" width="2in">
                            <fo:block font-weight="bold">Order Part #</fo:block>
                            <fo:block>${orderPart.orderPartSeqId}</fo:block>
                            <fo:block font-weight="bold">Part Total</fo:block>
                            <fo:block>${ec.l10n.formatCurrency(orderPart.partTotal, orderHeader.currencyUomId)}</fo:block>
                            <#if orderPart.otherPartyOrderId?has_content>
                                <fo:block font-weight="bold"><#if orderPartInfo.isVendorInternalOrg>Customer<#else>Vendor</#if> Order #</fo:block>
                                <fo:block>${orderPart.otherPartyOrderId}</fo:block>
                            </#if>
                        </fo:table-cell>
                        <fo:table-cell padding="3pt" width="2in">
                            <#if orderPartInfo.shipmentMethodEnum?has_content>
                                <fo:block font-weight="bold">Ship By</fo:block>
                                <fo:block><@encodeText orderPartInfo.shipmentMethodEnum.description/></fo:block>
                            </#if>
                            <#if orderPart.shipAfterDate??>
                                <fo:block font-weight="bold">Ship After</fo:block>
                                <fo:block>${ec.l10n.format(orderPart.shipAfterDate, dateFormat)}</fo:block>
                            </#if>
                            <#if orderPart.shipBeforeDate??>
                                <fo:block font-weight="bold">Ship Before</fo:block>
                                <fo:block>${ec.l10n.format(orderPart.shipBeforeDate, dateFormat)}</fo:block>
                            </#if>
                            <#if orderPart.estimatedShipDate??>
                                <fo:block font-weight="bold">Estimated Ship</fo:block>
                                <fo:block>${ec.l10n.format(orderPart.estimatedShipDate, dateFormat)}</fo:block>
                            </#if>
                            <#if orderPart.estimatedDeliveryDate??>
                                <fo:block font-weight="bold">Estimated Delivery</fo:block>
                                <fo:block>${ec.l10n.format(orderPart.estimatedDeliveryDate, dateFormat)}</fo:block>
                            </#if>
                            <#if orderPart.estimatedPickUpDate??>
                                <fo:block font-weight="bold">Estimated Pick Up</fo:block>
                                <fo:block>${ec.l10n.format(orderPart.estimatedPickUpDate, dateFormat)}</fo:block>
                            </#if>
                        </fo:table-cell>
                        <fo:table-cell padding="3pt" font-size="10pt" width="3.5in">
                            <fo:block font-weight="bold">Ship To</fo:block>
                            <#if contactInfo.postalAddress?has_content>
                                <#if contactInfo.postalAddress.toName?has_content || contactInfo.postalAddress.attnName?has_content>
                                    <#if contactInfo.postalAddress.toName?has_content><fo:block font-weight="bold">To: <@encodeText contactInfo.postalAddress.toName/></fo:block></#if>
                                    <#if contactInfo.postalAddress.attnName?has_content><fo:block font-weight="bold">Attn: <@encodeText contactInfo.postalAddress.attnName/></fo:block></#if>
                                <#else>
                                    <fo:block font-weight="bold"><@encodeText orderPartInfo.customerDetail.organizationName!""/> <@encodeText (orderPartInfo.customerDetail.firstName)!""/> <@encodeText (orderPartInfo.customerDetail.middleName)!""/> <@encodeText (orderPartInfo.customerDetail.lastName)!""/></fo:block>
                                </#if>
                                <fo:block><@encodeText (contactInfo.postalAddress.address1)!""/><#if contactInfo.postalAddress.unitNumber?has_content> #<@encodeText contactInfo.postalAddress.unitNumber/></#if></fo:block>
                                <#if contactInfo.postalAddress.address2?has_content><fo:block><@encodeText contactInfo.postalAddress.address2/></fo:block></#if>
                                <fo:block><@encodeText contactInfo.postalAddress.city!""/>, ${(contactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${contactInfo.postalAddress.postalCode!""}<#if contactInfo.postalAddress.postalCodeExt?has_content>-${contactInfo.postalAddress.postalCodeExt}</#if><#if contactInfo.postalAddress.countryGeoId?has_content> ${contactInfo.postalAddress.countryGeoId}</#if></fo:block>
                            </#if>
                            <#if contactInfo.telecomNumber?has_content>
                                <fo:block><#if contactInfo.telecomNumber.countryCode?has_content>${contactInfo.telecomNumber.countryCode}-</#if><#if contactInfo.telecomNumber.areaCode?has_content>${contactInfo.telecomNumber.areaCode}-</#if>${contactInfo.telecomNumber.contactNumber!""}</fo:block>
                            </#if>
                            <#if contactInfo.emailAddress?has_content>
                                <fo:block>${contactInfo.emailAddress}</fo:block>
                            </#if>
                            <#--
                            <#if orderPartInfo.facility?has_content>
                                <fo:block><@encodeText ec.resource.expand("FacilityNameTemplate", "", orderPartInfo.facility)/></fo:block>
                            </#if>
                            -->
                        </fo:table-cell>
                    </fo:table-row></fo:table-body>
                </fo:table>

                <fo:table table-layout="fixed" width="100%">
                    <fo:table-header font-size="9pt" border-bottom="solid black">
                        <fo:table-cell width="0.3in" padding="${cellPadding}"><fo:block text-align="center">Item</fo:block></fo:table-cell>
                        <#if !showUpc><fo:table-cell width="1in" padding="${cellPadding}"><fo:block>Type</fo:block></fo:table-cell></#if>
                        <fo:table-cell width="2.8in" padding="${cellPadding}"><fo:block>Description</fo:block></fo:table-cell>
                        <#if showUpc><fo:table-cell width="1in" padding="${cellPadding}"><fo:block>UPC</fo:block></fo:table-cell></#if>
                        <fo:table-cell width="0.8in" padding="${cellPadding}"><fo:block>Required By</fo:block></fo:table-cell>
                        <fo:table-cell width="0.6in" padding="${cellPadding}"><fo:block text-align="center">Qty</fo:block></fo:table-cell>
                        <fo:table-cell width="0.9in" padding="${cellPadding}"><fo:block text-align="right">Amount</fo:block></fo:table-cell>
                        <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="right">Total</fo:block></fo:table-cell>
                    </fo:table-header>
                    <fo:table-body>
                        <#list orderPartInfo.partOrderItemList as orderItem>
                            <#assign isProductItem = orderItem.productId?has_content && (!productItemTypes?? || productItemTypes.contains(orderItem.itemTypeEnumId))>
                            <#assign itemTypeEnum = orderItem.findRelatedOne("ItemType#moqui.basic.Enumeration", true, false)>
                            <#assign orderItemTotalOut = ec.service.sync().name("mantle.order.OrderServices.get#OrderItemTotal").parameter("orderItem", orderItem).call()>
                            <#assign itemUpc = "">
                            <#if showUpc && isProductItem>
                                <#assign productIdentification = ec.entity.find("mantle.product.ProductIdentification").condition("productId", orderItem.productId).condition("productIdTypeEnumId", "PidtUpca").useCache(true).one()!>
                                <#if !productIdentification?has_content><#assign productIdentification = ec.entity.find("mantle.product.ProductIdentification").condition("productId", orderItem.productId).condition("productIdTypeEnumId", "PidtUpce").useCache(true).one()!></#if>
                                <#assign itemUpc = (productIdentification.idValue)!"">
                            </#if>
                            <fo:table-row font-size="8pt" border-bottom="thin solid black"<#if !orderItem.parentItemSeqId?has_content> font-weight="bold"</#if>>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="<#if !orderItem.parentItemSeqId?has_content>center<#else>right</#if>">${orderItem.orderItemSeqId}</fo:block></fo:table-cell>
                                <#if !showUpc><fo:table-cell padding="${cellPadding}"><fo:block><@encodeText (itemTypeEnum.description)!""/></fo:block></fo:table-cell></#if>
                                <fo:table-cell padding="${cellPadding}">
                                    <fo:block><@encodeText orderItem.itemDescription!""/></fo:block>
                                    <#if isProductItem>
                                        <#assign product = ec.entity.find("mantle.product.Product").condition("productId", orderItem.productId).useCache(true).one()>
                                        <fo:block><@encodeText ec.resource.expand("ProductNameTemplate", "", product)/></fo:block>
                                    </#if>
                                </fo:table-cell>
                                <#if showUpc><fo:table-cell padding="${cellPadding}"><fo:block><@encodeText itemUpc!""/></fo:block></fo:table-cell></#if>
                                <fo:table-cell padding="${cellPadding}"><fo:block>${ec.l10n.format(orderItem.requiredByDate, dateFormat)}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${orderItem.quantity!"1"}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(orderItem.unitAmount!0, orderHeader.currencyUomId, 2)}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(orderItemTotalOut.itemTotal, orderHeader.currencyUomId, 2)}</fo:block></fo:table-cell>
                            </fo:table-row>
                        </#list>
                        <fo:table-row font-size="9pt" border-top="solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">Total</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(orderPart.partTotal, orderHeader.currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>

                <#if orderPartInfo.orderPart.shippingInstructions?has_content>
                    <#-- <fo:block margin-top="0.2in" font-weight="bold">Shipping Instructions</fo:block> -->
                    <fo:block margin-top="0.2in" linefeed-treatment="preserve"><@encodeText orderPartInfo.orderPart.shippingInstructions/></fo:block>
                </#if>
                <#if orderPartInfo.orderPart.giftMessage?has_content>
                    <fo:block margin-top="0.2in" font-weight="bold">Gift Message</fo:block>
                    <fo:block linefeed-treatment="preserve"><@encodeText orderPartInfo.orderPart.giftMessage/></fo:block>
                </#if>
                <#if orderPartInfo.isCustomerInternalOrg>
                    <#-- signature line -->
                    <fo:block-container width="3in" margin-top="0.5in" border-top="solid black">
                        <fo:block><@encodeText (firstPartInfo.customerDetail.organizationName)!""/><@encodeText (firstPartInfo.customerDetail.firstName)!""/> <@encodeText (firstPartInfo.customerDetail.lastName)!""/></fo:block>
                    </fo:block-container>
                </#if>
            </#list>
        </fo:flow>
    </fo:page-sequence>
</fo:root>
