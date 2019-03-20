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
<#macro statsPanel title mainFormat valThis valLast valPrior valAvg chartList="" chartMaList="" labelList="">
    <#assign modalId = title?replace(" ", "_")?replace("-", "_") + "_Modal">
    <#assign modalTitle = title + " Detail">
    <div class="panel panel-default"><div class="panel-body" onclick="$('#${modalId}').modal('show');">
        <h5 class="text-center" style="margin-top:0;">${title}</h5>
        <@statsPanelContent title mainFormat valThis valLast valPrior valAvg false chartList chartMaList labelList/>
    </div></div>
    <div class="modal fade" id="${modalId}" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document"><div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">${title}</h4>
            </div>
            <div class="modal-body">
                <@statsPanelContent modalTitle mainFormat valThis valLast valPrior valAvg true chartList chartMaList labelList/>
            </div>
        </div></div>
    </div>
</#macro>
<#macro statsPanelContent title mainFormat valThis valLast valPrior valAvg chartBig chartList="" chartMaList="" labelList="">
    <#assign chartId = title?replace(" ", "_")?replace("-", "_") + "_Chart">
    <div class="row"><div class="col-xs-5 text-right">
        <div class="small text-muted">this</div>
        <h4 class="text-primary" style="margin-top:0;">${ec.l10n.format(valThis, mainFormat)}</h4>
    </div><div class="col-xs-7">
        <div>
            <i class="glyphicon <#if (valThis < valLast)>glyphicon-triangle-bottom text-danger<#else>glyphicon-triangle-top text-success</#if>"></i>
            <span class="<#if (valThis < valLast)>text-danger<#else>text-success</#if>"><#if valLast != 0>${ec.l10n.format(((valThis - valLast)?abs/valLast)*100, '00')}<#else>0</#if>%</span>
            <span class="small">last (${ec.l10n.format(valLast, mainFormat)})</span>
        </div>
        <div>
            <i class="glyphicon <#if (valThis < valAvg)>glyphicon-triangle-bottom text-danger<#else>glyphicon-triangle-top text-success</#if>"></i>
            <span class="<#if (valThis < valAvg)>text-danger<#else>text-success</#if>"><#if valAvg != 0>${ec.l10n.format(((valThis - valAvg)?abs/valAvg)*100, '00')}<#else>0</#if>%</span>
            <span class="small">avg (${ec.l10n.format(valAvg, mainFormat)})</span>
        </div>
    </div></div>
    <div class="row"><div class="col-xs-5 text-right">
        <div class="small text-muted">last</div>
        <h4 class="text-primary" style="margin-top:0;">${ec.l10n.format(valLast, mainFormat)}</h4>
    </div><div class="col-xs-7">
        <div>
            <i class="glyphicon <#if (valLast < valPrior)>glyphicon-triangle-bottom text-danger<#else>glyphicon-triangle-top text-success</#if>"></i>
            <span class="<#if (valLast < valPrior)>text-danger<#else>text-success</#if>"><#if valPrior != 0>${ec.l10n.format(((valLast - valPrior)?abs/valPrior)*100, '00')}<#else>0</#if>%</span>
            <span class="small">prev (${ec.l10n.format(valPrior, mainFormat)})</span>
        </div>
        <div>
            <i class="glyphicon <#if (valLast < valAvg)>glyphicon-triangle-bottom text-danger<#else>glyphicon-triangle-top text-success</#if>"></i>
            <span class="<#if (valLast < valAvg)>text-danger<#else>text-success</#if>"><#if valAvg != 0>${ec.l10n.format(((valLast - valAvg)?abs/valAvg)*100, '00')}<#else>0</#if>%</span>
            <span class="small">avg (${ec.l10n.format(valAvg, mainFormat)})</span>
        </div>
    </div></div>
    <#if chartList?has_content>
        <div class="chart-container" style="position:relative; height:<#if chartBig>500px<#else>90px</#if>; width:100%;"><canvas id="${chartId}"></canvas></div>
        <script>
            var ${chartId} = new Chart(document.getElementById("${chartId}"), { type: 'line',
                data: { labels:${Static["groovy.json.JsonOutput"].toJson(labelList)}, datasets:[
                    { backgroundColor: "rgba(49, 112, 143, 0.9)", borderColor: "rgba(49, 112, 143, 0.9)", fill: false, data: ${Static["groovy.json.JsonOutput"].toJson(chartList)} }
                    <#if (maPeriods > 0) && chartMaList?has_content>, { backgroundColor: null, borderColor: "rgba(240, 173, 78, 0.5)", fill: false, data: ${Static["groovy.json.JsonOutput"].toJson(chartMaList)} }</#if>
                ] },
                options: { legend:{display:false}, scales:{ xAxes:[{display:<#if chartBig>true<#else>false</#if>}] }, maintainAspectRatio:false }
            });
        </script>
    </#if>
</#macro>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js" type="text/javascript"></script>

<div class="row">
    <div class="${statsPanelColStyle}">
    <@statsPanel "Order Count", '#,##0', (ordersThis.orderCount)!0.0, (ordersLast.orderCount)!0.0, (ordersPrior.orderCount)!0.0,
        (ordersAverage.orderCount)!0.0, ec.resource.expression("orderSummaryNoTotals*.orderCount", ""),
        ec.resource.expression("orderSummaryNoTotals*.orderCountMa", ""), orderLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "New Customer Count", '#,##0', (ordersThis.newCustomerOrderCount)!0.0, (ordersLast.newCustomerOrderCount)!0.0, (ordersPrior.newCustomerOrderCount)!0.0,
        (ordersAverage.newCustomerOrderCount)!0.0, ec.resource.expression("orderSummaryNoTotals*.newCustomerOrderCount", ""),
        ec.resource.expression("orderSummaryNoTotals*.newCustomerOrderCountMa", ""), orderLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "New Customer Percent", '0.0%', ((ordersThis.newCustomerPercent)!0.0), ((ordersLast.newCustomerPercent)!0.0),
        ((ordersPrior.newCustomerPercent)!0.0), ((ordersAverage.newCustomerPercent)!0.0), newCustomerPercentList, newCustomerPercentMaList, orderLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Order Quantity", '#,##0', (ordersThis.productQuantityTotal)!0.0, (ordersLast.productQuantityTotal)!0.0,
        (ordersPrior.productQuantityTotal)!0.0, (ordersAverage.productQuantityTotal)!0.0, ec.resource.expression("orderSummaryNoTotals*.productQuantityTotal", ""),
        ec.resource.expression("orderSummaryNoTotals*.productQuantityTotalMa", ""), orderLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Order Product Sales", '$#,##0', (ordersThis.productSaleTotal)!0.0, (ordersLast.productSaleTotal)!0.0,
        (ordersPrior.productSaleTotal)!0.0, (ordersAverage.productSaleTotal)!0.0, orderProductSaleTotalList,
        ec.resource.expression("orderSummaryNoTotals*.productSaleTotalMa", ""), orderLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Order Discount Percent", '0.0%', ((ordersThis.discountPercent)!0.0), ((ordersLast.discountPercent)!0.0),
        ((ordersPrior.discountPercent)!0.0), ((ordersAverage.discountPercent)!0.0), orderDiscountPercentList, orderDiscountPercentMaList, orderLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Order Net Product", '$#,##0', (ordersThis.netSales)!0.0, (ordersLast.netSales)!0.0,
        (ordersPrior.netSales)!0.0, (ordersAverage.netSales)!0.0, orderNetSalesList, ec.resource.expression("orderSummaryNoTotals*.netSalesMa", ""), orderLabelList/>

    </div>
</div>

<div class="row">
    <div class="${statsPanelColStyle}">
    <@statsPanel "Invoice Count", '#,##0', (invoicesThis.invoiceCount)!0.0, (invoicesLast.invoiceCount)!0.0,
        (invoicesPrior.invoiceCount)!0.0, (invoicesAverage.invoiceCount)!0.0, ec.resource.expression("invoiceSummaryNoTotals*.invoiceCount", ""),
        ec.resource.expression("invoiceSummaryNoTotals*.invoiceCountMa", ""), invoiceLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Invoiced Quantity", '#,##0', (invoicesThis.productQuantityTotal)!0.0, (invoicesLast.productQuantityTotal)!0.0,
        (invoicesPrior.productQuantityTotal)!0.0, (invoicesAverage.productQuantityTotal)!0.0, ec.resource.expression("invoiceSummaryNoTotals*.productQuantityTotal", ""),
        ec.resource.expression("invoiceSummaryNoTotals*.productQuantityTotalMa", ""), invoiceLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Invoices Total", '$#,##0', (invoicesThis.invoiceTotal)!0.0, (invoicesLast.invoiceTotal)!0.0,
        (invoicesPrior.invoiceTotal)!0.0, (invoicesAverage.invoiceTotal)!0.0, invoiceTotalList, invoiceTotalMaList, invoiceLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Paid Percent", '0.0%', ((invoicesThis.paidPercent)!0.0), ((invoicesLast.paidPercent)!0.0),
        ((invoicesPrior.paidPercent)!0.0), ((invoicesAverage.paidPercent)!0.0), invoicePaidPercentList, invoicePaidPercentMaList, invoiceLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Pre-Paid Percent", '0.0%', ((invoicesThis.prePaidPercent)!0.0), ((invoicesLast.prePaidPercent)!0.0),
        ((invoicesPrior.prePaidPercent)!0.0), ((invoicesAverage.prePaidPercent)!0.0), invoicePrePaidPercentList, invoicePrePaidPercentMaList, invoiceLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Invoice Cost Percent", '0.0%', ((invoicesThis.costPercent)!0.0), ((invoicesLast.costPercent)!0.0),
        ((invoicesPrior.costPercent)!0.0), ((invoicesAverage.costPercent)!0.0), invoiceCostPercentList, invoiceCostPercentMaList, invoiceLabelList/>
    </div><div class="${statsPanelColStyle}">
    <@statsPanel "Invoice Discount Percent", '0.0%', ((invoicesThis.discountPercent)!0.0), ((invoicesLast.discountPercent)!0.0),
        ((invoicesPrior.discountPercent)!0.0), ((invoicesAverage.discountPercent)!0.0), invoiceDiscountPercentList, invoiceDiscountPercentMaList, invoiceLabelList/>
    </div>
</div>
