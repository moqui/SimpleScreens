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

<#-- See the mantle.shipment.ShipmentServices.get#ShipmentPickPackInfo service for data preparation -->

<#assign cellPadding = "1pt">
<#assign dateFormat = dateFormat!"dd MMM yyyy">
<#assign dateTimeFormat = dateTimeFormat!"yyyy-MM-dd HH:mm">

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
            <fo:block font-size="12pt" text-align="center" margin-bottom="0.1in">Shipment by Package</fo:block>
            <fo:block-container absolute-position="absolute" top="0in" right="0.5in" width="3in">
                <fo:block text-align="right">
                    <fo:instream-foreign-object>
                        <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="${shipmentId}">
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
            </fo:block-container>
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after" font-size="8pt">
            <fo:block border-top="thin solid black">
                <fo:block text-align="center">Packages for Shipment #${shipmentId} -- <#if shipment.estimatedShipDate??>${ec.l10n.format(shipment.estimatedShipDate, dateFormat)} -- </#if>Printed ${ec.l10n.format(ec.user.nowTimestamp, dateTimeFormat)} -- Page <fo:page-number/></fo:block>
            </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
            <fo:table table-layout="fixed" margin-bottom="0.1in" width="7.5in"><fo:table-body><fo:table-row>
                <fo:table-cell padding="3pt" width="3in">
                    <fo:block font-weight="bold">Shipment #</fo:block>
                    <fo:block>${shipmentId}</fo:block>
                    <#if orderPartList?has_content>
                        <fo:block font-weight="bold">Order</fo:block>
                        <#list orderPartList as orderPart>
                            <fo:block>${orderPart.orderId}:${orderPart.orderPartSeqId}<#if orderPart.otherPartyOrderId?has_content> - PO ${orderPart.otherPartyOrderId}</#if></fo:block>
                        </#list>
                    </#if>
                    <#if invoiceList?has_content>
                        <fo:block font-weight="bold">Invoice</fo:block>
                        <#list invoiceList as invoice>
                            <fo:block>${invoice.invoiceId}<#if invoice.otherPartyOrderId?has_content || invoice.referenceNumber?has_content> - PO ${invoice.otherPartyOrderId!invoice.referenceNumber}</#if></fo:block>
                        </#list>
                    </#if>
                    <#if originFacility?has_content>
                        <fo:block font-weight="bold">Origin Facility</fo:block>
                        <fo:block><@encodeText ec.resource.expand("FacilityNameTemplate", "", originFacility)/></fo:block>
                    </#if>
                    <#if destinationFacility?has_content>
                        <fo:block font-weight="bold">Destination Facility</fo:block>
                        <fo:block><@encodeText ec.resource.expand("FacilityNameTemplate", "", destinationFacility)/></fo:block>
                    </#if>
                </fo:table-cell>
                <fo:table-cell padding="3pt" width="1.5in">
                    <#if shipment.estimatedReadyDate?exists>
                        <fo:block font-weight="bold">Est. Ready</fo:block>
                        <fo:block>${ec.l10n.format(shipment.estimatedReadyDate, dateTimeFormat)}</fo:block>
                    </#if>
                    <#if shipment.estimatedShipDate?exists>
                        <fo:block font-weight="bold">Est. Ship</fo:block>
                        <fo:block>${ec.l10n.format(shipment.estimatedShipDate, dateTimeFormat)}</fo:block>
                    </#if>
                    <#if shipment.estimatedArrivalDate?exists>
                        <fo:block font-weight="bold">Est. Arrival</fo:block>
                        <fo:block>${ec.l10n.format(shipment.estimatedArrivalDate, dateTimeFormat)}</fo:block>
                    </#if>
                    <fo:block font-size="6pt"> </fo:block>
                </fo:table-cell>
                <fo:table-cell padding="3pt" width="3in">
                    <#if toPartyDetail?has_content>
                        <fo:block font-weight="bold">${toPartyDetail.pseudoId}: <@encodeText (toPartyDetail.organizationName)!""/> <@encodeText (toPartyDetail.firstName)!""/> <@encodeText (toPartyDetail.middleName)!""/> <@encodeText (toPartyDetail.lastName)!""/></fo:block>
                    </#if>
                <#if toContactInfo.postalAddress?has_content>
                    <#if toContactInfo.postalAddress.toName?has_content || toContactInfo.postalAddress.attnName?has_content>
                        <#if toContactInfo.postalAddress.toName?has_content><fo:block font-weight="bold">To: <@encodeText toContactInfo.postalAddress.toName/></fo:block></#if>
                        <#if toContactInfo.postalAddress.attnName?has_content><fo:block font-weight="bold">Attn: <@encodeText toContactInfo.postalAddress.attnName/></fo:block></#if>
                    <#else>
                        <fo:block font-weight="bold"><@encodeText (toPartyDetail.organizationName)!""/> <@encodeText (toPartyDetail.firstName)!""/> <@encodeText (toPartyDetail.middleName)!""/> <@encodeText (toPartyDetail.lastName)!""/></fo:block>
                    </#if>
                    <fo:block font-size="8pt"><@encodeText (toContactInfo.postalAddress.address1)!""/><#if toContactInfo.postalAddress.unitNumber?has_content> #<@encodeText toContactInfo.postalAddress.unitNumber/></#if></fo:block>
                    <#if toContactInfo.postalAddress.address2?has_content><fo:block font-size="8pt"><@encodeText toContactInfo.postalAddress.address2/></fo:block></#if>
                    <fo:block font-size="8pt"><@encodeText toContactInfo.postalAddress.city!""/>, ${(toContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${toContactInfo.postalAddress.postalCode!""}<#if toContactInfo.postalAddress.postalCodeExt?has_content>-${toContactInfo.postalAddress.postalCodeExt}</#if></fo:block>
                    <#if toContactInfo.postalAddress.countryGeoId?has_content><fo:block font-size="8pt">${toContactInfo.postalAddress.countryGeoId}</fo:block></#if>
                </#if>
                <#if toContactInfo.telecomNumber?has_content>
                    <fo:block font-size="8pt"><#if toContactInfo.telecomNumber.countryCode?has_content>${toContactInfo.telecomNumber.countryCode}-</#if><#if toContactInfo.telecomNumber.areaCode?has_content>${toContactInfo.telecomNumber.areaCode}-</#if>${toContactInfo.telecomNumber.contactNumber!""}</fo:block>
                </#if>
                <#if toContactInfo.emailAddress?has_content>
                    <fo:block font-size="8pt">${toContactInfo.emailAddress}</fo:block>
                </#if>
                </fo:table-cell>
            </fo:table-row></fo:table-body></fo:table>
            <#if shipment.handlingInstructions?has_content>
                <fo:block font-weight="bold" margin-top="0.1in">Shipping Instructions</fo:block>
                <fo:block><@encodeText shipment.handlingInstructions/></fo:block>
            </#if>

        <#list packageInfoList as packageInfo>
            <fo:table table-layout="fixed" margin-top="0.1in" width="7.5in"><fo:table-body><fo:table-row>
                <fo:table-cell padding="3pt" width="1.5in"><fo:block>
                    <fo:inline font-weight="bold">Package</fo:inline> ${packageInfo.shipmentPackage.shipmentPackageSeqId}
                </fo:block></fo:table-cell>
                <fo:table-cell padding="3pt" width="3.5in"><fo:block>
                    <fo:inline font-weight="bold">Box Type</fo:inline> ${(packageInfo.shipmentBoxType.description)!''}
                </fo:block></fo:table-cell>
                <fo:table-cell padding="3pt" width="2.5in"><fo:block>
                    <fo:inline font-weight="bold">Weight</fo:inline> ${ec.l10n.format((packageInfo.shipmentPackage.weight)!, '')} ${(packageInfo.weightUom.description)!''}
                </fo:block></fo:table-cell>
            </fo:table-row></fo:table-body></fo:table>
            <#if packageInfo.contentInfoList?has_content>
            <fo:table table-layout="fixed" width="7.5in" border-bottom="solid black">
                <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                    <fo:table-cell width="0.75in" padding="2pt"><fo:block text-align="right">Quantity</fo:block></fo:table-cell>
                    <fo:table-cell width="0.25in" padding="2pt"><fo:block> </fo:block></fo:table-cell>
                    <fo:table-cell width="4in" padding="2pt"><fo:block text-align="left">Product</fo:block></fo:table-cell>

                    <fo:table-cell width="1.5in" padding="2pt"><fo:block> </fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                    <#list packageInfo.contentInfoList as contentInfo>
                        <fo:table-row font-size="9pt">
                            <fo:table-cell padding="2pt"><fo:block text-align="right" font-weight="bold">${contentInfo.packageContent.quantity}</fo:block></fo:table-cell>
                            <fo:table-cell padding="2pt"><fo:block> </fo:block></fo:table-cell>
                            <fo:table-cell padding="2pt"><fo:block text-align="left"><@encodeText ec.resource.expand("ProductNameTemplate", "", contentInfo.productInfo)/></fo:block></fo:table-cell>
                            <fo:table-cell padding="2pt"><fo:block> </fo:block></fo:table-cell>
                        </fo:table-row>
                    </#list>
                </fo:table-body>
            </fo:table>
            </#if>
        </#list>

        <#if productInfoList?has_content>
            <fo:table table-layout="fixed" width="7.5in" border-bottom="solid black" margin-top="10pt">
                <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                    <fo:table-cell width="0.5in" padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                    <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="left">By Product</fo:block></fo:table-cell>
                    <fo:table-cell width="0.3in" padding="${cellPadding}"><fo:block text-align="center">Ar</fo:block></fo:table-cell>
                    <fo:table-cell width="0.3in" padding="${cellPadding}"><fo:block text-align="center">Ais</fo:block></fo:table-cell>
                    <fo:table-cell width="0.3in" padding="${cellPadding}"><fo:block text-align="center">Sec</fo:block></fo:table-cell>
                    <fo:table-cell width="0.3in" padding="${cellPadding}"><fo:block text-align="center">Lev</fo:block></fo:table-cell>
                    <fo:table-cell width="0.3in" padding="${cellPadding}"><fo:block text-align="center">Pos</fo:block></fo:table-cell>

                    <fo:table-cell width="3.0in" padding="${cellPadding}"><fo:block>Lot</fo:block></fo:table-cell>
                    <fo:table-cell width="0.5in" padding="${cellPadding}"><fo:block text-align="center">Bin</fo:block></fo:table-cell>
                    <fo:table-cell width="0.5in" padding="${cellPadding}"><fo:block text-align="right">Quantity</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                    <#list productInfoList as productInfo>
                        <fo:table-row font-size="9pt" border-top="solid black">
                            <fo:table-cell padding="${cellPadding}" number-columns-spanned="5"><fo:block text-align="center">
                                <fo:instream-foreign-object>
                                    <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="${productInfo.productId}">
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
                            <fo:table-cell padding="${cellPadding}" number-columns-spanned="4"><fo:block text-align="left"><@encodeText ec.resource.expand("ProductNameTemplate", "", productInfo)/></fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${productInfo.quantity}</fo:block></fo:table-cell>
                        </fo:table-row>
                        <#if productInfo.reservedLocationInfoList?has_content><#list productInfo.reservedLocationInfoList as locationInfo>
                            <fo:table-row font-size="9pt" border-top="thin solid black">
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="left" font-weight="bold">Res</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${locationInfo.description!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.areaId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.aisleId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.sectionId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.levelId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.positionId!" "}</fo:block></fo:table-cell>

                                <fo:table-cell padding="${cellPadding}" number-columns-spanned="3">
                                    <fo:block><#if locationInfo.lot?has_content>${ec.resource.expand('LotNameTemplate', '', locationInfo.lot)}</#if> </fo:block></fo:table-cell>
                            </fo:table-row>
                            <#list locationInfo.quantityByBin.keySet() as binLocationNumber>
                                <fo:table-row font-size="9pt">
                                    <fo:table-cell padding="${cellPadding}" number-columns-spanned="8"><fo:block> </fo:block></fo:table-cell>
                                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${binLocationNumber!" "}</fo:block></fo:table-cell>
                                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${locationInfo.quantityByBin.get(binLocationNumber!)}</fo:block></fo:table-cell>
                                </fo:table-row>
                            </#list>
                        </#list></#if>
                        <#if productInfo.otherLocationInfoList?has_content><#list productInfo.otherLocationInfoList as locationInfo>
                            <fo:table-row font-size="9pt" border-top="thin solid black">
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="left" font-weight="bold">Alt</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${locationInfo.description!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.areaId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.aisleId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.sectionId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.levelId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.positionId!" "}</fo:block></fo:table-cell>

                                <fo:table-cell padding="${cellPadding}" number-columns-spanned="3">
                                    <fo:block><#if locationInfo.lot?has_content>${ec.resource.expand('LotNameTemplate', '', locationInfo.lot)}</#if> </fo:block></fo:table-cell>
                            </fo:table-row>
                            <#list locationInfo.quantityByBin.keySet() as binLocationNumber>
                                <fo:table-row font-size="9pt">
                                    <fo:table-cell padding="${cellPadding}" number-columns-spanned="8"><fo:block> </fo:block></fo:table-cell>
                                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${binLocationNumber!" "}</fo:block></fo:table-cell>
                                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${locationInfo.quantityByBin.get(binLocationNumber!)}</fo:block></fo:table-cell>
                                </fo:table-row>
                            </#list>
                        </#list></#if>
                        <#if productInfo.productIssuedLocationInfoList?has_content><#list productInfo.productIssuedLocationInfoList as locationInfo>
                            <fo:table-row font-size="9pt" border-top="thin solid black">
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="left" font-weight="bold">Iss</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${locationInfo.description!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.areaId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.aisleId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.sectionId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.levelId!" "}</fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="center">${locationInfo.positionId!" "}</fo:block></fo:table-cell>

                                <fo:table-cell padding="${cellPadding}" number-columns-spanned="3">
                                    <fo:block><#if locationInfo.lot?has_content>${ec.resource.expand('LotNameTemplate', '', locationInfo.lot)}</#if> </fo:block></fo:table-cell>
                            </fo:table-row>
                            <fo:table-row font-size="9pt">
                                <fo:table-cell padding="${cellPadding}" number-columns-spanned="9"><fo:block> </fo:block></fo:table-cell>
                                <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${locationInfo.quantity!}</fo:block></fo:table-cell>
                            </fo:table-row>
                        </#list></#if>
                    </#list>
                </fo:table-body>
            </fo:table>
        </#if>
        </fo:flow>
    </fo:page-sequence>
</fo:root>
