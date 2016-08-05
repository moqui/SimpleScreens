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

<#-- See the mantle.work.TimeServices.get#TeamTimesheetInfo service for data preparation -->

<#assign cellPadding = "4pt">
<#assign dateFormat = dateFormat!"dd MMM yyyy">
<#assign dateTimeFormat = dateTimeFormat!"yyyy-MM-dd HH:mm">
<#assign extraLines = extraLines!3>

<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Helvetica, sans-serif" font-size="10pt">
    <fo:layout-master-set>
        <fo:simple-page-master master-name="letter" page-width="8.5in" page-height="11in"
                               margin-top="0.5in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
            <fo:region-body margin-top="1.25in" margin-bottom="0.6in"/>
            <fo:region-before extent="1.25in"/>
            <fo:region-after extent="0.5in"/>
        </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="letter" initial-page-number="1" force-page-count="no-force">
        <fo:static-content flow-name="xsl-region-before">
            <fo:table table-layout="fixed" width="7.5in" border="none"><fo:table-body>
                <fo:table-row>
                    <fo:table-cell width="3in" padding="2pt" border="solid black">
                        <fo:block font-size="8pt" text-align="center">Team</fo:block>
                        <fo:block font-size="12pt" text-align="center">${ec.resource.expand('PartyNameTemplate', '', teamDetail)}</fo:block>
                    </fo:table-cell>
                    <fo:table-cell width="3in" padding="2pt" border="solid black">
                        <fo:block font-size="8pt" text-align="center">Company</fo:block>
                        <fo:block font-size="12pt" text-align="center"><#if clientDetail??>${ec.resource.expand('PartyNameTemplate', '', clientDetail)}<#else>&#8199;</#if></fo:block>
                    </fo:table-cell>
                    <fo:table-cell width="1.5in" padding="2pt" border="solid black">
                        <fo:block font-size="8pt" text-align="center">Date</fo:block>
                        <fo:block font-size="12pt" text-align="center"><#if workEffort??>${ec.l10n.format(workEffort.actualStartDate, "dd MMM yyyy")}<#else>&#8199;</#if></fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="2pt" border="solid black" number-rows-spanned="2">
                        <fo:block font-size="8pt" text-align="center">Team</fo:block>
                        <fo:block text-align="center">
                            <fo:instream-foreign-object>
                                <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="${partyId}">
                                    <barcode:code128>
                                        <barcode:height>0.5in</barcode:height>
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
                    <fo:table-cell padding="2pt" border="solid black">
                        <fo:block font-size="8pt" text-align="center">Location</fo:block>
                        <fo:block font-size="12pt" text-align="center"><#if facility??>${ec.resource.expand('FacilityNameTemplate', '', facility)}<#else>&#8199;</#if></fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2pt" border="solid black" number-rows-spanned="2">
                        <fo:block font-size="8pt" text-align="center">Event</fo:block>
                        <#if workEffortId?has_content>
                        <fo:block text-align="center">
                            <fo:instream-foreign-object>
                                <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="${workEffortId}">
                                    <barcode:code128>
                                        <barcode:height>0.5in</barcode:height>
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
                        </#if>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="2pt" border="solid black">
                        <fo:block font-size="8pt" text-align="center">Notes</fo:block>
                        <fo:block font-size="12pt" text-align="center">&#8199;</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body></fo:table>
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after" font-size="8pt">
            <fo:block border-top="thin solid black">
                <fo:block text-align="center">Timesheet for ${teamDetail.pseudoId}<#if clientDetail??> -- ${clientDetail.pseudoId}</#if><#if facility??> -- ${facility.pseudoId}</#if><#if workEffort??> -- ${ec.l10n.format(workEffort.actualStartDate, "dd MMM yyyy")}</#if> -- Printed ${ec.l10n.format(ec.user.nowTimestamp, dateTimeFormat)} -- Page <fo:page-number/></fo:block>
            </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
            <fo:table table-layout="fixed" width="7.5in" border-bottom="solid black">
                <fo:table-header font-size="10pt" font-weight="bold" border-bottom="solid black">
                    <fo:table-cell width="3in" padding="${cellPadding}"><fo:block text-align="left">Team Member</fo:block></fo:table-cell>
                    <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="center">Work Type</fo:block></fo:table-cell>
                    <fo:table-cell width="0.75in" padding="${cellPadding}"><fo:block text-align="center">Start</fo:block></fo:table-cell>
                    <fo:table-cell width="0.75in" padding="${cellPadding}"><fo:block text-align="center">End</fo:block></fo:table-cell>
                    <fo:table-cell width="0.75in" padding="${cellPadding}"><fo:block text-align="center">Hours</fo:block></fo:table-cell>
                    <#-- <fo:table-cell width="0.6in" padding="${cellPadding}"><fo:block text-align="center">Break</fo:block></fo:table-cell> -->
                    <fo:table-cell width="0.75in" padding="${cellPadding}"><fo:block text-align="center">Pieces</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                <#if workEffort??>
                <fo:table-row font-size="9pt" border-bottom="solid black" color="grey">
                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">Default (event #${workEffortId})</fo:block></fo:table-cell>
                    <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">${(workTypeEnum.description)!"&#8199;"}</fo:block></fo:table-cell>
                    <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">${ec.l10n.format(workEffort.actualStartDate, "HH:mm")}</fo:block></fo:table-cell>
                    <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">&#8199;</fo:block></fo:table-cell>
                    <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">${ec.l10n.format(workEffort.actualWorkDuration, "0.00")}</fo:block></fo:table-cell>
                    <#-- <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">${ec.l10n.format(workEffort.actualBreakDuration, "0.00")}</fo:block></fo:table-cell> -->
                    <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">&#8199;</fo:block></fo:table-cell>
                </fo:table-row>
                </#if>
                <#list teamMemberInfoList as teamMemberInfo>
                    <#assign timeEntry = teamMemberInfo.timeEntry!>
                    <#assign teWorkTypeEnum = teamMemberInfo.teWorkTypeEnum!>
                    <fo:table-row font-size="9pt" border-top="solid black">
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${ec.resource.expand('PartyNameTemplate', '', teamMemberInfo)}</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center"><#if timeEntry??>${(teWorkTypeEnum.description)!"&#8199;"}</#if></fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center"><#if timeEntry??>${ec.l10n.format(timeEntry.fromDate, "HH:mm")}</#if></fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center"><#if timeEntry??>${ec.l10n.format(timeEntry.thruDate, "HH:mm")}</#if></fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center"><#if timeEntry??>${ec.l10n.format(timeEntry.hours, "0.00")}</#if></fo:block></fo:table-cell>
                        <#-- <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center"><#if timeEntry??>${ec.l10n.format(timeEntry.breakHours, "0.00")}</#if></fo:block></fo:table-cell> -->
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center"><#if timeEntry??>${ec.l10n.format(timeEntry.pieceCount, "0")}</#if></fo:block></fo:table-cell>
                    </fo:table-row>
                </#list>
                <#list 1..extraLines as extraLine>
                    <fo:table-row font-size="9pt" border-top="solid black">
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">&#8199;</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">&#8199;</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">&#8199;</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">&#8199;</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">&#8199;</fo:block></fo:table-cell>
                        <#-- <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">&#8199;</fo:block></fo:table-cell> -->
                        <fo:table-cell padding="${cellPadding}" border-left="solid grey"><fo:block text-align="center">&#8199;</fo:block></fo:table-cell>
                    </fo:table-row>
                </#list>
                </fo:table-body>
            </fo:table>
        </fo:flow>
    </fo:page-sequence>
</fo:root>
