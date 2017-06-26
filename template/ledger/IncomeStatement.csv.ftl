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
<#assign numberFormat = numberFormat!"#,##0.00">
<#assign indentChar = indentChar!' '>
<#macro csvValue textValue>
    <#if textValue?contains(",") || textValue?contains("\"")><#assign useQuotes = true><#else><#assign useQuotes = false></#if>
    <#t><#if useQuotes>"</#if>${textValue?replace("\"", "\"\"")}<#if useQuotes>"</#if>
</#macro>
<#macro showClass classInfo depth>
    <#-- skip classes with nothing posted -->
    <#if (classInfo.totalPostedNoClosingByTimePeriod['ALL']!0) == 0><#return></#if>
    <#t><#list 1..depth as idx>${indentChar}</#list> <@csvValue ec.l10n.localize(classInfo.className)/>,
    <#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(classInfo.postedNoClosingByTimePeriod['ALL']!0, numberFormat)/>,</#if>
    <#list timePeriodIdList as timePeriodId>
        <#t><@csvValue ec.l10n.format(classInfo.postedNoClosingByTimePeriod[timePeriodId]!0, numberFormat)/><#if showDiff || timePeriodId_has_next>,</#if>
    </#list>
    <#t><#if showDiff><@csvValue ec.l10n.format((classInfo.postedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfo.postedNoClosingByTimePeriod[timePeriodIdList[0]]!0), numberFormat)/></#if>
    <#t>${"\n"}
    <#list classInfo.glAccountInfoList! as glAccountInfo><#if showDetail>
        <#t>${indentChar}${indentChar}<#list 1..depth as idx>${indentChar}</#list> <#if accountCodeFormatter??>${accountCodeFormatter.valueToString(glAccountInfo.accountCode)}<#else>${glAccountInfo.accountCode}</#if>: <@csvValue glAccountInfo.accountName/>,
        <#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(glAccountInfo.postedNoClosingByTimePeriod['ALL']!0, numberFormat)/>,</#if>
        <#list timePeriodIdList as timePeriodId>
            <#t><@csvValue ec.l10n.format(glAccountInfo.postedNoClosingByTimePeriod[timePeriodId]!0, numberFormat)/><#if showDiff || timePeriodId_has_next>,</#if>
        </#list>
        <#t><#if showDiff><@csvValue ec.l10n.format((glAccountInfo.postedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (glAccountInfo.postedNoClosingByTimePeriod[timePeriodIdList[0]]!0), numberFormat)/></#if>
        <#t>${"\n"}
    </#if></#list>
    <#list classInfo.childClassInfoList as childClassInfo><@showClass childClassInfo depth + 1/></#list>
    <#if classInfo.childClassInfoList?has_content>
        <#t><#list 1..depth as idx>${indentChar}</#list> <@csvValue ec.l10n.localize(classInfo.className + " Total")/>,
        <#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(classInfo.totalPostedNoClosingByTimePeriod['ALL']!0, numberFormat)/>,</#if>
        <#list timePeriodIdList as timePeriodId>
            <#t><@csvValue ec.l10n.format(classInfo.totalPostedNoClosingByTimePeriod[timePeriodId]!0, numberFormat)/><#if showDiff || timePeriodId_has_next>,</#if>
        </#list>
        <#t><#if showDiff><@csvValue ec.l10n.format((classInfo.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfo.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0), numberFormat)/></#if>
        <#t>${"\n"}
    </#if>
</#macro>
<#t>${ec.l10n.localize("Income Statement")},
<#t><#if (timePeriodIdList?size > 1)>${ec.l10n.localize("All Periods")},</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue timePeriodIdMap[timePeriodId].periodName/> (Closed: ${timePeriodIdMap[timePeriodId].isClosed})<#if showDiff || timePeriodId_has_next>,</#if>
</#list>
<#t><#if showDiff>${ec.l10n.localize("Difference")}</#if>
<#t>${"\n"}
<#t><@showClass classInfoById.REVENUE 1/>
<#t><@showClass classInfoById.CONTRA_REVENUE 1/>
<#t>${ec.l10n.localize("Net Revenue")} (${ec.l10n.localize("Revenue")} + ${ec.l10n.localize("Contra Revenue")}),
<#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format((classInfoById.REVENUE.totalPostedNoClosingByTimePeriod['ALL']!0) + (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod['ALL']!0), numberFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue ec.l10n.format((classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0) + (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0), numberFormat)/><#if showDiff || timePeriodId_has_next>,</#if>
</#list>
<#t><#if showDiff><@csvValue ec.l10n.format((classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) + (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0) - (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0), numberFormat)/></#if>
<#t>${"\n"}
<@showClass classInfoById.COST_OF_SALES 1/>
<#t>${ec.l10n.localize("Gross Profit On Sales")} (${ec.l10n.localize("Net Revenue")} + ${ec.l10n.localize("Cost of Sales")}),
<#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(grossProfitOnSalesMap['ALL']!0, numberFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue ec.l10n.format(grossProfitOnSalesMap[timePeriodId]!0, numberFormat)/><#if showDiff || timePeriodId_has_next>,</#if>
</#list>
<#t><#if showDiff><@csvValue ec.l10n.format((grossProfitOnSalesMap[timePeriodIdList[1]]!0) - (grossProfitOnSalesMap[timePeriodIdList[0]]!0), numberFormat)/></#if>
<#t>${"\n"}
<#t><@showClass classInfoById.INCOME 1/>
<#t><@showClass classInfoById.EXPENSE 1/>
<#t>${ec.l10n.localize("Net Operating Income")},
<#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(netOperatingIncomeMap['ALL']!0, numberFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue ec.l10n.format(netOperatingIncomeMap[timePeriodId]!0, numberFormat)/><#if showDiff || timePeriodId_has_next>,</#if>
</#list>
<#t><#if showDiff><@csvValue ec.l10n.format((netOperatingIncomeMap[timePeriodIdList[1]]!0) - (netOperatingIncomeMap[timePeriodIdList[0]]!0), numberFormat)/></#if>
<#t>${"\n"}
<#t><@showClass classInfoById.NON_OP_EXPENSE 1/>
<#t>${ec.l10n.localize("Net Income")},
<#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(netIncomeMap['ALL']!0, numberFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue ec.l10n.format(netIncomeMap[timePeriodId]!0, numberFormat)/><#if showDiff || timePeriodId_has_next>,</#if>
</#list>
<#t><#if showDiff><@csvValue ec.l10n.format((netIncomeMap[timePeriodIdList[1]]!0) - (netIncomeMap[timePeriodIdList[0]]!0), numberFormat)/></#if>
<#t>${"\n"}
