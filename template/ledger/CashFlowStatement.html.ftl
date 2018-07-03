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

<#-- See the mantle.ledger.LedgerReportServices.run#CashFlowStatement service for data preparation -->

<#assign showDetail = (detail! == "true")>
<#assign currencyFormat = currencyFormat!"#,##0.00">

<#macro showClass classInfo depth>
    <#-- skip classes with nothing posted and no balance -->
    <#if (classInfo.totalBalanceByTimePeriod['ALL']!0) == 0 && (classInfo.totalPostedByTimePeriod['ALL']!0) == 0><#return></#if>

    <tr>
        <td style="padding-left: ${(depth-1) * 2}.3em;">${ec.l10n.localize(classInfo.className)}</td>
        <#if (timePeriodIdList?size > 1)>
            <#assign beginningClassBalance = (classInfo.balanceByTimePeriod['ALL']!0) - (classInfo.postedByTimePeriod['ALL']!0)>
            <td class="text-right text-mono">${ec.l10n.format(classInfo.postedByTimePeriod['ALL']!0, currencyFormat)}</td>
            <td class="text-right text-mono">${ec.l10n.format(beginningClassBalance, currencyFormat)}</td>
            <td class="text-right text-mono">${ec.l10n.format(classInfo.balanceByTimePeriod['ALL']!0, currencyFormat)}</td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#assign beginningClassBalance = (classInfo.balanceByTimePeriod[timePeriodId]!0) - (classInfo.postedByTimePeriod[timePeriodId]!0)>
            <td class="text-right text-mono">${ec.l10n.format(classInfo.postedByTimePeriod[timePeriodId]!0, currencyFormat)}</td>
            <td class="text-right text-mono">${ec.l10n.format(beginningClassBalance, currencyFormat)}</td>
            <td class="text-right text-mono">${ec.l10n.format(classInfo.balanceByTimePeriod[timePeriodId]!0, currencyFormat)}</td>
        </#list>
    </tr>
    <#list classInfo.glAccountInfoList! as glAccountInfo>
        <#if showDetail>
            <tr>
                <td style="padding-left: ${(depth-1) * 2 + 3}.3em;"><#if accountCodeFormatter??>${accountCodeFormatter.valueToString(glAccountInfo.accountCode)}<#else>${glAccountInfo.accountCode}</#if>: ${glAccountInfo.accountName}</td>
                <#if (timePeriodIdList?size > 1)>
                    <#assign beginningGlAccountBalance = (glAccountInfo.balanceByTimePeriod['ALL']!0) - (glAccountInfo.postedByTimePeriod['ALL']!0)>
                    <td class="text-right text-mono">${ec.l10n.format(glAccountInfo.postedByTimePeriod['ALL']!0, currencyFormat)}</td>
                    <td class="text-right text-mono">${ec.l10n.format(beginningGlAccountBalance, currencyFormat)}</td>
                    <td class="text-right text-mono">${ec.l10n.format(glAccountInfo.balanceByTimePeriod['ALL']!0, currencyFormat)}</td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#assign beginningGlAccountBalance = (glAccountInfo.balanceByTimePeriod[timePeriodId]!0) - (glAccountInfo.postedByTimePeriod[timePeriodId]!0)>
                    <td class="text-right text-mono">
                        <#if findEntryUrl??>
                            <#assign findEntryInstance = findEntryUrl.getInstance(sri, true).addParameter("glAccountId", glAccountInfo.glAccountId).addParameter("isPosted", "Y").addParameter("timePeriodId", timePeriodId)>
                            <a href="${findEntryInstance.getUrlWithParams()}">${ec.l10n.format(glAccountInfo.postedByTimePeriod[timePeriodId]!0, currencyFormat)}</a>
                        <#else>
                            ${ec.l10n.format(glAccountInfo.postedByTimePeriod[timePeriodId]!0, currencyFormat)}
                        </#if>
                    </td>
                    <td class="text-right text-mono">${ec.l10n.format(beginningGlAccountBalance, currencyFormat)}</td>
                    <td class="text-right text-mono">${ec.l10n.format(glAccountInfo.balanceByTimePeriod[timePeriodId]!0, currencyFormat)}</td>
                </#list>
            </tr>
        <#else>
            <!-- ${glAccountInfo.accountCode}: ${glAccountInfo.accountName} ${glAccountInfo.balanceByTimePeriod} -->
        </#if>
    </#list>
    <#list classInfo.childClassInfoList as childClassInfo>
        <@showClass childClassInfo depth + 1/>
    </#list>
    <#if classInfo.childClassInfoList?has_content>
        <tr<#if depth == 1> class="text-info"</#if>>
            <td><strong>${ec.l10n.localize(classInfo.className + " Total")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <#assign beginningTotalBalance = (classInfo.totalBalanceByTimePeriod['ALL']!0) - (classInfo.totalPostedByTimePeriod['ALL']!0)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalPostedByTimePeriod['ALL']!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(beginningTotalBalance, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalBalanceByTimePeriod['ALL']!0, currencyFormat)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#assign beginningTotalBalance = (classInfo.totalBalanceByTimePeriod[timePeriodId]!0) - (classInfo.totalPostedByTimePeriod[timePeriodId]!0)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalPostedByTimePeriod[timePeriodId]!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(beginningTotalBalance, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalBalanceByTimePeriod[timePeriodId]!0, currencyFormat)}</strong></td>
            </#list>
        </tr>
    </#if>
</#macro>
<#macro showClassTotals classInfo>
    <tr class="text-info">
        <td style="padding-left: 0.3em;"><strong>${ec.l10n.localize(classInfo.className)}</strong></td>
        <#if (timePeriodIdList?size > 1)>
            <#assign beginningClassBalance = (classInfo.totalBalanceByTimePeriod['ALL']!0) - (classInfo.totalPostedByTimePeriod['ALL']!0)>
            <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalPostedByTimePeriod['ALL']!0, currencyFormat)}</strong></td>
            <td class="text-right text-mono"><strong><#-- ${ec.l10n.format(beginningClassBalance, currencyFormat)}--> </strong></td>
            <td class="text-right text-mono"><strong><#-- ${ec.l10n.format(classInfo.totalBalanceByTimePeriod['ALL']!0, currencyFormat)} --> </strong></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#assign beginningClassBalance = (classInfo.totalBalanceByTimePeriod[timePeriodId]!0) - (classInfo.totalPostedByTimePeriod[timePeriodId]!0)>
            <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalPostedByTimePeriod[timePeriodId]!0, currencyFormat)}</strong></td>
            <td class="text-right text-mono"><strong><#-- ${ec.l10n.format(beginningClassBalance, currencyFormat)}--> </strong></td>
            <td class="text-right text-mono"><strong><#-- ${ec.l10n.format(classInfo.totalBalanceByTimePeriod[timePeriodId]!0, currencyFormat)} --> </strong></td>
        </#list>
    </tr>
</#macro>

<table class="table table-striped table-hover table-condensed">
    <thead>
        <tr>
            <th>${ec.l10n.localize("Cash Flow Statement")}</th>
            <#if (timePeriodIdList?size > 1)>
                <th class="text-right">${ec.l10n.localize("All Periods Posted")}</th>
                <th class="text-right">${ec.l10n.localize("Beginning")}</th>
                <th class="text-right">${ec.l10n.localize("Ending")}</th>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <th class="text-right">${timePeriodIdMap[timePeriodId].periodName} ${ec.l10n.localize("Posted")}</th>
                <th class="text-right">${ec.l10n.localize("Beginning")}</th>
                <th class="text-right">${ec.l10n.localize("Ending")}</th>
            </#list>
        </tr>
    </thead>
    <tbody>
        <tr style="border-top: solid black;">
            <td><strong>${ec.l10n.localize("Operating Activities")}</strong></td>
            <#if (timePeriodIdList?size > 1)><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td></#if>
            <#list timePeriodIdList as timePeriodId><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td></#list>
        </tr>

        <#if classInfoById.REVENUE??><@showClassTotals classInfoById.REVENUE/></#if>
        <#if classInfoById.COST_OF_SALES??><@showClassTotals classInfoById.COST_OF_SALES/></#if>
        <#if classInfoById.INCOME??><@showClassTotals classInfoById.INCOME/></#if>
        <#if classInfoById.EXPENSE??><@showClassTotals classInfoById.EXPENSE/></#if>
        <#if classInfoById.NON_OP_EXPENSE??><@showClassTotals classInfoById.NON_OP_EXPENSE/></#if>
        <tr class="text-warning">
            <td><strong>${ec.l10n.localize("Net Income (see details on Income Statement)")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netIncomeMap['ALL']!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netIncomeMap[timePeriodId]!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#list>
        </tr>

        <#if classInfoById.CURRENT_ASSET??><@showClass classInfoById.CURRENT_ASSET 1/></#if>
        <#if classInfoById.OTHER_ASSET??><@showClass classInfoById.OTHER_ASSET 1/></#if>
        <#if classInfoById.CURRENT_LIABILITY??><@showClass classInfoById.CURRENT_LIABILITY 1/></#if>
        <tr class="text-success">
            <td><strong>${ec.l10n.localize("Net Cash Operating Activities")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netOperatingActivityMap['ALL']!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netOperatingActivityMap[timePeriodId]!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#list>
        </tr>

        <tr style="border-top: solid black;">
            <td><strong>${ec.l10n.localize("Investing Activities")}</strong></td>
            <#if (timePeriodIdList?size > 1)><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td></#if>
            <#list timePeriodIdList as timePeriodId><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td></#list>
        </tr>
        <#if classInfoById.LONG_TERM_ASSET??><@showClass classInfoById.LONG_TERM_ASSET 1/></#if>
        <tr class="text-success">
            <td><strong>${ec.l10n.localize("Net Cash Investing Activities")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netInvestingActivityMap['ALL']!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netInvestingActivityMap[timePeriodId]!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#list>
        </tr>

        <tr style="border-top: solid black;">
            <td><strong>${ec.l10n.localize("Financing Activities")}</strong></td>
            <#if (timePeriodIdList?size > 1)><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td></#if>
            <#list timePeriodIdList as timePeriodId><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td><td class="text-right text-mono"> </td></#list>
        </tr>
        <#if classInfoById.DISTRIBUTION??><@showClass classInfoById.DISTRIBUTION 1/></#if>
        <#if classInfoById.EQUITY??><@showClass classInfoById.EQUITY 1/></#if>
        <#if classInfoById.LONG_TERM_LIABILITY??><@showClass classInfoById.LONG_TERM_LIABILITY 1/></#if>
        <tr class="text-success">
            <td><strong>${ec.l10n.localize("Net Cash Financing Activities")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netFinancingActivityMap['ALL']!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netFinancingActivityMap[timePeriodId]!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#list>
        </tr>

        <tr class="text-success" style="border-top: solid black;">
            <td><strong>${ec.l10n.localize("Net Increase in Cash")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right text-mono"><strong>${ec.l10n.format((netOperatingActivityMap['ALL']!0) + (netInvestingActivityMap['ALL']!0) + (netFinancingActivityMap['ALL']!0), currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right text-mono"><strong>${ec.l10n.format((netOperatingActivityMap[timePeriodId]!0) + (netInvestingActivityMap[timePeriodId]!0) + (netFinancingActivityMap[timePeriodId]!0), currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#list>
        </tr>
    </tbody>
</table>
