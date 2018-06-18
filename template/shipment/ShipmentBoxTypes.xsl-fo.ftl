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

<#-- Data preparation: <entity-find entity-name="mantle.shipment.ShipmentBoxTypeDetail" list="boxTypeList"><order-by field-name="pseudoId"/></entity-find> -->

<#assign cellPadding = "1pt">

<#macro encodeText textValue>${(Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(textValue!"", false))!""}</#macro>

<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Helvetica, sans-serif" font-size="10pt">
    <fo:layout-master-set>
        <fo:simple-page-master master-name="letter-portrait" page-width="8.5in" page-height="11in"
                               margin-top="0.5in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
            <fo:region-body margin-top="0.5in" margin-bottom="0.6in"/>
            <fo:region-before extent="0.5in"/>
            <fo:region-after extent="0.5in"/>
        </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="letter-portrait">
        <fo:static-content flow-name="xsl-region-before">
        <#if fromPartyDetail?has_content><fo:block font-size="14pt" text-align="center"><@encodeText fromPartyDetail.organizationName!""/><@encodeText fromPartyDetail.firstName!""/> <@encodeText fromPartyDetail.lastName!""/></fo:block></#if>
            <fo:block font-size="12pt" text-align="center" margin-bottom="0.1in">Box Types</fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
            <fo:table table-layout="fixed" width="7.5in" border-bottom="solid black" margin-top="10pt">
                <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                    <fo:table-cell width="3.0in" padding="${cellPadding}"><fo:block text-align="center">ID</fo:block></fo:table-cell>
                    <fo:table-cell width="2.5in" padding="${cellPadding}"><fo:block>Description</fo:block></fo:table-cell>
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="center">L x W x H</fo:block></fo:table-cell>
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="center">Weight</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                <#list boxTypeList as boxType>
                    <fo:table-row font-size="9pt" border-top="solid black">
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">
                            <fo:instream-foreign-object>
                                <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="${boxType.pseudoId}">
                                    <barcode:code128>
                                        <barcode:height>0.4in</barcode:height>
                                        <barcode:module-width>0.25mm</barcode:module-width>
                                    </barcode:code128>
                                    <barcode:human-readable>
                                        <barcode:placement>bottom</barcode:placement>
                                        <barcode:font-name>Helvetica</barcode:font-name>
                                        <barcode:font-size>7pt</barcode:font-size>
                                        <barcode:display-start-stop>false</barcode:display-start-stop>
                                        <barcode:display-checksum>false</barcode:display-checksum>
                                    </barcode:human-readable>
                                </barcode:barcode>
                            </fo:instream-foreign-object>
                        </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block>${boxType.description!""}</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${ec.l10n.format(boxType.boxLength!, '0.###')} x ${ec.l10n.format(boxType.boxWidth!, '0.###')} x ${ec.l10n.format(boxType.boxHeight!, '0.###')} ${boxType.dimensionAbbreviation!""}</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${ec.l10n.format(boxType.boxWeight!, '0.###')} ${boxType.weightAbbreviation!""}</fo:block></fo:table-cell>
                    </fo:table-row>
                </#list>
                </fo:table-body>
            </fo:table>
        </fo:flow>
    </fo:page-sequence>
</fo:root>
