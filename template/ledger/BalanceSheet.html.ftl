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
<#assign currencyFormat = currencyFormat!"#,##0.00;(#,##0.00)">
<#assign percentFormat = percentFormat!"0.0%">
<#assign indentMult = indentMult!1>

<#macro showClass classInfo depth>
    <#-- skip classes with no balance -->
    <#if (classInfo.totalBalanceByTimePeriod['ALL']!0) == 0 && (classInfo.totalPostedByTimePeriod['ALL']!0) == 0><#return></#if>

    <#assign hasChildren = classInfo.childClassInfoList?has_content>
    <tr>
        <td style="padding-left: ${((depth-1) * indentMult) + 0.3}em;">${ec.l10n.localize(classInfo.className)}</td>
        <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
            <#assign currentAmt = classInfo.postedByTimePeriod['ALL']!0>
            <td class="text-right text-mono">${ec.l10n.format(currentAmt, currencyFormat)}<#if (currentAmt >= 0)>&nbsp;</#if></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#if showBeginningAndPosted>
                <#assign beginningClassBalance = (classInfo.balanceByTimePeriod[timePeriodId]!0) - (classInfo.postedByTimePeriod[timePeriodId]!0)>
                <#assign postedAmount = classInfo.postedByTimePeriod[timePeriodId]!0>
                <td class="text-right text-mono"><#if beginningClassBalance != 0>${ec.l10n.format(beginningClassBalance, currencyFormat)}<#if (beginningClassBalance >= 0)>&nbsp;</#if><#else>&nbsp;</#if></td>
                <td class="text-right text-mono"><#if postedAmount != 0>${ec.l10n.format(postedAmount, currencyFormat)}<#if (postedAmount >= 0)>&nbsp;</#if><#else>&nbsp;</#if></td>
            </#if>
            <#assign classPerAmount = classInfo.balanceByTimePeriod[timePeriodId]!0>
            <td class="text-right text-mono"><#if classPerAmount != 0>${ec.l10n.format(classPerAmount, currencyFormat)}<#if (classPerAmount >= 0)>&nbsp;</#if><#else>&nbsp;</#if></td>
            <#if showPercents>
                <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                <td class="text-right text-mono"><#if classPerAmount != 0 && assetTotalAmt != 0>${ec.l10n.format(classPerAmount/assetTotalAmt, percentFormat)}<#else>&nbsp;</#if></td>
            </#if>
        </#list>
    </tr>
    <#list classInfo.glAccountInfoList! as glAccountInfo>
        <#if showDetail && ((glAccountInfo.balanceByTimePeriod['ALL']!0) != 0 || (glAccountInfo.postedByTimePeriod['ALL']!0) != 0)>
            <tr>
                <td style="padding-left: ${(depth-1) * indentMult + (indentMult * 1.5) + 0.3}em;"><#if accountCodeFormatter??>${accountCodeFormatter.valueToString(glAccountInfo.accountCode)}<#else>${glAccountInfo.accountCode}</#if>: ${glAccountInfo.accountName}</td>
                <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                    <#assign currentAmt = glAccountInfo.postedByTimePeriod['ALL']!0>
                    <td class="text-right text-mono">${ec.l10n.format(currentAmt, currencyFormat)}<#if (currentAmt >= 0)>&nbsp;</#if></td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#if showBeginningAndPosted>
                        <#assign beginningGlAccountBalance = (glAccountInfo.balanceByTimePeriod[timePeriodId]!0) - (glAccountInfo.postedByTimePeriod[timePeriodId]!0)>
                        <#assign postedAmount = glAccountInfo.postedByTimePeriod[timePeriodId]!0>
                        <td class="text-right text-mono">${ec.l10n.format(beginningGlAccountBalance, currencyFormat)}<#if (beginningGlAccountBalance >= 0)>&nbsp;</#if></td>
                        <#if findEntryUrl??>
                            <#assign findEntryInstance = findEntryUrl.getInstance(sri, true).addParameter("glAccountId", glAccountInfo.glAccountId).addParameter("isPosted", "Y").addParameter("timePeriodId", timePeriodId)>
                            <td class="text-right text-mono"><a href="${findEntryInstance.getUrlWithParams()}">${ec.l10n.format(postedAmount, currencyFormat)}</a><#if (postedAmount >= 0)>&nbsp;</#if></td>
                        <#else>
                            <td class="text-right text-mono">${ec.l10n.format(postedAmount, currencyFormat)}<#if (postedAmount >= 0)>&nbsp;</#if></td>
                        </#if>
                    </#if>
                    <#assign currentAmt = glAccountInfo.balanceByTimePeriod[timePeriodId]!0>
                    <td class="text-right text-mono">${ec.l10n.format(currentAmt, currencyFormat)}<#if (currentAmt >= 0)>&nbsp;</#if></td>
                    <#if showPercents>
                        <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
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
        <tr<#if depth == 1> class="text-info" style="border-bottom:solid black;border-top:solid black;"</#if>>
            <td style="padding-left: ${((depth-1) * indentMult) + 0.3}em;"><strong>${ec.l10n.localize("Total " + classInfo.className)}</strong></td>
            <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                <#assign currentAmt = classInfo.totalPostedByTimePeriod['ALL']!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#if showBeginningAndPosted>
                    <#assign beginningTotalBalance = (classInfo.totalBalanceByTimePeriod[timePeriodId]!0) - (classInfo.totalPostedByTimePeriod[timePeriodId]!0)>
                    <#assign postedAmount = classInfo.totalPostedByTimePeriod[timePeriodId]!0>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(beginningTotalBalance, currencyFormat)}</strong><#if (beginningTotalBalance >= 0)>&nbsp;</#if></td>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(postedAmount, currencyFormat)}</strong><#if (postedAmount >= 0)>&nbsp;</#if></td>
                </#if>
                <#assign currentAmt = classInfo.totalBalanceByTimePeriod[timePeriodId]!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
                <#if showPercents>
                    <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                    <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
                </#if>
            </#list>
        </tr>
    </#if>
</#macro>

<table class="table table-striped table-hover table-condensed">
    <thead>
        <tr>
            <th>${organizationName!""} - ${ec.l10n.localize("Balance Sheet")} <small>(${ec.l10n.format(ec.user.nowTimestamp, 'dd MMM yyyy HH:mm')})</small></th>
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
        <#if classInfoById.LIABILITY??><@showClass classInfoById.LIABILITY 1/></#if>

        <#if classInfoById.EQUITY??><@showClass classInfoById.EQUITY 1/></#if>
        <#if classInfoById.DISTRIBUTION??><@showClass classInfoById.DISTRIBUTION 1/></#if>
        <#if equityTotalMap??>
            <tr class="text-info">
                <td><strong>${ec.l10n.localize("Total Equity + Distribution")}</strong></td>
                <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                    <#assign currentAmt = equityTotalMap.totalPosted['ALL']!0>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#if showBeginningAndPosted>
                        <#assign beginningTotalBalance = (equityTotalMap.totalBalance[timePeriodId]!0) - (equityTotalMap.totalPosted[timePeriodId]!0)>
                        <#assign postedAmount = equityTotalMap.totalPosted[timePeriodId]!0>
                        <td class="text-right text-mono"><strong>${ec.l10n.format(beginningTotalBalance, currencyFormat)}</strong><#if (beginningTotalBalance >= 0)>&nbsp;</#if></td>
                        <td class="text-right text-mono"><strong>${ec.l10n.format(postedAmount, currencyFormat)}</strong><#if (postedAmount >= 0)>&nbsp;</#if></td>
                    </#if>
                    <#assign currentAmt = equityTotalMap.totalBalance[timePeriodId]!0>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
                    <#if showPercents>
                        <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                        <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
                    </#if>
                </#list>
            </tr>
        </#if>
        <#if liabilityEquityTotalMap??>
        <tr class="text-success" style="border-bottom:solid black;">
            <td><strong>${ec.l10n.localize("Grand Total Liability + Equity")}</strong></td>
            <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
                <#assign currentAmt = liabilityEquityTotalMap.totalPosted['ALL']!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#if showBeginningAndPosted>
                    <#assign beginningTotalBalance = (liabilityEquityTotalMap.totalBalance[timePeriodId]!0) - (liabilityEquityTotalMap.totalPosted[timePeriodId]!0)>
                    <#assign postedAmount = liabilityEquityTotalMap.totalPosted[timePeriodId]!0>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(beginningTotalBalance, currencyFormat)}</strong><#if (beginningTotalBalance >= 0)>&nbsp;</#if></td>
                    <td class="text-right text-mono"><strong>${ec.l10n.format(postedAmount, currencyFormat)}</strong><#if (postedAmount >= 0)>&nbsp;</#if></td>
                </#if>
                <#assign currentAmt = liabilityEquityTotalMap.totalBalance[timePeriodId]!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
                <#if showPercents>
                    <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                    <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
                </#if>
            </#list>
        </tr>
        </#if>

        <tr class="text-info">
            <td><strong>${ec.l10n.localize("Unbooked Net Income")}</strong></td>
        <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
            <#assign currentAmt = netIncomeOut.totalPosted['ALL']!0>
            <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#if showBeginningAndPosted>
                <#assign beginningTotalBalance = (netIncomeOut.totalBalance[timePeriodId]!0) - (netIncomeOut.totalPosted[timePeriodId]!0)>
                <#assign postedAmount = netIncomeOut.totalPosted[timePeriodId]!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(beginningTotalBalance, currencyFormat)}</strong><#if (beginningTotalBalance >= 0)>&nbsp;</#if></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(postedAmount, currencyFormat)}</strong><#if (postedAmount >= 0)>&nbsp;</#if></td>
            </#if>
            <#assign currentAmt = netIncomeOut.totalBalance[timePeriodId]!0>
            <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
            <#if showPercents>
                <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
            </#if>
        </#list>
        </tr>

        <tr class="text-success" style="border-bottom:solid black;">
            <td><strong>${ec.l10n.localize("Liability + Equity + Unbooked Net Income")}</strong></td>
        <#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
            <#assign currentAmt = (liabilityEquityTotalMap.totalPosted['ALL']!0) + (netIncomeOut.totalPosted['ALL']!0)>
            <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#if showBeginningAndPosted>
                <#assign beginningTotalBalance = (liabilityEquityTotalMap.totalBalance[timePeriodId]!0) - (liabilityEquityTotalMap.totalPosted[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0) - (netIncomeOut.totalPosted[timePeriodId]!0)>
                <#assign postedAmount = (liabilityEquityTotalMap.totalPosted[timePeriodId]!0) + (netIncomeOut.totalPosted[timePeriodId]!0)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(beginningTotalBalance, currencyFormat)}</strong><#if (beginningTotalBalance >= 0)>&nbsp;</#if></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(postedAmount, currencyFormat)}</strong><#if (postedAmount >= 0)>&nbsp;</#if></td>
            </#if>
            <#assign currentAmt = (liabilityEquityTotalMap.totalBalance[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0)>
            <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
            <#if showPercents>
                <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                <td class="text-right text-mono"><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if></td>
            </#if>
        </#list>
        </tr>
    </tbody>
</table>
