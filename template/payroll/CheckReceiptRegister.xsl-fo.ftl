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

<#-- See the mantle.humanres.PayrollServices.get#CheckReceiptRegisterInfo service for data preparation -->

<#assign cellPadding = "4pt">
<#assign dateFormat = dateFormat!"dd MMM yyyy">
<#assign dateTimeFormat = dateTimeFormat!"yyyy-MM-dd HH:mm">
<#assign extraLines = extraLines!3>

<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Helvetica, sans-serif" font-size="10pt">
    <fo:layout-master-set>
        <fo:simple-page-master master-name="letter" page-width="11in" page-height="8.5in"
                               margin-top="0.5in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
            <fo:region-body margin-top="1.25in" margin-bottom="0.6in"/>
            <fo:region-before extent="1.25in"/>
            <fo:region-after extent="0.5in"/>
        </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="letter" initial-page-number="1" force-page-count="no-force">
        <fo:static-content flow-name="xsl-region-before">
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after" font-size="8pt">
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
            <fo:table table-layout="fixed" width="10in" border-bottom="solid black">
                <fo:table-header font-size="10pt" font-weight="bold" border-bottom="solid black">
                    <fo:table-cell width="6in" padding="${cellPadding}"><fo:block text-align="left">Name</fo:block></fo:table-cell>
                    <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="center">Check #</fo:block></fo:table-cell>
                    <fo:table-cell width="1in" padding="${cellPadding}"><fo:block text-align="center">Amount</fo:block></fo:table-cell>
                    <fo:table-cell width="2in" padding="${cellPadding}"><fo:block text-align="center">Signature</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                <#list paymentList as payment>
                    <#assign person = ec.entity.find("mantle.party.Person").condition("partyId", payment.toPartyId).useCache(true).one()>
                    <fo:table-row height="0.5in" font-size="9pt" border-top="solid black">
                        <fo:table-cell padding="${cellPadding}" display-align="after"><fo:block text-align="left">${ec.resource.expand('PartyLastNameFirstTemplate', '', person)}</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey" display-align="after"><fo:block text-align="center">${payment.paymentRefNum!}</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey" display-align="after"><fo:block text-align="center">${ec.l10n.formatCurrency(payment.amount, payment.amountUomId)}</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey" display-align="after"><fo:block text-align="center"></fo:block></fo:table-cell>
                    </fo:table-row>
                </#list>
                <#if !paymentList>
                    <fo:table-row height="0.5in" font-size="9pt" border-top="solid black">
                        <fo:table-cell padding="${cellPadding}" display-align="after"><fo:block text-align="left"></fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey" display-align="after"><fo:block text-align="center"></fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey" display-align="after"><fo:block text-align="center"></fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey" display-align="after"><fo:block text-align="center"></fo:block></fo:table-cell>
                    </fo:table-row>
                </#if>
                </fo:table-body>
            </fo:table>
        </fo:flow>
    </fo:page-sequence>
</fo:root>
