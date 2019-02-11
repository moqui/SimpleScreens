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

<#-- See the mantle.account.InvoiceServices.get#ReceivableStatementInfo service for data preparation -->

<#assign cellPadding = "4pt">
<#assign tableFontSize = tableFontSize!"10pt">
<#assign dateTimeFormat = dateTimeFormat!"dd MMM yyyy HH:mm">
<#assign dateFormat = dateFormat!"dd MMM yyyy">
<#macro encodeText textValue>${Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(textValue!"", false)}</#macro>

<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Helvetica, sans-serif" font-size="10pt">
    <fo:layout-master-set>
        <fo:simple-page-master master-name="letter-portrait" page-width="8.5in" page-height="11in"
                               margin-top="0.5in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
            <fo:region-body margin-top="1.0in" margin-bottom="0.6in"/>
            <fo:region-before extent="1in"/>
            <fo:region-after extent="0.5in"/>
        </fo:simple-page-master>
    </fo:layout-master-set>

<#if receivableInfoList?has_content><#list receivableInfoList as receivableInfo>
    <#assign fromPartyId = receivableInfo.fromPartyId>
    <#assign fromParty = receivableInfo.fromParty>
    <#assign fromContactInfo = receivableInfo.fromContactInfo>
    <#assign logoImageLocation = receivableInfo.logoImageLocation!>
    <#assign invoiceList = receivableInfo.invoiceList>
    <#assign unappliedPaymentList = receivableInfo.unappliedPaymentList>
    <#assign agingSummaryList = receivableInfo.agingSummaryList>

    <fo:page-sequence master-reference="letter-portrait" id="mainSequence">
        <fo:static-content flow-name="xsl-region-before">
            <fo:block font-size="16pt" text-align="center"><@encodeText (fromParty.organizationName)!""/><@encodeText (fromParty.firstName)!""/> <@encodeText (fromParty.lastName)!""/></fo:block>
            <fo:block font-size="12pt" text-align="center" margin-bottom="0.1in">${ec.l10n.localize('Billing Statement')}</fo:block>
            <#if logoImageLocation?has_content>
                <fo:block-container absolute-position="absolute" top="0in" left="0.1in" width="2in">
                    <fo:block text-align="left">
                        <fo:external-graphic src="${logoImageLocation}" content-height="0.5in" content-width="scale-to-fit" width="2in" scaling="uniform"/>
                    </fo:block>
                </fo:block-container>
            </#if>
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after" font-size="8pt">
            <fo:block border-top="thin solid black">
                <fo:block text-align="center">
                    <#if fromContactInfo.postalAddress?has_content>
                        <@encodeText (fromContactInfo.postalAddress.address1)!""/><#if fromContactInfo.postalAddress.unitNumber?has_content> #<@encodeText fromContactInfo.postalAddress.unitNumber/></#if><#if fromContactInfo.postalAddress.address2?has_content>, <@encodeText fromContactInfo.postalAddress.address2/></#if>, <@encodeText (fromContactInfo.postalAddress.city)!""/>, ${(fromContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${fromContactInfo.postalAddress.postalCode!""}<#if fromContactInfo.postalAddress.postalCodeExt?has_content>-${fromContactInfo.postalAddress.postalCodeExt}</#if><#if fromContactInfo.postalAddress.countryGeoId?has_content>, ${fromContactInfo.postalAddress.countryGeoId}</#if>
                    </#if>
                    <#if fromContactInfo.telecomNumber?has_content>
                        -- <#if fromContactInfo.telecomNumber.countryCode?has_content>${fromContactInfo.telecomNumber.countryCode}-</#if><#if fromContactInfo.telecomNumber.areaCode?has_content>${fromContactInfo.telecomNumber.areaCode}-</#if>${fromContactInfo.telecomNumber.contactNumber!""}
                    </#if>
                    <#if fromContactInfo.emailAddress?has_content> -- ${fromContactInfo.emailAddress}</#if>
                </fo:block>
                <fo:block text-align="center">Statement -- ${ec.l10n.format(asOfTimestamp, dateFormat)} -- Page <fo:page-number/> of <fo:page-number-citation-last ref-id="mainSequence"/></fo:block>
            </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
            <fo:table table-layout="fixed" margin-bottom="0.3in" width="7.5in" font-size="10pt">
                <fo:table-body><fo:table-row>
                    <fo:table-cell padding="3pt" width="3.5in">
                        <#if toBillingRep?has_content><fo:block>Attention: <@encodeText (toBillingRep.organizationName)!""/> <@encodeText (toBillingRep.firstName)!""/> <@encodeText (toBillingRep.lastName)!""/></fo:block></#if>
                        <fo:block font-weight="bold"><@encodeText (toParty.organizationName)!""/> <@encodeText (toParty.firstName)!""/> <@encodeText (toParty.lastName)!""/></fo:block>
                        <#if toContactInfo.postalAddress?has_content>
                            <fo:block><@encodeText (toContactInfo.postalAddress.address1)!""/><#if toContactInfo.postalAddress.unitNumber?has_content> #<@encodeText toContactInfo.postalAddress.unitNumber/></#if></fo:block>
                            <#if toContactInfo.postalAddress.address2?has_content><fo:block><@encodeText toContactInfo.postalAddress.address2/></fo:block></#if>
                            <fo:block><@encodeText (toContactInfo.postalAddress.city)!""/>, ${(toContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${toContactInfo.postalAddress.postalCode!""}<#if toContactInfo.postalAddress.postalCodeExt?has_content>-${toContactInfo.postalAddress.postalCodeExt}</#if></fo:block>
                            <#if toContactInfo.postalAddress.countryGeoId?has_content><fo:block>${toContactInfo.postalAddress.countryGeoId}</fo:block></#if>
                        </#if>
                        <#if toContactInfo.telecomNumber?has_content>
                            <fo:block><#if toContactInfo.telecomNumber.countryCode?has_content>${toContactInfo.telecomNumber.countryCode}-</#if><#if toContactInfo.telecomNumber.areaCode?has_content>${toContactInfo.telecomNumber.areaCode}-</#if>${toContactInfo.telecomNumber.contactNumber!""}</fo:block>
                        </#if>
                        <#if toContactInfo.emailAddress?has_content>
                            <fo:block>${toContactInfo.emailAddress}</fo:block>
                        </#if>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt" width="2.25in">
                        <fo:block font-weight="bold">${ec.l10n.localize('Total Unpaid')}</fo:block>
                        <fo:block>${ec.l10n.formatCurrency(receivableInfo.unpaidTotal, currencyUomId)}</fo:block>
                        <fo:block font-weight="bold">${ec.l10n.localize('Payments Unapplied')}</fo:block>
                        <fo:block>${ec.l10n.formatCurrency(receivableInfo.unappliedTotal, currencyUomId)}</fo:block>
                        <fo:block font-weight="bold">${ec.l10n.localize('Balance Due')}</fo:block>
                        <fo:block font-weight="bold">${ec.l10n.formatCurrency(receivableInfo.balanceDue, currencyUomId)}</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt" width="1.75in">
                        <fo:block font-weight="bold">${ec.l10n.localize('As of Date')}</fo:block>
                        <fo:block>${ec.l10n.format(asOfTimestamp, dateFormat)}</fo:block>
                        <fo:block font-weight="bold">${ec.l10n.localize('Customer ID')}</fo:block>
                        <fo:block>${toParty.pseudoId}</fo:block>
                    </fo:table-cell>
                </fo:table-row></fo:table-body>
            </fo:table>

            <#if invoiceList?has_content>
            <fo:table table-layout="fixed" width="100%">
                <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize('Invoice #')}</fo:block></fo:table-cell>
                    <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize('Ref/PO')}</fo:block></fo:table-cell>
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize('Invoice Date')}</fo:block></fo:table-cell>
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize('Due Date')}</fo:block></fo:table-cell>
                    <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize('Total')}</fo:block></fo:table-cell>
                    <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize('Unpaid')}</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                    <#list invoiceList as invoice>
                        <fo:table-row font-size="${tableFontSize}" border-bottom="thin solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${invoice.invoiceId}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"><@encodeText invoice.otherPartyOrderId!invoice.referenceNumber!" "/></fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.format(invoice.invoiceDate, dateFormat)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.format(invoice.dueDate, dateFormat)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(invoice.invoiceTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(invoice.unpaidTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </#list>
                    <fo:table-row font-size="${tableFontSize}" border-bottom="thin solid black">
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">Total</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace" font-weight="bold">${ec.l10n.formatCurrency(receivableInfo.invoiceTotal, currencyUomId)}</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace" font-weight="bold">${ec.l10n.formatCurrency(receivableInfo.unpaidTotal, currencyUomId)}</fo:block></fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
            </#if>

            <#if unappliedPaymentList?has_content>
                <fo:table table-layout="fixed" width="100%" margin-top="0.2in">
                    <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                        <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize('Payment')} #</fo:block></fo:table-cell>
                        <fo:table-cell width="2.5in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize('Date')}</fo:block></fo:table-cell>
                        <fo:table-cell width="2.0in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize('Amount')}</fo:block></fo:table-cell>
                        <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize('Unapplied')}</fo:block></fo:table-cell>
                    </fo:table-header>
                    <fo:table-body>
                        <#list unappliedPaymentList as payment>
                            <fo:table-row font-size="${tableFontSize}" border-bottom="thin solid black">
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${payment.paymentId}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.format(payment.effectiveDate, dateFormat)}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(payment.amount!0, payment.amountUomId)}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(payment.unappliedTotal!0, payment.amountUomId)}</fo:block></fo:table-cell>
                            </fo:table-row>
                        </#list>
                        <fo:table-row font-size="${tableFontSize}" border-bottom="thin solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">Total</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace" font-weight="bold">${ec.l10n.formatCurrency(receivableInfo.paymentTotal, currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace" font-weight="bold">${ec.l10n.formatCurrency(receivableInfo.unappliedTotal, currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </#if>

            <#if agingSummaryList?has_content>
            <fo:table table-layout="fixed" width="100%" margin-top="0.2in">
                <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize('Current')}</fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">${ec.resource.expand("0 - $\{periodDays} days", null)}</fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">${ec.resource.expand('$\{periodDays+1} - $\{periodDays*2} days', null)}</fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">${ec.resource.expand('$\{periodDays*2+1} - $\{periodDays*3} days', null)}</fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">${ec.resource.expand('&gt; $\{periodDays*3} days', null)}</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                    <#list agingSummaryList as summary>
                        <fo:table-row font-size="9pt" border-bottom="thin solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"><@encodeText ec.l10n.localize(summary.description)/></fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.current, currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.period0, currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.period1, currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.period2, currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.period3 + summary.periodRemaining, currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </#list>
                </fo:table-body>
            </fo:table>
            </#if>
        </fo:flow>
    </fo:page-sequence>
</#list><#else>
<fo:page-sequence master-reference="letter-portrait" id="mainSequence">
    <fo:flow flow-name="xsl-region-body" font-size="10pt">
        <#if toBillingRep?has_content><fo:block>Attention: <@encodeText (toBillingRep.organizationName)!""/> <@encodeText (toBillingRep.firstName)!""/> <@encodeText (toBillingRep.lastName)!""/></fo:block></#if>
        <fo:block><@encodeText (toParty.organizationName)!""/> <@encodeText (toParty.firstName)!""/> <@encodeText (toParty.lastName)!""/></fo:block>
        <#if toContactInfo.emailAddress?has_content>
            <fo:block>${toContactInfo.emailAddress}</fo:block>
        </#if>
        <fo:block font-size="12pt" margin-top="0.5in">Account is current, no unpaid invoices or unapplied payments</fo:block>
    </fo:flow>
</fo:page-sequence>

</#if>
</fo:root>
