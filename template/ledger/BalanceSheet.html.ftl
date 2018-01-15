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
<#assign showPercents = (percents! == "true")>
<#assign currencyFormat = currencyFormat!"#,##0.00">
<#assign percentFormat = percentFormat!"0.0%">

<#macro showClass classInfo depth>
    <#-- skip classes with no balance -->
    <#if (classInfo.totalBalanceByTimePeriod['ALL']!0) == 0 && (classInfo.totalPostedByTimePeriod['ALL']!0) == 0><#return></#if>

    <#assign hasChildren = classInfo.childClassInfoList?has_content>
    <tr>
        <td style="padding-left: ${(depth-1) * 2}.3em;">${ec.l10n.localize(classInfo.className)}</td>
        <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
            <td class="text-right text-mono">${ec.l10n.format(classInfo.postedByTimePeriod['ALL']!0, currencyFormat)}</td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#if showBeginningAndPosted>
                <#assign beginningClassBalance = (classInfo.balanceByTimePeriod[timePeriodId]!0) - (classInfo.postedByTimePeriod[timePeriodId]!0)>
                <td class="text-right text-mono">${ec.l10n.format(beginningClassBalance, currencyFormat)}</td>
                <td class="text-right text-mono">${ec.l10n.format(classInfo.postedByTimePeriod[timePeriodId]!0, currencyFormat)}</td>
            </#if>
            <td class="text-right text-mono">${ec.l10n.format(classInfo.balanceByTimePeriod[timePeriodId]!0, currencyFormat)}</td>
            <#if showPercents>
                <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                <#assign currentAmt = classInfo.balanceByTimePeriod[timePeriodId]!0>
                <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
            </#if>
        </#list>
    </tr>
    <#list classInfo.glAccountInfoList! as glAccountInfo>
        <#if showDetail && ((glAccountInfo.balanceByTimePeriod['ALL']!0) != 0 || (glAccountInfo.postedByTimePeriod['ALL']!0) != 0)>
            <tr>
                <td style="padding-left: ${(depth-1) * 2 + 3}.3em;"><#if accountCodeFormatter??>${accountCodeFormatter.valueToString(glAccountInfo.accountCode)}<#else>${glAccountInfo.accountCode}</#if>: ${glAccountInfo.accountName}</td>
                <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                    <td class="text-right text-mono">${ec.l10n.format(glAccountInfo.postedByTimePeriod['ALL']!0, currencyFormat)}</td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#if showBeginningAndPosted>
                        <#assign beginningGlAccountBalance = (glAccountInfo.balanceByTimePeriod[timePeriodId]!0) - (glAccountInfo.postedByTimePeriod[timePeriodId]!0)>
                        <td class="text-right text-mono">${ec.l10n.format(beginningGlAccountBalance, currencyFormat)}</td>
                        <td class="text-right text-mono">
                            <#if findEntryUrl??>
                                <#assign findEntryInstance = findEntryUrl.getInstance(sri, true).addParameter("glAccountId", glAccountInfo.glAccountId).addParameter("isPosted", "Y").addParameter("timePeriodId", timePeriodId)>
                                <a href="${findEntryInstance.getUrlWithParams()}">${ec.l10n.format(glAccountInfo.postedByTimePeriod[timePeriodId]!0, currencyFormat)}</a>
                            <#else>
                                ${ec.l10n.format(glAccountInfo.postedByTimePeriod[timePeriodId]!0, currencyFormat)}
                            </#if>
                        </td>
                    </#if>
                    <td class="text-right text-mono">${ec.l10n.format(glAccountInfo.balanceByTimePeriod[timePeriodId]!0, currencyFormat)}</td>
                    <#if showPercents>
                        <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                        <#assign currentAmt = glAccountInfo.balanceByTimePeriod[timePeriodId]!0>
                        <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
                    </#if>
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
                <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalPostedByTimePeriod['ALL']!0, currencyFormat)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#if showBeginningAndPosted>
                    <#assign beginningTotalBalance = (classInfo.totalBalanceByTimePeriod[timePeriodId]!0) - (classInfo.totalPostedByTimePeriod[timePeriodId]!0)>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(beginningTotalBalance, currencyFormat)}</strong></td>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalPostedByTimePeriod[timePeriodId]!0, currencyFormat)}</strong></td>
                </#if>
                <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalBalanceByTimePeriod[timePeriodId]!0, currencyFormat)}</strong></td>
                <#if showPercents>
                    <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                    <#assign currentAmt = classInfo.totalBalanceByTimePeriod[timePeriodId]!0>
                    <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
                </#if>
            </#list>
        </tr>
    </#if>
</#macro>

<table class="table table-striped table-hover table-condensed">
    <thead>
        <tr>
            <th>${ec.l10n.localize("Balance Sheet")}</th>
            <#if showBeginningAndPosted && (timePeriodIdList?size > 1)><th class="text-right">${ec.l10n.localize("All Periods Posted")}</th></#if>
            <#list timePeriodIdList as timePeriodId>
                <#if showBeginningAndPosted>
                    <th class="text-right">${timePeriodIdMap[timePeriodId].periodName} ${ec.l10n.localize("Beginning")}</th>
                    <th class="text-right">${ec.l10n.localize("Posted")}</th>
                    <th class="text-right">${ec.l10n.localize("Ending")}</th>
                <#else>
                    <th class="text-right">${timePeriodIdMap[timePeriodId].periodName}</th>
                </#if>
                <#if showPercents><th class="text-right">${ec.l10n.localize("% of Assets")}</th></#if>
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
                    <td class="text-right text-mono"><strong>${ec.l10n.format(netAssetTotalMap.totalPosted['ALL']!0, currencyFormat)}</strong></td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#if showBeginningAndPosted>
                        <td class="text-right text-mono"><strong>${ec.l10n.format((netAssetTotalMap.totalBalance[timePeriodId]!0) - (netAssetTotalMap.totalPosted[timePeriodId]!0), currencyFormat)}</strong></td>
                        <td class="text-right text-mono"><strong>${ec.l10n.format(netAssetTotalMap.totalPosted[timePeriodId]!0, currencyFormat)}</strong></td>
                    </#if>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(netAssetTotalMap.totalBalance[timePeriodId]!0, currencyFormat)}</strong></td>
                    <#if showPercents>
                        <td class="text-right text-mono">${ec.l10n.format(1, percentFormat)}</td>
                    </#if>
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
                    <td class="text-right text-mono"><strong>${ec.l10n.format(equityTotalMap.totalPosted['ALL']!0, currencyFormat)}</strong></td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#if showBeginningAndPosted>
                        <td class="text-right text-mono"><strong>${ec.l10n.format((equityTotalMap.totalBalance[timePeriodId]!0) - (equityTotalMap.totalPosted[timePeriodId]!0), currencyFormat)}</strong></td>
                        <td class="text-right text-mono"><strong>${ec.l10n.format(equityTotalMap.totalPosted[timePeriodId]!0, currencyFormat)}</strong></td>
                    </#if>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(equityTotalMap.totalBalance[timePeriodId]!0, currencyFormat)}</strong></td>
                    <#if showPercents>
                        <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                        <#assign currentAmt = equityTotalMap.totalBalance[timePeriodId]!0>
                        <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
                    </#if>
                </#list>
            </tr>
        </#if>
        <#if liabilityEquityTotalMap??>
        <tr class="text-success" style="border-bottom:solid black;border-top:solid black;">
            <td><strong>${ec.l10n.localize("Liability + Equity Grand Total")}</strong></td>
            <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(liabilityEquityTotalMap.totalPosted['ALL']!0, currencyFormat)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#if showBeginningAndPosted>
                    <td class="text-right text-mono"><strong>${ec.l10n.format((liabilityEquityTotalMap.totalBalance[timePeriodId]!0) - (liabilityEquityTotalMap.totalPosted[timePeriodId]!0), currencyFormat)}</strong></td>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(liabilityEquityTotalMap.totalPosted[timePeriodId]!0, currencyFormat)}</strong></td>
                </#if>
                <td class="text-right text-mono"><strong>${ec.l10n.format(liabilityEquityTotalMap.totalBalance[timePeriodId]!0, currencyFormat)}</strong></td>
                <#if showPercents>
                    <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                    <#assign currentAmt = liabilityEquityTotalMap.totalBalance[timePeriodId]!0>
                    <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
                </#if>
            </#list>
        </tr>
        </#if>

        <tr class="text-info">
            <td><strong>${ec.l10n.localize("Unbooked Net Income")}</strong></td>
        <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
            <td class="text-right text-mono"><strong>${ec.l10n.format(netIncomeOut.totalPosted['ALL']!0, currencyFormat)}</strong></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#if showBeginningAndPosted>
                <td class="text-right text-mono"><strong>${ec.l10n.format((netIncomeOut.totalBalance[timePeriodId]!0) - (netIncomeOut.totalPosted[timePeriodId]!0), currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netIncomeOut.totalPosted[timePeriodId]!0, currencyFormat)}</strong></td>
            </#if>
            <td class="text-right text-mono"><strong>${ec.l10n.format(netIncomeOut.totalBalance[timePeriodId]!0, currencyFormat)}</strong></td>
            <#if showPercents>
                <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                <#assign currentAmt = netIncomeOut.totalBalance[timePeriodId]!0>
                <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
            </#if>
        </#list>
        </tr>

        <tr class="text-success" style="border-bottom:solid black;border-top:solid black;">
            <td><strong>${ec.l10n.localize("Liability + Equity + Unbooked Net Income")}</strong></td>
        <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
            <td class="text-right text-mono"><strong>${ec.l10n.format((liabilityEquityTotalMap.totalPosted['ALL']!0) + (netIncomeOut.totalPosted['ALL']!0), currencyFormat)}</strong></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#if showBeginningAndPosted>
                <td class="text-right text-mono"><strong>${ec.l10n.format((liabilityEquityTotalMap.totalBalance[timePeriodId]!0) - (liabilityEquityTotalMap.totalPosted[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0) - (netIncomeOut.totalPosted[timePeriodId]!0), currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format((liabilityEquityTotalMap.totalPosted[timePeriodId]!0) + (netIncomeOut.totalPosted[timePeriodId]!0), currencyFormat)}</strong></td>
            </#if>
            <td class="text-right text-mono"><strong>${ec.l10n.format((liabilityEquityTotalMap.totalBalance[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0), currencyFormat)}</strong></td>
            <#if showPercents>
                <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                <#assign currentAmt = (liabilityEquityTotalMap.totalBalance[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0)>
                <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
            </#if>
        </#list>
        </tr>
    </tbody>
</table>
