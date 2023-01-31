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

<#-- See the mantle.account.InvoiceServices.get#InvoicePrintInfo service for data preparation -->

<#assign cellPadding = "1pt">
<#assign dateFormat = dateFormat!"dd MMM yyyy">
<#assign negOne = -1>
<#if original! == "true"><#assign showOrig = true><#else><#assign showOrig = false></#if>

<#macro encodeText textValue>${(Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(textValue!"", false))!""}</#macro>
<#macro productItemRow invoiceItem invoiceItemList itemIndex>
    <#assign childItemList = invoiceItemList.cloneList().filterByAnd("parentItemSeqId", invoiceItem.invoiceItemSeqId)>
    <#assign itemTypeEnum = invoiceItem.type!>
    <#assign product = invoiceItem.product!>
    <#assign asset = invoiceItem.asset!>
    <#assign lot = asset.lot!>
    <fo:table-row font-size="8pt" border-bottom="thin solid black">
        <fo:table-cell padding="${cellPadding}"><fo:block text-align="center"><#if (itemIndex > 0)>${itemIndex}<#else> </#if></fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block><@encodeText (product.pseudoId)!(invoiceItem.productId)!""/></fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block><@encodeText (lot.lotNumber)!(asset.lotId)!""/></fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}">
            <fo:block><@encodeText (invoiceItem.description)!(itemTypeEnum.description)!""/></fo:block>
            <#if invoiceItem.otherPartyProductId?has_content><fo:block>Your Product: <@encodeText invoiceItem.otherPartyProductId/></fo:block></#if>
        </fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${invoiceItem.quantity!"1"}</fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(invoiceItem.amount!0, invoice.currencyUomId, 3)}</fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(((invoiceItem.quantity!1) * (invoiceItem.amount!0)), invoice.currencyUomId, 3)}</fo:block></fo:table-cell>
    </fo:table-row>
    <#if childItemList?has_content><#list childItemList as childItem>
        <@productItemRow childItem invoiceItemList negOne/>
    </#list></#if>
</#macro>
<#macro otherItemRow invoiceItem invoiceItemList itemIndex>
    <#assign childItemList = invoiceItemList.cloneList().filterByAnd("parentItemSeqId", invoiceItem.invoiceItemSeqId)>
    <#assign itemTypeEnum = invoiceItem.type!>
    <#assign timeEntry = invoiceItem.findRelatedOne("mantle.work.time.TimeEntry", false, false)!>
    <#assign rateTypeEnum = ""><#assign workEffort = "">
    <#if timeEntry?has_content>
        <#assign rateTypeEnum = timeEntry.findRelatedOne("RateType#moqui.basic.Enumeration", true, false)!>
        <#assign workEffort = timeEntry.findRelatedOne("mantle.work.effort.WorkEffort", false, false)!>
    </#if>
    <fo:table-row font-size="8pt" border-bottom="thin solid black">
        <fo:table-cell padding="${cellPadding}"><fo:block text-align="center"><#if (itemIndex > 0)>${itemIndex}<#else> </#if></fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block><@encodeText (itemTypeEnum.description)!""/></fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block>${ec.l10n.format(invoiceItem.itemDate, dateFormat)}</fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}">
            <fo:block><@encodeText invoiceItem.description!""/></fo:block>
            <#if (timeEntry.workEffortId)?has_content><fo:block>Task: ${timeEntry.workEffortId} - <@encodeText workEffort.workEffortName!""/></fo:block></#if>
            <#if rateTypeEnum?has_content><fo:block>Rate: <@encodeText rateTypeEnum.description/></fo:block></#if>
            <#if timeEntry?has_content><fo:block>${ec.l10n.format(timeEntry.fromDate, "dd MMM yyyy hh:mm")} to ${ec.l10n.format(timeEntry.thruDate, "dd MMM yyyy hh:mm")}, Break ${timeEntry.breakHours!"0"}h</fo:block></#if>
            <#if invoiceItem.otherPartyProductId?has_content><fo:block>Your Product: <@encodeText invoiceItem.otherPartyProductId/></fo:block></#if>
        </fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${invoiceItem.quantity!"1"}</fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(invoiceItem.amount!0, invoice.currencyUomId, 3)}</fo:block></fo:table-cell>
        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(((invoiceItem.quantity!1) * (invoiceItem.amount!0)), invoice.currencyUomId, 3)}</fo:block></fo:table-cell>
    </fo:table-row>
    <#if childItemList?has_content><#list childItemList as childItem>
        <@otherItemRow childItem invoiceItemList negOne/>
    </#list></#if>
</#macro>

<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Helvetica, sans-serif" font-size="10pt">
    <fo:layout-master-set>
        <fo:simple-page-master master-name="letter-portrait" page-width="8.5in" page-height="11in"
                               margin-top="0.5in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
            <fo:region-body margin-top="0.7in" margin-bottom="0.6in"/>
            <fo:region-before extent="0.7in"/>
            <fo:region-after extent="0.5in"/>
        </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="letter-portrait" id="mainSequence">
        <fo:static-content flow-name="xsl-region-before">
            <fo:block-container absolute-position="absolute" top="0in" left="0in" width="3in">
                <#if logoImageLocation?has_content>
                    <fo:block text-align="left">
                        <fo:external-graphic src="${logoImageLocation}" content-height="0.5in" content-width="scale-to-fit" width="2in" scaling="uniform"/>
                    </fo:block>
                <#else>
                    <fo:block font-size="13pt" text-align="center" font-weight="bold"><@encodeText (fromParty.organizationName)!""/><@encodeText (fromParty.firstName)!""/> <@encodeText (fromParty.lastName)!""/></fo:block>
                    <fo:block font-size="12pt" text-align="center" margin-bottom="0.1in">Invoice</fo:block>
                </#if>
            </fo:block-container>
            <fo:block-container absolute-position="absolute" top="0in" right="2.0in" width="2.5in">
                <fo:block text-align="left" font-size="9pt">
                <#if fromContactInfo.postalAddress?has_content>
                    <fo:block><@encodeText (fromContactInfo.postalAddress.address1)!""/><#if fromContactInfo.postalAddress.unitNumber?has_content> #<@encodeText fromContactInfo.postalAddress.unitNumber/></#if></fo:block>
                    <#if fromContactInfo.postalAddress.address2?has_content><fo:block><@encodeText fromContactInfo.postalAddress.address2/></fo:block></#if>
                    <fo:block><@encodeText fromContactInfo.postalAddress.city!""/>, ${(fromContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${fromContactInfo.postalAddress.postalCode!""}<#if fromContactInfo.postalAddress.postalCodeExt?has_content>-${fromContactInfo.postalAddress.postalCodeExt}</#if></fo:block>
                    <#if fromContactInfo.postalAddress.countryGeoId?has_content><fo:block>${fromContactInfo.postalAddress.countryGeoId}</fo:block></#if>
                </#if>
                </fo:block>
            </fo:block-container>
            <fo:block-container absolute-position="absolute" top="0in" right="0in" width="2.0in">
                <fo:block text-align="left" font-size="9pt">
                <#if fromContactInfo.telecomNumber?has_content>
                    <fo:block>T: <#if fromContactInfo.telecomNumber.countryCode?has_content>${fromContactInfo.telecomNumber.countryCode}-</#if><#if fromContactInfo.telecomNumber.areaCode?has_content>${fromContactInfo.telecomNumber.areaCode}-</#if>${fromContactInfo.telecomNumber.contactNumber!""}</fo:block>
                </#if>
                <#if fromContactInfo.faxTelecomNumber?has_content>
                    <fo:block>F: <#if fromContactInfo.faxTelecomNumber.countryCode?has_content>${fromContactInfo.faxTelecomNumber.countryCode}-</#if><#if fromContactInfo.faxTelecomNumber.areaCode?has_content>${fromContactInfo.faxTelecomNumber.areaCode}-</#if>${fromContactInfo.faxTelecomNumber.contactNumber!""}</fo:block>
                </#if>
                <#if fromContactInfo.emailAddress?has_content><fo:block>E: ${fromContactInfo.emailAddress}</fo:block></#if>
                </fo:block>
                <#--
                <fo:block text-align="right">
                    <fo:instream-foreign-object>
                        <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="${invoiceId}">
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
                -->
            </fo:block-container>
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after" font-size="8pt">
            <fo:block border-top="thin solid black">
                <fo:block text-align="center">
                <#if fromContactInfo.postalAddress?has_content>
                    <@encodeText (fromContactInfo.postalAddress.address1)!""/><#if fromContactInfo.postalAddress.unitNumber?has_content> #${fromContactInfo.postalAddress.unitNumber}</#if><#if fromContactInfo.postalAddress.address2?has_content>, <@encodeText fromContactInfo.postalAddress.address2/></#if>, <@encodeText (fromContactInfo.postalAddress.city!"")/>, ${(fromContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${fromContactInfo.postalAddress.postalCode!""}<#if fromContactInfo.postalAddress.postalCodeExt?has_content>-${fromContactInfo.postalAddress.postalCodeExt}</#if><#if fromContactInfo.postalAddress.countryGeoId?has_content>, ${fromContactInfo.postalAddress.countryGeoId}</#if>
                </#if>
                <#if fromContactInfo.telecomNumber?has_content>
                    -- <#if fromContactInfo.telecomNumber.countryCode?has_content>${fromContactInfo.telecomNumber.countryCode}-</#if><#if fromContactInfo.telecomNumber.areaCode?has_content>${fromContactInfo.telecomNumber.areaCode}-</#if>${fromContactInfo.telecomNumber.contactNumber!""}
                </#if>
                <#if fromContactInfo.emailAddress?has_content> -- ${fromContactInfo.emailAddress}</#if>
                </fo:block>
                <fo:block text-align="center"><@encodeText (fromParty.organizationName)!""/><@encodeText (fromParty.firstName)!""/> <@encodeText (fromParty.lastName)!""/> Invoice #${invoiceId} -- ${ec.l10n.format(invoice.invoiceDate, dateFormat)} -- Page <fo:page-number/><#-- of <fo:page-number-citation-last ref-id="mainSequence"/>--></fo:block>
            </fo:block>
        </fo:static-content>

        <#-- body starts 0.5in + 0.7in = 1.2in from top, 0.5in from left -->
        <fo:flow flow-name="xsl-region-body">
            <fo:block-container width="7.5in" height="0.8in">
                <fo:table table-layout="fixed" margin-bottom="0.2in" width="7.5in"><fo:table-body><fo:table-row>
                    <fo:table-cell padding="3pt" width="1.75in">
                        <fo:block font-weight="bold">Invoice #</fo:block>
                        <fo:block>${invoiceId}</fo:block>
                        <fo:block font-weight="bold">Customer #</fo:block>
                        <fo:block>${toParty.pseudoId}</fo:block>
                    </fo:table-cell>
                    <#if invoice.referenceNumber?has_content || invoice.otherPartyOrderId?has_content>
                        <fo:table-cell padding="3pt" width="1.75in">
                            <#if invoice.referenceNumber?has_content>
                                <fo:block font-weight="bold">Ref #</fo:block>
                                <fo:block><@encodeText invoice.referenceNumber/></fo:block>
                            </#if>
                            <#if invoice.otherPartyOrderId?has_content>
                                <fo:block font-weight="bold">Your Order</fo:block>
                                <fo:block><@encodeText invoice.otherPartyOrderId/></fo:block>
                            </#if>
                        </fo:table-cell>
                    </#if>
                    <fo:table-cell padding="3pt" width="2in">
                        <#if (finalizedStatusHistoryList?size > 1)>
                            <fo:block font-weight="bold">AMENDED ${ec.l10n.format(finalizedStatusHistoryList.get(0).changedDate, dateFormat)}</fo:block>
                            <fo:block>(previous ${ec.l10n.format(finalizedStatusHistoryList.get(1).changedDate, dateFormat)})</fo:block>
                        </#if>
                        <fo:block font-weight="bold">Invoice Date</fo:block>
                        <fo:block>${ec.l10n.format(invoice.invoiceDate, dateFormat)}</fo:block>
                    </fo:table-cell>
                    <#if orderIdSet?has_content>
                        <fo:table-cell padding="3pt" width="2in">
                            <fo:block font-weight="bold">Our Order</fo:block>
                            <fo:block><#list orderIdSet as orderId>${orderId}<#sep>, </#list></fo:block>
                        </fo:table-cell>
                    </#if>
                </fo:table-row></fo:table-body></fo:table>
            </fo:block-container>
            <fo:table table-layout="fixed" margin-bottom="0.2in" width="7.5in"><fo:table-body><fo:table-row>
                <#-- Customer Billing Address - for envelope window make a total of 0.8in from left, 2in from top (1.2in tall, 4.5in wide) -->
                <fo:table-cell padding="3pt" width="4.5in">
                    <fo:block-container margin-left="0.5in" margin-top="0.3in" height="1.0in" font-size="10pt">
                    <#if toBillingRep?has_content><fo:block>Attention: <@encodeText (toBillingRep.organizationName)!""/> <@encodeText (toBillingRep.firstName)!""/> <@encodeText (toBillingRep.lastName)!""/></fo:block></#if>
                        <fo:block><@encodeText (toParty.organizationName)!""/> <@encodeText (toParty.firstName)!""/> <@encodeText (toParty.lastName)!""/></fo:block>
                    <#if toContactInfo.postalAddress?has_content>
                        <fo:block><@encodeText (toContactInfo.postalAddress.address1)!""/><#if toContactInfo.postalAddress.unitNumber?has_content> #${toContactInfo.postalAddress.unitNumber}</#if></fo:block>
                        <#if toContactInfo.postalAddress.address2?has_content><fo:block><@encodeText toContactInfo.postalAddress.address2/></fo:block></#if>
                        <fo:block><@encodeText (toContactInfo.postalAddress.city!"")/>, ${(toContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${toContactInfo.postalAddress.postalCode!""}<#if toContactInfo.postalAddress.postalCodeExt?has_content>-${toContactInfo.postalAddress.postalCodeExt}</#if></fo:block>
                        <#if toContactInfo.postalAddress.countryGeoId?has_content><fo:block>${toContactInfo.postalAddress.countryGeoId}</fo:block></#if>
                    </#if>
                    </fo:block-container>
                    <fo:block-container margin-left="0.5in"><fo:block font-size="8pt">
                        <#if toContactInfo.telecomNumber?has_content>T: <#if toContactInfo.telecomNumber.countryCode?has_content>${toContactInfo.telecomNumber.countryCode}-</#if><#if toContactInfo.telecomNumber.areaCode?has_content>${toContactInfo.telecomNumber.areaCode}-</#if>${toContactInfo.telecomNumber.contactNumber!""}</#if>
                        <#if toContactInfo.emailAddress?has_content>E: <@encodeText toContactInfo.emailAddress/></#if>
                    </fo:block></fo:block-container>
                </fo:table-cell>
                <fo:table-cell padding="3pt" width="3in">
                    <#if !showOrig>
                        <#if unpaidTotal == 0>
                            <fo:block font-weight="bold">PAID IN FULL</fo:block>
                        <#else>
                            <fo:block font-weight="bold">Balance Due</fo:block>
                            <fo:block>${ec.l10n.formatCurrency(unpaidTotal, invoice.currencyUomId)}</fo:block>
                        </#if>
                    </#if>
                    <#if showOrig || unpaidTotal != 0>
                        <#if invoice.dueDate??>
                            <fo:block font-weight="bold">Due Date</fo:block>
                            <fo:block>${ec.l10n.format(invoice.dueDate, dateFormat)}</fo:block>
                        </#if>
                        <#if settlementTerm?has_content>
                            <fo:block font-weight="bold">Term</fo:block>
                            <fo:block><@encodeText settlementTerm.description/></fo:block>
                        </#if>
                    </#if>
                </fo:table-cell>
            </fo:table-row></fo:table-body></fo:table>

            <#if hasProductItems && !hasTimeEntryItems>
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-header font-size="9pt" border-bottom="solid black">
                        <fo:table-cell width="0.4in" padding="${cellPadding}"><fo:block text-align="center">Item</fo:block></fo:table-cell>
                        <fo:table-cell width="1in" padding="${cellPadding}"><fo:block>Product</fo:block></fo:table-cell>
                        <fo:table-cell width="1in" padding="${cellPadding}"><fo:block>Lot</fo:block></fo:table-cell>
                        <fo:table-cell width="2.5in" padding="${cellPadding}"><fo:block>Description</fo:block></fo:table-cell>
                        <fo:table-cell width="0.6in" padding="${cellPadding}"><fo:block text-align="center">Qty</fo:block></fo:table-cell>
                        <fo:table-cell width="0.9in" padding="${cellPadding}"><fo:block text-align="right">Amount</fo:block></fo:table-cell>
                        <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="right">Total</fo:block></fo:table-cell>
                    </fo:table-header>
                    <fo:table-body>
                        <#list topItemList as invoiceItem>
                            <#if !(invoiceItem.parentItemSeqId?has_content)><@productItemRow invoiceItem invoiceItemList invoiceItem_index+1/></#if>
                        </#list>
                        <fo:table-row font-size="9pt" border-top="solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">Total</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">${ec.l10n.formatCurrency(noAdjustmentTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            <#else>
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-header font-size="9pt" border-bottom="solid black">
                        <fo:table-cell width="0.3in" padding="${cellPadding}"><fo:block text-align="center">Item</fo:block></fo:table-cell>
                        <fo:table-cell width="1in" padding="${cellPadding}"><fo:block>Type</fo:block></fo:table-cell>
                        <fo:table-cell width="0.8in" padding="${cellPadding}"><fo:block>Date</fo:block></fo:table-cell>
                        <fo:table-cell width="2.8in" padding="${cellPadding}"><fo:block>Description</fo:block></fo:table-cell>
                        <fo:table-cell width="0.6in" padding="${cellPadding}"><fo:block text-align="center">Qty</fo:block></fo:table-cell>
                        <fo:table-cell width="0.9in" padding="${cellPadding}"><fo:block text-align="right">Amount</fo:block></fo:table-cell>
                        <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="right">Total</fo:block></fo:table-cell>
                    </fo:table-header>
                    <fo:table-body>
                    <#list topItemList as invoiceItem>
                        <#if !(invoiceItem.parentItemSeqId?has_content)><@otherItemRow invoiceItem invoiceItemList invoiceItem_index+1/></#if>
                    </#list>
                        <fo:table-row font-size="9pt" border-top="solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">Total</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">${ec.l10n.formatCurrency(noAdjustmentTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </#if>

            <fo:table table-layout="fixed" width="100%" margin-top="0.1in">
                <fo:table-header font-size="9pt" border-bottom="solid black">
                    <fo:table-cell width="2.0in" padding="${cellPadding}"><fo:block>Type</fo:block></fo:table-cell>
                    <#if hasTimeEntryItems><fo:table-cell width="1.2in" padding="${cellPadding}"><fo:block text-align="right">Amount</fo:block></fo:table-cell></#if>
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="center">Qty</fo:block></fo:table-cell>
                    <fo:table-cell width="1.2in" padding="${cellPadding}"><fo:block text-align="right">Total</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                <#list itemTypeSummaryMapList as itemTypeSummaryMap>
                    <#assign itemTypeEnum = ec.entity.find("moqui.basic.Enumeration").condition("enumId", itemTypeSummaryMap.itemTypeEnumId).useCache(true).one()>
                    <fo:table-row font-size="9pt" border-bottom="thin solid black">
                        <fo:table-cell padding="${cellPadding}"><fo:block>${(itemTypeEnum.description)!""}</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${itemTypeSummaryMap.quantity}</fo:block></fo:table-cell>
                        <#if hasTimeEntryItems><fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(itemTypeSummaryMap.amount, invoice.currencyUomId)}</fo:block></fo:table-cell></#if>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(itemTypeSummaryMap.total, invoice.currencyUomId)}</fo:block></fo:table-cell>
                    </fo:table-row>
                </#list>
                <fo:table-row font-size="9pt">
                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="center"> </fo:block></fo:table-cell>
                    <fo:table-cell padding="${cellPadding}" font-weight="bold"><fo:block text-align="right">Total</fo:block></fo:table-cell>
                    <#if hasTimeEntryItems><fo:table-cell padding="${cellPadding}"><fo:block text-align="right"> </fo:block></fo:table-cell></#if>
                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">${ec.l10n.formatCurrency(noAdjustmentTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                </fo:table-row>
                </fo:table-body>
            </fo:table>

            <#if !showOrig && adjustmentItemList?has_content>
                <fo:table table-layout="fixed" width="100%" margin-top="0.1in">
                    <fo:table-header font-size="9pt" border-bottom="solid black">
                        <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="center">Adjustment</fo:block></fo:table-cell>
                        <fo:table-cell width="4in" padding="${cellPadding}"><fo:block>Description</fo:block></fo:table-cell>
                        <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="center">Date</fo:block></fo:table-cell>
                        <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="right">Amount</fo:block></fo:table-cell>
                    </fo:table-header>
                    <fo:table-body>
                        <#list adjustmentItemList as invoiceItem>
                            <#assign itemTypeEnum = invoiceItem.type!>
                            <fo:table-row font-size="8pt" border-bottom="thin solid black">
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${invoiceItem_index}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}">
                                    <fo:block><@encodeText (invoiceItem.description)!(itemTypeEnum.description)!""/></fo:block>
                                    <#if invoiceItem.otherPartyProductId?has_content><fo:block>Your Product: <@encodeText invoiceItem.otherPartyProductId/></fo:block></#if>
                                </fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${ec.l10n.format(invoiceItem.itemDate!, dateFormat)}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(((invoiceItem.quantity!1) * (invoiceItem.amount!0)), invoice.currencyUomId, 3)}</fo:block></fo:table-cell>
                            </fo:table-row>
                        </#list>
                        <fo:table-row font-size="9pt" border-top="solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">Adjustments Total</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">${ec.l10n.formatCurrency(adjustmentTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                        <fo:table-row font-size="9pt" border-top="solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">Invoice Total</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">${ec.l10n.formatCurrency(invoiceTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </#if>

        <#if !showOrig && paymentApplicationList?has_content>
            <fo:block font-size="10pt" font-weight="bold" margin-top="0.1in">Applied Payments</fo:block>
            <fo:table table-layout="fixed" width="100%">
                <fo:table-header font-size="9pt" border-bottom="solid black">
                    <fo:table-cell width="1in" padding="${cellPadding}"><fo:block>Payment</fo:block></fo:table-cell>
                    <fo:table-cell width="2in" padding="${cellPadding}"><fo:block>Ref/Check</fo:block></fo:table-cell>
                    <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="right">Amount</fo:block></fo:table-cell>
                    <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="center">Date</fo:block></fo:table-cell>
                    <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="right">Applied</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                    <#list paymentApplicationList as paymentAppl>
                        <#assign otherInvoiceId = "">
                        <#if paymentAppl.toInvoiceId?has_content>
                            <#if paymentAppl.toInvoiceId == invoice.invoiceId>
                                <#assign otherInvoiceId = paymentAppl.invoiceId>
                                <#assign otherInvoice = paymentAppl.invoice>
                            <#else>
                                <#assign otherInvoiceId = paymentAppl.toInvoiceId>
                                <#assign otherInvoice = paymentAppl.toInvoice>
                            </#if>
                        <#else>
                            <#assign payment = paymentAppl.payment>
                        </#if>
                        <fo:table-row font-size="8pt" border-bottom="thin solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block><#if otherInvoiceId?has_content>Invc ${otherInvoiceId}<#else>${paymentAppl.paymentId}</#if></fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block><#if otherInvoiceId?has_content><@encodeText (otherInvoice.referenceNumber!"")/><#else><@encodeText (payment.paymentRefNum!"")/></#if></fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right"><#if otherInvoiceId?has_content>${ec.l10n.formatCurrency(otherInvoice.invoiceTotal!, invoice.currencyUomId)}<#else>${ec.l10n.formatCurrency(payment.amount!, invoice.currencyUomId)}</#if></fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="center"><#if otherInvoiceId?has_content>${ec.l10n.format(otherInvoice.invoiceDate!, dateFormat)}<#else>${ec.l10n.format(payment.effectiveDate!, dateFormat)}</#if></fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.formatCurrency(paymentAppl.amountApplied!, invoice.currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </#list>
                    <fo:table-row font-size="9pt" border-top="solid black">
                        <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block> </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">Payments Total</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">${ec.l10n.formatCurrency(appliedPaymentsTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </#if>

        <#if fromPartyMessage?has_content><fo:block margin-top="0.2in" font-size="10pt" font-weight="bold" linefeed-treatment="preserve">
            ${(Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(fromPartyMessage, true))}</fo:block></#if>
        <#if toPartyMessage?has_content><fo:block margin-top="0.2in" font-size="10pt" font-weight="bold" linefeed-treatment="preserve">
            ${(Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(toPartyMessage, true))}</fo:block></#if>
        <#if invoice.invoiceMessage?has_content><fo:block margin-top="0.2in" font-size="10pt" font-weight="bold" linefeed-treatment="preserve">
            ${(Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(invoice.invoiceMessage, true))}</fo:block></#if>

        </fo:flow>
    </fo:page-sequence>
</fo:root>
