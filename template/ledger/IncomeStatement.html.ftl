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
<#assign showCharts = (charts! == "true")>
<#assign backgroundColors = ['rgba(92, 184, 92, 0.5)','rgba(91, 192, 222, 0.5)','rgba(240, 173, 78, 0.5)','rgba(217, 83, 79, 0.5)',
'rgba(60, 118, 61, 0.5)','rgba(49, 112, 143, 0.5)','rgba(138, 109, 59, 0.5)','rgba(169, 68, 66, 0.5)',
'rgba(223, 240, 216, 0.6)','rgba(217, 237, 247, 0.6)','rgba(252, 248, 227, 0.6)','rgba(242, 222, 222, 0.6)']>

<#macro showClass classInfo depth>
    <#-- skip classes with nothing posted -->
    <#if (classInfo.totalPostedNoClosingByTimePeriod['ALL']!0) == 0><#return></#if>

    <tr>
        <td style="padding-left: ${(depth-1) * 2}.3em;">${ec.l10n.localize(classInfo.className)}</td>
        <#if (timePeriodIdList?size > 1)>
            <td class="text-right">${ec.l10n.formatCurrency(classInfo.postedNoClosingByTimePeriod['ALL']!0, currencyUomId)}</td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <td class="text-right">${ec.l10n.formatCurrency(classInfo.postedNoClosingByTimePeriod[timePeriodId]!0, currencyUomId)}</td>
        </#list>
        <#if showDiff>
            <td class="text-right">${ec.l10n.formatCurrency((classInfo.postedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfo.postedNoClosingByTimePeriod[timePeriodIdList[0]]!0), currencyUomId)}</td>
        </#if>
    </tr>
    <#list classInfo.glAccountInfoList! as glAccountInfo>
        <#if showDetail>
            <tr>
                <td style="padding-left: ${(depth-1) * 2 + 3}.3em;"><#if accountCodeFormatter??>${accountCodeFormatter.valueToString(glAccountInfo.accountCode)}<#else>${glAccountInfo.accountCode}</#if>: ${glAccountInfo.accountName}</td>
                <#if (timePeriodIdList?size > 1)>
                    <td class="text-right">${ec.l10n.formatCurrency(glAccountInfo.postedNoClosingByTimePeriod['ALL']!0, currencyUomId)}</td>
                </#if>
                <#list timePeriodIdList as timePeriodId>
                    <td class="text-right">
                        <#if findEntryUrl??>
                            <#assign findEntryInstance = findEntryUrl.getInstance(sri, true).addParameter("glAccountId", glAccountInfo.glAccountId).addParameter("isPosted", "Y").addParameter("timePeriodId", timePeriodId)>
                            <a href="${findEntryInstance.getUrlWithParams()}">${ec.l10n.formatCurrency(glAccountInfo.postedNoClosingByTimePeriod[timePeriodId]!0, currencyUomId)}</a>
                        <#else>
                            ${ec.l10n.formatCurrency(glAccountInfo.postedNoClosingByTimePeriod[timePeriodId]!0, currencyUomId)}
                        </#if>
                    </td>
                </#list>
                <#if showDiff>
                    <td class="text-right">${ec.l10n.formatCurrency((glAccountInfo.postedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (glAccountInfo.postedNoClosingByTimePeriod[timePeriodIdList[0]]!0), currencyUomId)}</td>
                </#if>
            </tr>
        <#else>
            <!-- ${glAccountInfo.accountCode}: ${glAccountInfo.accountName} ${glAccountInfo.postedNoClosingByTimePeriod} -->
        </#if>
    </#list>
    <#list classInfo.childClassInfoList as childClassInfo>
        <@showClass childClassInfo depth + 1/>
    </#list>
    <#if classInfo.childClassInfoList?has_content>
        <tr<#if depth == 1> class="text-info"</#if>>
            <td style="padding-left: ${(depth-1) * 2}.3em;"><strong>${ec.l10n.localize(classInfo.className + " Total")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(classInfo.totalPostedNoClosingByTimePeriod['ALL']!0, currencyUomId)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(classInfo.totalPostedNoClosingByTimePeriod[timePeriodId]!0, currencyUomId)}</strong></td>
            </#list>
            <#if showDiff>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((classInfo.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfo.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0), currencyUomId)}</strong></td>
            </#if>
        </tr>
    </#if>
</#macro>

<table class="table table-striped table-hover table-condensed">
    <thead>
        <tr>
            <th>${ec.l10n.localize("Income Statement")}</th>
            <#if (timePeriodIdList?size > 1)>
                <th class="text-right">${ec.l10n.localize("All Periods")}</th>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <th class="text-right">${timePeriodIdMap[timePeriodId].periodName} (Closed: ${timePeriodIdMap[timePeriodId].isClosed})</th>
            </#list>
            <#if showDiff>
                <th class="text-right">${ec.l10n.localize("Difference")}</th>
            </#if>
        </tr>
    </thead>
    <tbody>

        <@showClass classInfoById.REVENUE 1/>
        <@showClass classInfoById.CONTRA_REVENUE 1/>
        <tr class="text-info">
            <td><strong>${ec.l10n.localize("Net Revenue")}</strong> (${ec.l10n.localize("Revenue")} + ${ec.l10n.localize("Contra Revenue")})</td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((classInfoById.REVENUE.totalPostedNoClosingByTimePeriod['ALL']!0) + (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod['ALL']!0), currencyUomId)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0) + (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0), currencyUomId)}</strong></td>
            </#list>
            <#if showDiff>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) + (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0) - (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0), currencyUomId)}</strong></td>
            </#if>
        </tr>

        <@showClass classInfoById.COST_OF_SALES 1/>
        <tr class="text-success" style="border-bottom: solid black;">
            <td><strong>${ec.l10n.localize("Gross Profit On Sales")}</strong> (${ec.l10n.localize("Net Revenue")} + ${ec.l10n.localize("Cost of Sales")})</td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(grossProfitOnSalesMap['ALL']!0, currencyUomId)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(grossProfitOnSalesMap[timePeriodId]!0, currencyUomId)}</strong></td>
            </#list>
            <#if showDiff>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((grossProfitOnSalesMap[timePeriodIdList[1]]!0) - (grossProfitOnSalesMap[timePeriodIdList[0]]!0), currencyUomId)}</strong></td>
            </#if>
        </tr>

        <@showClass classInfoById.INCOME 1/>
        <@showClass classInfoById.EXPENSE 1/>
        <tr class="text-success" style="border-bottom: solid black;">
            <td><strong>${ec.l10n.localize("Net Operating Income")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(netOperatingIncomeMap['ALL']!0, currencyUomId)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(netOperatingIncomeMap[timePeriodId]!0, currencyUomId)}</strong></td>
            </#list>
            <#if showDiff>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((netOperatingIncomeMap[timePeriodIdList[1]]!0) - (netOperatingIncomeMap[timePeriodIdList[0]]!0), currencyUomId)}</strong></td>
            </#if>
        </tr>

        <@showClass classInfoById.NON_OP_EXPENSE 1/>
        <tr class="text-success" style="border-bottom: solid black;">
            <td><strong>${ec.l10n.localize("Net Income")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(netIncomeMap['ALL']!0, currencyUomId)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right"><strong>${ec.l10n.formatCurrency(netIncomeMap[timePeriodId]!0, currencyUomId)}</strong></td>
            </#list>
            <#if showDiff>
                <td class="text-right"><strong>${ec.l10n.formatCurrency((netIncomeMap[timePeriodIdList[1]]!0) - (netIncomeMap[timePeriodIdList[0]]!0), currencyUomId)}</strong></td>
            </#if>
        </tr>
    </tbody>
</table>

<#if showCharts>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js" type="text/javascript"></script>
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
