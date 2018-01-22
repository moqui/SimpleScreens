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
<#assign indentChar = indentChar!' '>
<#macro csvValue textValue>
    <#if textValue?contains(",") || textValue?contains("\"")><#assign useQuotes = true><#else><#assign useQuotes = false></#if>
    <#t><#if useQuotes>"</#if>${textValue?replace("\"", "\"\"")}<#if useQuotes>"</#if>
</#macro>
<#macro showClass classInfo depth>
    <#-- skip classes with no balance -->
    <#t><#if (classInfo.totalBalanceByTimePeriod['ALL']!0) == 0 && (classInfo.totalPostedByTimePeriod['ALL']!0) == 0><#return></#if>
    <#assign hasChildren = classInfo.childClassInfoList?has_content>
    <#assign classDesc><#list 1..depth as idx>${indentChar}</#list> ${ec.l10n.localize(classInfo.className)}</#assign>
    <#t><@csvValue classDesc/>,
    <#t><#if showBeginningAndPosted && (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(classInfo.postedByTimePeriod['ALL']!0, currencyFormat)/>,</#if>
    <#t><#list timePeriodIdList as timePeriodId>
        <#t><#if showBeginningAndPosted>
            <#assign beginningClassBalance = (classInfo.balanceByTimePeriod[timePeriodId]!0) - (classInfo.postedByTimePeriod[timePeriodId]!0)>
            <#t><@csvValue ec.l10n.format(beginningClassBalance, currencyFormat)/>,
            <#t><@csvValue ec.l10n.format(classInfo.postedByTimePeriod[timePeriodId]!0, currencyFormat)/>,
        </#if><#t>
        <#assign classPerAmount = classInfo.balanceByTimePeriod[timePeriodId]!0>
        <#t><#if classPerAmount != 0><@csvValue ec.l10n.format(classPerAmount, currencyFormat)/></#if><#if showPercents || timePeriodId_has_next>,</#if>
        <#t><#if showPercents>
            <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
            <#t><#if classPerAmount != 0 && assetTotalAmt != 0>${ec.l10n.format(classPerAmount/assetTotalAmt, percentFormat)}</#if><#if timePeriodId_has_next>,</#if>
        </#if>
    </#list>
    <#t>${"\n"}
    <#list classInfo.glAccountInfoList! as glAccountInfo>
        <#t><#if showDetail && ((glAccountInfo.balanceByTimePeriod['ALL']!0) != 0 || (glAccountInfo.postedByTimePeriod['ALL']!0) != 0)>
            <#assign accountDesc>${indentChar}${indentChar}<#list 1..depth as idx>${indentChar}</#list> <#if accountCodeFormatter??>${accountCodeFormatter.valueToString(glAccountInfo.accountCode)}<#else>${glAccountInfo.accountCode}</#if>: ${glAccountInfo.accountName}</#assign>
            <#t><@csvValue accountDesc/>,
            <#t><#if showBeginningAndPosted && (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(glAccountInfo.postedByTimePeriod['ALL']!0, currencyFormat)/>,</#if>
            <#list timePeriodIdList as timePeriodId>
                <#t><#if showBeginningAndPosted>
                    <#assign beginningGlAccountBalance = (glAccountInfo.balanceByTimePeriod[timePeriodId]!0) - (glAccountInfo.postedByTimePeriod[timePeriodId]!0)>
                    <#t><@csvValue ec.l10n.format(beginningGlAccountBalance, currencyFormat)/>,
                    <#t><@csvValue ec.l10n.format(glAccountInfo.postedByTimePeriod[timePeriodId]!0, currencyFormat)/>,
                </#if><#t>
                <#t><@csvValue ec.l10n.format(glAccountInfo.balanceByTimePeriod[timePeriodId]!0, currencyFormat)/><#if showPercents || timePeriodId_has_next>,</#if>
                <#t><#if showPercents>
                    <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                    <#assign currentAmt = glAccountInfo.balanceByTimePeriod[timePeriodId]!0>
                    <#t><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if><#if timePeriodId_has_next>,</#if>
                </#if>
            </#list>
            <#t>${"\n"}
        </#if>
    </#list>
    <#t><#if hasChildren>
        <#list classInfo.childClassInfoList as childClassInfo><@showClass childClassInfo depth + 1/></#list>
        <#t><#list 1..depth as idx>${indentChar}</#list> <@csvValue ec.l10n.localize("Total " + classInfo.className)/>,
        <#t><#if showBeginningAndPosted && (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(classInfo.totalPostedByTimePeriod['ALL']!0, currencyFormat)/>,</#if>
        <#list timePeriodIdList as timePeriodId>
            <#t><#if showBeginningAndPosted>
                <#assign beginningTotalBalance = (classInfo.totalBalanceByTimePeriod[timePeriodId]!0) - (classInfo.totalPostedByTimePeriod[timePeriodId]!0)>
                <#t><@csvValue ec.l10n.format(beginningTotalBalance, currencyFormat)/>,
                <#t><@csvValue ec.l10n.format(classInfo.totalPostedByTimePeriod[timePeriodId]!0, currencyFormat)/>,
            </#if><#t>
            <#t><@csvValue ec.l10n.format(classInfo.totalBalanceByTimePeriod[timePeriodId]!0, currencyFormat)/><#if showPercents || timePeriodId_has_next>,</#if>
            <#t><#if showPercents>
                <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
                <#assign currentAmt = classInfo.totalBalanceByTimePeriod[timePeriodId]!0>
                <#t><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if><#if timePeriodId_has_next>,</#if>
            </#if>
        </#list>
        <#t>${"\n"}
    </#if>
</#macro>
<#t><@csvValue organizationName!""/> - ${ec.l10n.localize("Balance Sheet")} (${ec.l10n.format(ec.user.nowTimestamp, 'dd MMM yyyy HH:mm')}),
<#t><#if showBeginningAndPosted && (timePeriodIdList?size > 1)>${ec.l10n.localize("All Periods Posted")},</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><#if showBeginningAndPosted>
        <#t><@csvValue timePeriodIdMap[timePeriodId].periodName + ec.l10n.localize("Beginning")/>,
        <#t>${ec.l10n.localize("Posted")},${ec.l10n.localize("Ending")}<#if showPercents || timePeriodId_has_next>,</#if>
    <#t><#else>
        <#t><@csvValue timePeriodIdMap[timePeriodId].periodName/><#if showPercents || timePeriodId_has_next>,</#if>
    </#if><#t>
    <#t><#if showPercents>${ec.l10n.localize("% of Assets")}<#if timePeriodId_has_next>,</#if></#if>
</#list>
<#t>${"\n"}
<#t><#if classInfoById.ASSET??><@showClass classInfoById.ASSET 1/></#if>
<#t><#if classInfoById.LIABILITY??><@showClass classInfoById.LIABILITY 1/></#if>
<#t><#if classInfoById.EQUITY??><@showClass classInfoById.EQUITY 1/></#if>
<#t><#if classInfoById.DISTRIBUTION??><@showClass classInfoById.DISTRIBUTION 1/></#if>
<#t><#if equityTotalMap??>
    <#t>${ec.l10n.localize("Equity + Contra Equity + Distribution Total")},
    <#t><#if showBeginningAndPosted && (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(equityTotalMap.totalPosted['ALL']!0, currencyFormat)/>,</#if>
    <#list timePeriodIdList as timePeriodId>
        <#t><#if showBeginningAndPosted>
            <#t><@csvValue ec.l10n.format((equityTotalMap.totalBalance[timePeriodId]!0) - (equityTotalMap.totalPosted[timePeriodId]!0), currencyFormat)/>,
            <#t><@csvValue ec.l10n.format(equityTotalMap.totalPosted[timePeriodId]!0, currencyFormat)/>,
        </#if><#t>
        <#t><@csvValue ec.l10n.format(equityTotalMap.totalBalance[timePeriodId]!0, currencyFormat)/><#if showPercents || timePeriodId_has_next>,</#if>
        <#t><#if showPercents>
            <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
            <#assign currentAmt = equityTotalMap.totalBalance[timePeriodId]!0>
            <#t><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if><#if timePeriodId_has_next>,</#if>
        </#if>
    </#list>
    <#t>${"\n"}
</#if>
<#t><#if liabilityEquityTotalMap??>
    <#t>${ec.l10n.localize("Liability + Equity Grand Total")},
    <#t><#if showBeginningAndPosted && (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(liabilityEquityTotalMap.totalPosted['ALL']!0, currencyFormat)/>,</#if>
    <#list timePeriodIdList as timePeriodId>
        <#t><#if showBeginningAndPosted>
            <#t><@csvValue ec.l10n.format((liabilityEquityTotalMap.totalBalance[timePeriodId]!0) - (liabilityEquityTotalMap.totalPosted[timePeriodId]!0), currencyFormat)/>,
            <#t><@csvValue ec.l10n.format(liabilityEquityTotalMap.totalPosted[timePeriodId]!0, currencyFormat)/>,
        </#if><#t>
        <#t><@csvValue ec.l10n.format(liabilityEquityTotalMap.totalBalance[timePeriodId]!0, currencyFormat)/><#if showPercents || timePeriodId_has_next>,</#if>
        <#t><#if showPercents>
            <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
            <#assign currentAmt = liabilityEquityTotalMap.totalBalance[timePeriodId]!0>
            <#t><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if><#if timePeriodId_has_next>,</#if>
        </#if>
    </#list>
    <#t>${"\n"}
</#if>
<#t>${ec.l10n.localize("Unbooked Net Income")},
<#t><#if showBeginningAndPosted && (timePeriodIdList?size > 1)><@csvValue ec.l10n.format(netIncomeOut.totalPosted['ALL']!0, currencyFormat)/>,</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><#if showBeginningAndPosted>
        <#t><@csvValue ec.l10n.format((netIncomeOut.totalBalance[timePeriodId]!0) - (netIncomeOut.totalPosted[timePeriodId]!0), currencyFormat)/>,
        <#t><@csvValue ec.l10n.format(netIncomeOut.totalPosted[timePeriodId]!0, currencyFormat)/>,
    </#if><#t>
    <#t><@csvValue ec.l10n.format(netIncomeOut.totalBalance[timePeriodId]!0, currencyFormat)/><#if showPercents || timePeriodId_has_next>,</#if>
    <#t><#if showPercents>
        <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
        <#assign currentAmt = netIncomeOut.totalBalance[timePeriodId]!0>
        <#t><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if><#if timePeriodId_has_next>,</#if>
    </#if>
</#list>
<#t>${"\n"}
<#t>${ec.l10n.localize("Liability + Equity + Unbooked Net Income")},
<#t><#if showBeginningAndPosted && (timePeriodIdList?size > 1)>
    <#t><@csvValue ec.l10n.format((liabilityEquityTotalMap.totalPosted['ALL']!0) + (netIncomeOut.totalPosted['ALL']!0), currencyFormat)/>,
</#if>
<#list timePeriodIdList as timePeriodId>
    <#t><#if showBeginningAndPosted>
        <#t><@csvValue ec.l10n.format((liabilityEquityTotalMap.totalBalance[timePeriodId]!0) - (liabilityEquityTotalMap.totalPosted[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0) - (netIncomeOut.totalPosted[timePeriodId]!0), currencyFormat)/>,
        <#t><@csvValue ec.l10n.format((liabilityEquityTotalMap.totalPosted[timePeriodId]!0) + (netIncomeOut.totalPosted[timePeriodId]!0), currencyFormat)/>,
    </#if><#t>
    <#t><@csvValue ec.l10n.format((liabilityEquityTotalMap.totalBalance[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0), currencyFormat)/><#if showPercents || timePeriodId_has_next>,</#if>
    <#t><#if showPercents>
        <#assign assetTotalAmt = netAssetTotalMap.totalBalance[timePeriodId]!0>
        <#assign currentAmt = (liabilityEquityTotalMap.totalBalance[timePeriodId]!0) + (netIncomeOut.totalBalance[timePeriodId]!0)>
        <#t><#if assetTotalAmt != 0>${ec.l10n.format(currentAmt/assetTotalAmt, percentFormat)}</#if><#if timePeriodId_has_next>,</#if>
    </#if>
</#list>
<#t>${"\n"}
