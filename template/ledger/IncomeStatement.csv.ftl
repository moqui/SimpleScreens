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
<#assign currencyFormat = currencyFormat!"#,##0.00">
<#assign percentFormat = percentFormat!"0.0%">
<#assign indentChar = indentChar!' '>
<#macro csvValue textValue>
    <#if textValue?contains(",") || textValue?contains("\"")><#assign useQuotes = true><#else><#assign useQuotes = false></#if>
    <#t><#if useQuotes>"</#if>${textValue?replace("\"", "\"\"")}<#if useQuotes>"</#if>
</#macro>
<#macro showClass classInfo depth showLess=false>
    <#-- skip classes with nothing posted -->
    <#if (classInfo.totalPostedNoClosingByTimePeriod['ALL']!0) == 0><#return></#if>
    <#if showLess><#assign negMult = -1><#else><#assign negMult = 1></#if>
    <#assign classDesc><#list 1..depth as idx>${indentChar}</#list> ${ec.l10n.localize(classInfo.className)}<#if showLess && depth == 1> (${ec.l10n.localize("less")})</#if></#assign>
    <#t><@csvValue classDesc/>,
    <#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format((classInfo.postedNoClosingByTimePeriod['ALL']!0)*negMult, currencyFormat)/>,</#if>
    <#list timePeriodIdList as timePeriodId>
        <#assign classPerAmount = (classInfo.postedNoClosingByTimePeriod[timePeriodId]!0)*negMult>
        <#t><#if classPerAmount != 0><@csvValue ec.l10n.format(classPerAmount, currencyFormat)/></#if><#if showPercents || showDiff || timePeriodId_has_next>,</#if>
        <#t><#if showPercents>
            <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
            <#t><#if classPerAmount != 0 && netRevenueAmt != 0>${ec.l10n.format(classPerAmount/netRevenueAmt, percentFormat)}</#if><#if showDiff || timePeriodId_has_next>,</#if>
        </#if>
    </#list>
    <#t><#if showDiff><@csvValue ec.l10n.format(((classInfo.postedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfo.postedNoClosingByTimePeriod[timePeriodIdList[0]]!0))*negMult, currencyFormat)/></#if>
    <#t>${"\n"}
    <#list classInfo.glAccountInfoList! as glAccountInfo><#assign glAccountAllAmt = (glAccountInfo.postedNoClosingByTimePeriod['ALL']!0)*negMult><#if showDetail && glAccountAllAmt != 0>
        <#assign accountDesc>${indentChar}${indentChar}<#list 1..depth as idx>${indentChar}</#list> <#if accountCodeFormatter??>${accountCodeFormatter.valueToString(glAccountInfo.accountCode)}<#else>${glAccountInfo.accountCode}</#if>: ${glAccountInfo.accountName}</#assign>
        <#t><@csvValue accountDesc/>,
        <#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(glAccountAllAmt, currencyFormat)/>,</#if>
        <#list timePeriodIdList as timePeriodId>
            <#t><@csvValue ec.l10n.format((glAccountInfo.postedNoClosingByTimePeriod[timePeriodId]!0)*negMult, currencyFormat)/><#if showPercents || showDiff || timePeriodId_has_next>,</#if>
            <#t><#if showPercents>
                <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
                <#assign currentAmt = (glAccountInfo.postedNoClosingByTimePeriod[timePeriodId]!0)*negMult>
                <#t><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if><#if showDiff || timePeriodId_has_next>,</#if>
            </#if>
        </#list>
        <#t><#if showDiff><@csvValue ec.l10n.format(((glAccountInfo.postedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (glAccountInfo.postedNoClosingByTimePeriod[timePeriodIdList[0]]!0))*negMult, currencyFormat)/></#if>
        <#t>${"\n"}
    </#if></#list>
    <#list classInfo.childClassInfoList as childClassInfo><@showClass childClassInfo depth+1 showLess/></#list>
    <#if classInfo.childClassInfoList?has_content>
        <#assign classDesc><#list 1..depth as idx>${indentChar}</#list> <@csvValue ec.l10n.localize("Total " + classInfo.className)/><#if showLess && depth == 1> (${ec.l10n.localize("less")})</#if></#assign>
        <#t><@csvValue classDesc/>,
        <#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format((classInfo.totalPostedNoClosingByTimePeriod['ALL']!0)*negMult, currencyFormat)/>,</#if>
        <#list timePeriodIdList as timePeriodId>
            <#t><@csvValue ec.l10n.format((classInfo.totalPostedNoClosingByTimePeriod[timePeriodId]!0)*negMult, currencyFormat)/><#if showPercents || showDiff || timePeriodId_has_next>,</#if>
            <#t><#if showPercents>
                <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
                <#assign currentAmt = (classInfo.totalPostedNoClosingByTimePeriod[timePeriodId]!0)*negMult>
                <#t><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if><#if showDiff || timePeriodId_has_next>,</#if>
            </#if>
        </#list>
        <#t><#if showDiff><@csvValue ec.l10n.format(((classInfo.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfo.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0))*negMult, currencyFormat)/></#if>
        <#t>${"\n"}
    </#if>
</#macro>
<#t><@csvValue organizationName!""/> - ${ec.l10n.localize("Income Statement")} (${ec.l10n.format(ec.user.nowTimestamp, 'dd MMM yyyy HH:mm')}),
<#t><#if (timePeriodIdList?size > 1)>${ec.l10n.localize("All Periods")},</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue timePeriodIdMap[timePeriodId].periodName/><#if showPercents || showDiff || timePeriodId_has_next>,</#if>
    <#t><#if showPercents>${ec.l10n.localize("% of Revenue")}<#if showDiff || timePeriodId_has_next>,</#if></#if>
</#list>
<#t><#if showDiff>${ec.l10n.localize("Difference")}</#if>
<#t>${"\n"}
<#t><@showClass classInfoById.REVENUE 1/>
<#--
<#t>${ec.l10n.localize("Net Revenue")} (${ec.l10n.localize("Revenue")} - ${ec.l10n.localize("Contra Revenue")}),
<#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format((classInfoById.REVENUE.totalPostedNoClosingByTimePeriod['ALL']!0) + (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod['ALL']!0), currencyFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue ec.l10n.format((classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0) + (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0), currencyFormat)/><#if showPercents || showDiff || timePeriodId_has_next>,</#if>
    <#t><#if showPercents>
        <#t>${ec.l10n.format(1, percentFormat)}<#if showDiff || timePeriodId_has_next>,</#if>
    </#if>
</#list>
<#t><#if showDiff><@csvValue ec.l10n.format((classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) + (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[1]]!0) - (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0) - (classInfoById.CONTRA_REVENUE.totalPostedNoClosingByTimePeriod[timePeriodIdList[0]]!0), currencyFormat)/></#if>
-->
<#t>${"\n"}
<@showClass classInfoById.COST_OF_SALES 1 true/>
<#t>${ec.l10n.localize("Gross Profit On Sales")} (${ec.l10n.localize("Net Revenue")} - ${ec.l10n.localize("Cost of Sales")}),
<#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(grossProfitOnSalesMap['ALL']!0, currencyFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue ec.l10n.format(grossProfitOnSalesMap[timePeriodId]!0, currencyFormat)/><#if showPercents || showDiff || timePeriodId_has_next>,</#if>
    <#t><#if showPercents>
        <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
        <#assign currentAmt = grossProfitOnSalesMap[timePeriodId]!0>
        <#t><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if><#if showDiff || timePeriodId_has_next>,</#if>
    </#if>
</#list>
<#t><#if showDiff><@csvValue ec.l10n.format((grossProfitOnSalesMap[timePeriodIdList[1]]!0) - (grossProfitOnSalesMap[timePeriodIdList[0]]!0), currencyFormat)/></#if>
<#t>${"\n"}
<#t><@showClass classInfoById.EXPENSE 1 true/>
<#t>${ec.l10n.localize("Net Operating Income")},
<#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(netOperatingIncomeMap['ALL']!0, currencyFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue ec.l10n.format(netOperatingIncomeMap[timePeriodId]!0, currencyFormat)/><#if showPercents || showDiff || timePeriodId_has_next>,</#if>
    <#t><#if showPercents>
        <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
        <#assign currentAmt = netOperatingIncomeMap[timePeriodId]!0>
        <#t><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if><#if showDiff || timePeriodId_has_next>,</#if>
    </#if>
</#list>
<#t><#if showDiff><@csvValue ec.l10n.format((netOperatingIncomeMap[timePeriodIdList[1]]!0) - (netOperatingIncomeMap[timePeriodIdList[0]]!0), currencyFormat)/></#if>
<#t>${"\n"}
<#t><@showClass classInfoById.INCOME 1/>
<#t><@showClass classInfoById.NON_OP_EXPENSE 1 true/>
<#t>${ec.l10n.localize("Net Non-operating Income")},
<#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(netNonOperatingIncomeMap['ALL']!0, currencyFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue ec.l10n.format(netNonOperatingIncomeMap[timePeriodId]!0, currencyFormat)/><#if showPercents || showDiff || timePeriodId_has_next>,</#if>
    <#t><#if showPercents>
        <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
        <#assign currentAmt = netNonOperatingIncomeMap[timePeriodId]!0>
        <#t><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if><#if showDiff || timePeriodId_has_next>,</#if>
    </#if>
</#list>
<#t><#if showDiff><@csvValue ec.l10n.format((netNonOperatingIncomeMap[timePeriodIdList[1]]!0) - (netNonOperatingIncomeMap[timePeriodIdList[0]]!0), currencyFormat)/></#if>
<#t>${"\n"}
<#t>${ec.l10n.localize("Net Income")},
<#t><#if (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(netIncomeMap['ALL']!0, currencyFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><@csvValue ec.l10n.format(netIncomeMap[timePeriodId]!0, currencyFormat)/><#if showPercents || showDiff || timePeriodId_has_next>,</#if>
    <#t><#if showPercents>
        <#assign netRevenueAmt = (classInfoById.REVENUE.totalPostedNoClosingByTimePeriod[timePeriodId]!0)>
        <#assign currentAmt = netIncomeMap[timePeriodId]!0>
        <#t><#if netRevenueAmt != 0>${ec.l10n.format(currentAmt/netRevenueAmt, percentFormat)}</#if><#if showDiff || timePeriodId_has_next>,</#if>
    </#if>
</#list>
<#t><#if showDiff><@csvValue ec.l10n.format((netIncomeMap[timePeriodIdList[1]]!0) - (netIncomeMap[timePeriodIdList[0]]!0), currencyFormat)/></#if>
<#t>${"\n"}
