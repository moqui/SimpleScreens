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

<#-- See the mantle.ledger.LedgerReportServices.run#RetainedEarningsStatement service for data preparation -->

<#assign showDetail = (detail! == "true")>
<#assign currencyFormat = currencyFormat!"#,##0.00">
<#assign retainedEarningsInfo = classInfoById.RETAINED_EARNINGS!>

<#macro showClassTotals classInfo>
    <tr class="text-info">
        <td style="padding-left: 0.3em;"><strong>${ec.l10n.localize(classInfo.className)}</strong></td>
        <#if (timePeriodIdList?size > 1)>
            <#assign beginningClassBalance = (classInfo.totalBalanceByTimePeriod['ALL']!0) - (classInfo.totalPostedByTimePeriod['ALL']!0)>
            <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalPostedByTimePeriod['ALL']!0, currencyFormat)}</strong></td>
            <td class="text-right text-mono"><strong>${ec.l10n.format(beginningClassBalance, currencyFormat)}</strong></td>
            <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalBalanceByTimePeriod['ALL']!0, currencyFormat)}</strong></td>
        </#if>
        <#list timePeriodIdList as timePeriodId>
            <#assign beginningClassBalance = (classInfo.totalBalanceByTimePeriod[timePeriodId]!0) - (classInfo.totalPostedByTimePeriod[timePeriodId]!0)>
            <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalPostedByTimePeriod[timePeriodId]!0, currencyFormat)}</strong></td>
            <td class="text-right text-mono"><strong>${ec.l10n.format(beginningClassBalance, currencyFormat)}</strong></td>
            <td class="text-right text-mono"><strong>${ec.l10n.format(classInfo.totalBalanceByTimePeriod[timePeriodId]!0, currencyFormat)}</strong></td>
        </#list>
    </tr>
</#macro>

<table class="table table-striped table-hover table-condensed">
    <thead>
        <tr>
            <th>${ec.l10n.localize("Retained Earnings Statement")}</th>
            <#if (timePeriodIdList?size > 1)>
                <th class="text-right">All Periods Posted</th>
                <th class="text-right">Beginning</th>
                <th class="text-right">Ending</th>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <th class="text-right">${timePeriodIdMap[timePeriodId].periodName} Posted</th>
                <th class="text-right">Beginning</th>
                <th class="text-right">Ending</th>
            </#list>
        </tr>
    </thead>
    <tbody>
        <#if retainedEarningsInfo??><@showClassTotals retainedEarningsInfo/></#if>

        <tr class="text-info">
            <td><strong>${ec.l10n.localize("Net Income")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netIncomeMap['ALL']!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right text-mono"><strong>${ec.l10n.format(netIncomeMap[timePeriodId]!0, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong> </strong></td><td class="text-right text-mono"><strong> </strong></td>
            </#list>
        </tr>

        <#if classInfoById.DISTRIBUTION??><@showClassTotals classInfoById.DISTRIBUTION/></#if>

        <tr class="text-success">
            <td><strong>${ec.l10n.localize("Net Earnings")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <td class="text-right text-mono"><strong>${ec.l10n.format((netIncomeMap['ALL']!0) + (classInfoById.DISTRIBUTION.totalPostedByTimePeriod['ALL']!0), currencyFormat)}</strong></td>
                <td class="text-right text-mono"> </td><td class="text-right text-mono"> </td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <td class="text-right text-mono"><strong>${ec.l10n.format((netIncomeMap[timePeriodId]!0) + (classInfoById.DISTRIBUTION.totalPostedByTimePeriod[timePeriodId]!0), currencyFormat)}</strong></td>
                <td class="text-right text-mono"> </td><td class="text-right text-mono"> </td>
            </#list>
        </tr>
        <tr class="text-success">
            <td><strong>${ec.l10n.localize("Calculated Retained Earnings")}</strong></td>
            <#if (timePeriodIdList?size > 1)>
                <#assign beginningClassBalance = (retainedEarningsInfo.totalBalanceByTimePeriod['ALL']!0) - (retainedEarningsInfo.totalPostedByTimePeriod['ALL']!0)>
                <td class="text-right text-mono"><strong> </strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(beginningClassBalance, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(beginningClassBalance + (netIncomeMap['ALL']!0) + (classInfoById.DISTRIBUTION.totalPostedByTimePeriod['ALL']!0), currencyFormat)}</strong></td>
            </#if>
            <#list timePeriodIdList as timePeriodId>
                <#assign beginningClassBalance = (retainedEarningsInfo.totalBalanceByTimePeriod[timePeriodId]!0) - (retainedEarningsInfo.totalPostedByTimePeriod[timePeriodId]!0)>
                <td class="text-right text-mono"><strong> </strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(beginningClassBalance, currencyFormat)}</strong></td>
                <td class="text-right text-mono"><strong>${ec.l10n.format(beginningClassBalance + (netIncomeMap[timePeriodId]!0) + (classInfoById.DISTRIBUTION.totalPostedByTimePeriod[timePeriodId]!0), currencyFormat)}</strong></td>
            </#list>
        </tr>
    </tbody>
</table>
