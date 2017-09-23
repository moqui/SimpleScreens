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

<#-- See the mantle.ledger.LedgerReportServices.run#BalanceSheet service for data preparation -->

<#assign showDetail = (detail! == "true")>
<#assign showBeginningAndPosted = (beginningAndPosted! == "true")>

<#macro showClass classInfo depth>
    <#-- skip classes with no balance -->
    <#if (classInfo.totalBalanceByTimePeriod['ALL']!0) == 0 && (classInfo.totalPostedByTimePeriod['ALL']!0) == 0><#return></#if>

    <#assign hasChildren = classInfo.childClassInfoList?has_content>
    <tr>
        <td style="padding-left: ${(depth-1) * 2}.3em;">${ec.l10n.localize(classInfo.className)}</td>
        <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
            <td class="text-right">${ec.l10n.formatCurrency(classInfo.postedByTimePeriod['ALL']!0, currencyUomId)}</td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#if showBeginningAndPosted>
                <#assign beginningClassBalance = (classInfo.balanceByTimePeriod[timePeriodId]!0) - (classInfo.postedByTimePeriod[timePeriodId]!0)>
                <td class="text-right">${ec.l10n.formatCurrency(beginningClassBalance, currencyUomId)}</td>
                <td class="text-right">${ec.l10n.formatCurrency(classInfo.postedByTimePeriod[timePeriodId]!0, currencyUomId)}</td>
            </#if>
            <td class="text-right">${ec.l10n.formatCurrency(classInfo.balanceByTimePeriod[timePeriodId]!0, currencyUomId)}</td>
        </#list>
    </tr>
    <#list classInfo.glAccountInfoList! as glAccountInfo>
        <#if showDetail && ((glAccountInfo.balanceByTimePeriod['ALL']!0) != 0 || (glAccountInfo.postedByTimePeriod['ALL']!0) != 0)>
            <tr>
                <td style="padding-left: ${(depth-1) * 2 + 3}.3em;"><#if accountCodeFormatter??>${accountCodeFormatter.valueToString(glAccountInfo.accountCode)}<#else>${glAccountInfo.accountCode}</#if>: ${glAccountInfo.accountName}</td>
                <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                    <td class="text-right">${ec.l10n.formatCurrency(glAccountInfo.postedByTimePeriod['ALL']!0, currencyUomId)}</td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#if showBeginningAndPosted>
                        <#assign beginningGlAccountBalance = (glAccountInfo.balanceByTimePeriod[timePeriodId]!0) - (glAccountInfo.postedByTimePeriod[timePeriodId]!0)>
                        <td class="text-right">${ec.l10n.formatCurrency(beginningGlAccountBalance, currencyUomId)}</td>
                        <td class="text-right">
                            <#if findEntryUrl??>
                                <#assign findEntryInstance = findEntryUrl.getInstance(sri, true).addParameter("glAccountId", glAccountInfo.glAccountId).addParameter("isPosted", "Y").addParameter("timePeriodId", timePeriodId)>
                                <a href="${findEntryInstance.getUrlWithParams()}">${ec.l10n.formatCurrency(glAccountInfo.postedByTimePeriod[timePeriodId]!0, currencyUomId)}</a>
                            <#else>
                                ${ec.l10n.formatCurrency(glAccountInfo.postedByTimePeriod[timePeriodId]!0, currencyUomId)}
                            </#if>
                        </td>
                    </#if>
                    <td class="text-right">${ec.l10n.formatCurrency(glAccountInfo.balanceByTimePeriod[timePeriodId]!0, currencyUomId)}</td>
                </#list>
            </tr>
        <#else>
            <!-- ${glAccountInfo.accountCode}: ${glAccountInfo.accountName} ${glAccountInfo.balanceByTimePeriod} -->
        </#if>
    </#list>
    <#if hasChildren>
        <#list classInfo.childClassInfoList as childClassInfo>
            <@showClass childClassInfo depth + 1/>
        </#list>
        <tr<#if depth == 1> class="text-info"</#if>>
            <td style="padding-left: ${(depth-1) * 2}.3em;"><strong>${ec.l10n.localize(classInfo.className + " Total")}</strong></td>
            <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(classInfo.totalPostedByTimePeriod['ALL']!0, currencyUomId)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#if showBeginningAndPosted>
                    <#assign beginningTotalBalance = (classInfo.totalBalanceByTimePeriod[timePeriodId]!0) - (classInfo.totalPostedByTimePeriod[timePeriodId]!0)>
                    <td class="text-right"><strong>${ec.l10n.formatCurrency(beginningTotalBalance, currencyUomId)}</strong></td>
                    <td class="text-right"><strong>${ec.l10n.formatCurrency(classInfo.totalPostedByTimePeriod[timePeriodId]!0, currencyUomId)}</strong></td>
                </#if>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(classInfo.totalBalanceByTimePeriod[timePeriodId]!0, currencyUomId)}</strong></td>
            </#list>
        </tr>
    </#if>
</#macro>

<table class="table table-striped table-hover table-condensed">
    <thead>
        <tr>
            <th>${ec.l10n.localize("Balance Sheet")}</th>
            <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                <th class="text-right">${ec.l10n.localize("All Periods Posted")}</th>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#if showBeginningAndPosted>
                    <th class="text-right">${timePeriodIdMap[timePeriodId].periodName} (${ec.l10n.localize("Closed")}: ${timePeriodIdMap[timePeriodId].isClosed}) ${ec.l10n.localize("Beginning")}</th>
                    <th class="text-right">${ec.l10n.localize("Posted")}</th>
                    <th class="text-right">${ec.l10n.localize("Ending")}</th>
                <#else>
                    <th class="text-right">${timePeriodIdMap[timePeriodId].periodName} (${ec.l10n.localize("Closed")}: ${timePeriodIdMap[timePeriodId].isClosed}) ${ec.l10n.localize("Ending")}</th>
                </#if>
            </#list>
        </tr>
    </thead>
    <tbody>
        <#if classInfoById.ASSET??><@showClass classInfoById.ASSET 1/></#if>
        <#if classInfoById.CONTRA_ASSET??><@showClass classInfoById.CONTRA_ASSET 1/></#if>
        <#if netAssetTotalMap??>
            <tr class="text-success" style="border-bottom: solid black;border-top:solid black;">
                <td><strong>${ec.l10n.localize("Net Asset Total")}</strong></td>
                <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                    <td class="text-right"><strong>${ec.l10n.formatCurrency(netAssetTotalMap.totalPosted['ALL']!0, currencyUomId)}</strong></td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#if showBeginningAndPosted>
                        <td class="text-right"><strong>${ec.l10n.formatCurrency((netAssetTotalMap.totalBalance[timePeriodId]!0) - (netAssetTotalMap.totalPosted[timePeriodId]!0), currencyUomId)}</strong></td>
                        <td class="text-right"><strong>${ec.l10n.formatCurrency(netAssetTotalMap.totalPosted[timePeriodId]!0, currencyUomId)}</strong></td>
                    </#if>
                    <td class="text-right"><strong>${ec.l10n.formatCurrency(netAssetTotalMap.totalBalance[timePeriodId]!0, currencyUomId)}</strong></td>
                </#list>
            </tr>
        </#if>

        <#if classInfoById.LIABILITY??><@showClass classInfoById.LIABILITY 1/></#if>

        <#if classInfoById.EQUITY??><@showClass classInfoById.EQUITY 1/></#if>
        <#if classInfoById.CONTRA_EQUITY??><@showClass classInfoById.CONTRA_EQUITY 1/></#if>
        <#if classInfoById.DISTRIBUTION??><@showClass classInfoById.DISTRIBUTION 1/></#if>
        <#if equityTotalMap??>
            <tr class="text-info">
                <td><strong>${ec.l10n.localize("Equity + Contra Equity + Distribution Total")}</strong></td>
                <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                    <td class="text-right"><strong>${ec.l10n.formatCurrency(equityTotalMap.totalPosted['ALL']!0, currencyUomId)}</strong></td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#if showBeginningAndPosted>
                        <td class="text-right"><strong>${ec.l10n.formatCurrency((equityTotalMap.totalBalance[timePeriodId]!0) - (equityTotalMap.totalPosted[timePeriodId]!0), currencyUomId)}</strong></td>
                        <td class="text-right"><strong>${ec.l10n.formatCurrency(equityTotalMap.totalPosted[timePeriodId]!0, currencyUomId)}</strong></td>
                    </#if>
                    <td class="text-right"><strong>${ec.l10n.formatCurrency(equityTotalMap.totalBalance[timePeriodId]!0, currencyUomId)}</strong></td>
                </#list>
            </tr>
        </#if>
        <#if liabilityEquityTotalMap??>
        <tr class="text-success" style="border-bottom:solid black;border-top:solid black;">
            <td><strong>${ec.l10n.localize("Liability + Equity Grand Total")}</strong></td>
            <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(liabilityEquityTotalMap.totalPosted['ALL']!0, currencyUomId)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#if showBeginningAndPosted>
                    <td class="text-right"><strong>${ec.l10n.formatCurrency((liabilityEquityTotalMap.totalBalance[timePeriodId]!0) - (liabilityEquityTotalMap.totalPosted[timePeriodId]!0), currencyUomId)}</strong></td>
                    <td class="text-right"><strong>${ec.l10n.formatCurrency(liabilityEquityTotalMap.totalPosted[timePeriodId]!0, currencyUomId)}</strong></td>
                </#if>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(liabilityEquityTotalMap.totalBalance[timePeriodId]!0, currencyUomId)}</strong></td>
            </#list>
        </tr>
        </#if>


        <tr class="text-info">
            <td><strong>${ec.l10n.localize("Unbooked Net Income")}</strong></td>
        <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
            <td class="text-right"><strong>${ec.l10n.formatCurrency(netIncomeOut.totalPosted['ALL']!0, currencyUomId)}</strong></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#if showBeginningAndPosted>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((netIncomeOut.totalBalance[timePeriodId]!0) - (netIncomeOut.totalPosted[timePeriodId]!0), currencyUomId)}</strong></td>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(netIncomeOut.totalPosted[timePeriodId]!0, currencyUomId)}</strong></td>
            </#if>
            <td class="text-right"><strong>${ec.l10n.formatCurrency(netIncomeOut.totalBalance[timePeriodId]!0, currencyUomId)}</strong></td>
        </#list>
        </tr>

        <tr class="text-success" style="border-bottom:solid black;border-top:solid black;">
            <td><strong>${ec.l10n.localize("Liability + Equity + Unbooked Net Income")}</strong></td>
        <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
            <td class="text-right"><strong>${ec.l10n.formatCurrency((liabilityEquityTotalMap.totalPosted['ALL']!0) + (netIncomeOut.totalPosted['ALL']!0), currencyUomId)}</strong></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#if showBeginningAndPosted>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((liabilityEquityTotalMap.totalBalance[timePeriodId]!0) - (liabilityEquityTotalMap.totalPosted[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0) - (netIncomeOut.totalPosted[timePeriodId]!0), currencyUomId)}</strong></td>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((liabilityEquityTotalMap.totalPosted[timePeriodId]!0) + (netIncomeOut.totalPosted[timePeriodId]!0), currencyUomId)}</strong></td>
            </#if>
            <td class="text-right"><strong>${ec.l10n.formatCurrency((liabilityEquityTotalMap.totalBalance[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0), currencyUomId)}</strong></td>
        </#list>
        </tr>
    </tbody>
</table>
