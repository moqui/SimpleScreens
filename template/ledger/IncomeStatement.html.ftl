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
<#assign showDiff = (timePeriodIdList?size == 2)>
<#assign showPercents = (percents! == "true")>
<#assign showCharts = (charts! == "true")>
<#assign currencyFormat = currencyFormat!"#,##0.00;(#,##0.00)">
<#assign percentFormat = percentFormat!"0.0%">
<#assign indentMult = indentMult!1>

<#assign backgroundColors = ['rgba(92, 184, 92, 0.5)','rgba(91, 192, 222, 0.5)','rgba(240, 173, 78, 0.5)','rgba(217, 83, 79, 0.5)',
'rgba(60, 118, 61, 0.5)','rgba(49, 112, 143, 0.5)','rgba(138, 109, 59, 0.5)','rgba(169, 68, 66, 0.5)',
'rgba(223, 240, 216, 0.6)','rgba(217, 237, 247, 0.6)','rgba(252, 248, 227, 0.6)','rgba(242, 222, 222, 0.6)']>

<#macro showClass classInfo depth showLess=false>
    <#-- skip classes with nothing posted -->
    <#if (classInfo.totalPostedNoClosingByTimePeriod['ALL']!0) == 0><#return></#if>
    <#if showLess><#assign negMult = -1><#else><#assign negMult = 1></#if>
    <tr>
        <td style="padding-left: ${((depth-1) * indentMult) + 0.3}em;">${ec.l10n.localize(classInfo.className)}<#if showLess && depth == 1> (${ec.l10n.localize("less")})</#if></td>
        <#if (timePeriodIdList?size > 1)>
            <#assign classPerAmount = (classInfo.postedNoClosingByTimePeriod['ALL']!0)*negMult>
            <td class="text-right text-mono">${ec.l10n.format(classPerAmount, currencyFormat)}<#if (classPerAmount >= 0)>&nbsp;</#if></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#assign classPerAmount = (classInfo.postedNoClosingByTimePeriod[timePeriodId]!0)*negMult>
            <td class="text-right text-mono"><#if classPerAmount != 0>${ec.l10n.format(classPerAmount, currencyFormat)}<#if (classPerAmount >= 0)>&nbsp;</#if><#else>&nbsp;</#if></td>
            <#if showPercents>
                <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
                <td class="text-right text-mono"><#if classPerAmount != 0 && netRevenueAmt != 0>${ec.l10n.format(classPerAmount/netRevenueAmt, percentFormat)}<#else>&nbsp;</#if></td>
            </#if>
        </#list>
        <#if showDiff>
            <#assign diffAmount = ((classInfo.postedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfo.postedNoClosingByTimePeriod[timePeriodIdList[0]]!0))*negMult>
            <td class="text-right text-mono">${ec.l10n.format(diffAmount, currencyFormat)}<#if (diffAmount >= 0)>&nbsp;</#if></td>
        </#if>
    </tr>
    <#list classInfo.glAccountInfoList! as glAccountInfo>
        <#assign glAccountAllAmt = (glAccountInfo.postedNoClosingByTimePeriod['ALL']!0)*negMult>
        <#if showDetail && glAccountAllAmt != 0>
            <tr>
                <td style="padding-left: ${(depth-1) * indentMult + (indentMult * 1.5) + 0.3}em;"><#if accountCodeFormatter??>${accountCodeFormatter.valueToString(glAccountInfo.accountCode)}<#else>${glAccountInfo.accountCode}</#if>: ${glAccountInfo.accountName}</td>
                <#if (timePeriodIdList?size > 1)>
                    <td class="text-right text-mono">${ec.l10n.format(glAccountAllAmt, currencyFormat)}<#if (glAccountAllAmt >= 0)>&nbsp;</#if></td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <#assign currentAmt = (glAccountInfo.postedNoClosingByTimePeriod[timePeriodId]!0)*negMult>
                    <#if findEntryUrl??>
                        <#assign findEntryInstance = findEntryUrl.getInstance(sri, true).addParameter("glAccountId", glAccountInfo.glAccountId).addParameter("isPosted", "Y").addParameter("timePeriodId", timePeriodId)>
                        <td class="text-right text-mono"><a href="${findEntryInstance.getUrlWithParams()}">${ec.l10n.format(currentAmt, currencyFormat)}</a><#if (currentAmt >= 0)>&nbsp;</#if></td>
                    <#else>
                        <td class="text-right text-mono">${ec.l10n.format(currentAmt, currencyFormat)}<#if (currentAmt >= 0)>&nbsp;</#if></td>
                    </#if>
                    <#if showPercents>
                        <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
                        <td class="text-right text-mono"><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if></td>
                    </#if>
                </#list>
                <#if showDiff>
                    <#assign diffAmount = ((glAccountInfo.postedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (glAccountInfo.postedNoClosingByTimePeriod[timePeriodIdList[0]]!0))*negMult>
                    <td class="text-right text-mono">${ec.l10n.format(diffAmount, currencyFormat)}<#if (diffAmount >= 0)>&nbsp;</#if></td>
                </#if>
            </tr>
        <#else>
            <!-- ${glAccountInfo.accountCode}: ${glAccountInfo.accountName} ${glAccountInfo.postedNoClosingByTimePeriod} -->
        </#if>
    </#list>
    <#list classInfo.childClassInfoList as childClassInfo>
        <@showClass childClassInfo depth+1 showLess/>
    </#list>
    <#if classInfo.childClassInfoList?has_content>
        <tr<#if depth == 1> class="text-info"</#if>>
            <td style="padding-left: ${((depth-1) * indentMult) + 0.3}em;"><strong>${ec.l10n.localize("Total " + classInfo.className)}</strong><#if showLess && depth == 1> (${ec.l10n.localize("less")})</#if></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right text-mono"><strong>
                    ${ec.l10n.format((classInfo.totalPostedNoClosingByTimePeriod['ALL']!0)*negMult, currencyFormat)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#assign currentAmt = (classInfo.totalPostedNoClosingByTimePeriod[timePeriodId]!0)*negMult>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}<#if (currentAmt >= 0)>&nbsp;</#if></strong></td>
                <#if showPercents>
                    <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
                    <td class="text-right text-mono"><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if></td>
                </#if>
            </#list>
            <#if showDiff>
                <#assign diffAmount = ((classInfo.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfo.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0))*negMult>
                <td class="text-right text-mono"><strong>${ec.l10n.format(diffAmount, currencyFormat)}</strong><#if (diffAmount >= 0)>&nbsp;</#if></td>
            </#if>
        </tr>
    </#if>
</#macro>

<table class="table table-striped table-hover table-condensed">
    <thead>
        <tr>
            <th>${organizationName!""} - ${ec.l10n.localize("Income Statement")} <small>(${ec.l10n.format(ec.user.nowTimestamp, 'dd MMM yyyy HH:mm')})</small></th>
            <#if (timePeriodIdList?size > 1)><th class="text-right">${ec.l10n.localize("All Periods")}</th></#if>
            <#list timePeriodIdList as timePeriodId>
                <th class="text-right">${timePeriodIdMap[timePeriodId].periodName}</th>
                <#if showPercents><th class="text-right">${ec.l10n.localize("% of Revenue")}</th></#if>
            </#list>
            <#if showDiff><th class="text-right">${ec.l10n.localize("Difference")}</th></#if>
        </tr>
    </thead>
    <tbody>

        <@showClass classInfoById.REVENUE 1/>
        <@showClass classInfoById.COST_OF_SALES 1 true/>
        <tr class="text-success" style="border-bottom: solid black;">
            <td><strong>${ec.l10n.localize("Gross Profit On Sales")}</strong> (${ec.l10n.localize("Net Revenue")} - ${ec.l10n.localize("Cost of Sales")})</td>
            <#if (timePeriodIdList?size > 1)>
                <#assign currentAmt = grossProfitOnSalesMap['ALL']!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#assign currentAmt = grossProfitOnSalesMap[timePeriodId]!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
                <#if showPercents>
                    <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
                    <td class="text-right text-mono"><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if></td>
                </#if>
            </#list>
            <#if showDiff>
                <#assign diffAmount = (grossProfitOnSalesMap[timePeriodIdList[1]]!0) - (grossProfitOnSalesMap[timePeriodIdList[0]]!0)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(diffAmount, currencyFormat)}</strong><#if (diffAmount >= 0)>&nbsp;</#if></td>
            </#if>
        </tr>

        <@showClass classInfoById.EXPENSE 1 true/>
        <tr class="text-success" style="border-bottom: solid black;">
            <td><strong>${ec.l10n.localize("Net Operating Income")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <#assign currentAmt = netOperatingIncomeMap['ALL']!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#assign currentAmt = netOperatingIncomeMap[timePeriodId]!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
                <#if showPercents>
                    <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
                    <td class="text-right text-mono"><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if></td>
                </#if>
            </#list>
            <#if showDiff>
                <#assign diffAmount = (netOperatingIncomeMap[timePeriodIdList[1]]!0) - (netOperatingIncomeMap[timePeriodIdList[0]]!0)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(diffAmount, currencyFormat)}</strong><#if (diffAmount >= 0)>&nbsp;</#if></td>
            </#if>
        </tr>

        <@showClass classInfoById.INCOME 1/>
        <@showClass classInfoById.NON_OP_EXPENSE 1 true/>
        <tr class="text-success" style="border-bottom: solid black;">
            <td><strong>${ec.l10n.localize("Net Non-operating Income")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <#assign currentAmt = netNonOperatingIncomeMap['ALL']!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#assign currentAmt = netNonOperatingIncomeMap[timePeriodId]!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
                <#if showPercents>
                    <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
                    <td class="text-right text-mono"><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if></td>
                </#if>
            </#list>
            <#if showDiff>
                <#assign diffAmount = (netNonOperatingIncomeMap[timePeriodIdList[1]]!0) - (netNonOperatingIncomeMap[timePeriodIdList[0]]!0)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(diffAmount, currencyFormat)}</strong><#if (diffAmount >= 0)>&nbsp;</#if></td>
            </#if>
        </tr>

        <tr class="text-success" style="border-bottom: solid black;">
            <td><strong>${ec.l10n.localize("Net Income")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <#assign currentAmt = netIncomeMap['ALL']!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#assign currentAmt = netIncomeMap[timePeriodId]!0>
                <td class="text-right text-mono"><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
                <#if showPercents>
                    <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
                    <td class="text-right text-mono"><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if></td>
                </#if>
            </#list>
            <#if showDiff>
                <#assign diffAmount = (netIncomeMap[timePeriodIdList[1]]!0) - (netIncomeMap[timePeriodIdList[0]]!0)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(diffAmount, currencyFormat)}</strong><#if (diffAmount >= 0)>&nbsp;</#if></td>
            </#if>
        </tr>
    </tbody>
</table>

<#if showCharts>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js" type="text/javascript"></script>
    <ul class="float-plain" style="margin-top:12px;">
    <#if (timePeriodIdList?size > 1) && topExpenseByTimePeriod['ALL']?has_content>
        <#assign topExpenseList = topExpenseByTimePeriod['ALL']>
        <li>
            <div class="text-center"><strong>Expenses All Periods</strong></div>
            <canvas id="ExpenseChartAll" style="width:360px;"></canvas>
            <script>
                var expenseChartAll = new Chart(document.getElementById("ExpenseChartAll"), { type: 'pie',
                    data: { labels:[<#list topExpenseList! as topExpense>'${topExpense.className}'<#sep>,</#list>],
                        datasets:[{ data:[<#list topExpenseList! as topExpense>${topExpense.amount?c}<#sep>,</#list>],
                        backgroundColor:[<#list backgroundColors as color>'${color}'<#sep>,</#list>] }]
                    }
                });
            </script>
        </li>
    </#if>
    <#list timePeriodIdList as timePeriodId><#if topExpenseByTimePeriod[timePeriodId]?has_content>
        <#assign topExpenseList = topExpenseByTimePeriod[timePeriodId]>
        <li>
            <div class="text-center"><strong>Expenses ${timePeriodIdMap[timePeriodId].periodName}</strong></div>
            <canvas id="ExpenseChart${timePeriodId_index}" style="width:360px;"></canvas>
            <script>
                var expenseChartAll = new Chart(document.getElementById("ExpenseChart${timePeriodId_index}"), { type: 'pie',
                    data: { labels:[<#list topExpenseList! as topExpense>'${topExpense.className}'<#sep>,</#list>],
                        datasets:[{ data:[<#list topExpenseList! as topExpense>${topExpense.amount?c}<#sep>,</#list>],
                            backgroundColor:[<#list backgroundColors as color>'${color}'<#sep>,</#list>] }]
                    }
                });
            </script>
        </li>
    </#if></#list>
    </ul>
</#if>
