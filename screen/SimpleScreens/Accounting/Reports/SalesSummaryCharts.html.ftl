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
<#assign countSummaryConfig><@compress single_line=true>
{ type:'line', data:{labels:${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafeCollection(orderLabelList)},
datasets:${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafeCollection(countSummaryDatasets)} },
options:{ scales:{ yAxes:[{ position:'left', id:'leftSide', ticks:{beginAtZero:true} },
    { position:'right', id:'rightSide', ticks:{beginAtZero:true}, gridLines:{drawOnChartArea:false} }] }, maintainAspectRatio:false } }
</@compress></#assign>
<#assign orderAmountConfig><@compress single_line=true>
{ type:'line', data:{labels:${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafeCollection(orderLabelList)},
datasets:${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafeCollection(orderAmountsDatasets)} },
options:{ scales:{ yAxes:[{ position:'left', id:'leftSide', ticks:{beginAtZero:true} },
    { position:'right', id:'rightSide', ticks:{beginAtZero:true}, gridLines:{drawOnChartArea:false} }] }, maintainAspectRatio:false } }
</@compress></#assign>
<#assign invoiceMarginConfig><@compress single_line=true>
{ type:'bar', data:{labels:${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafeCollection(invoiceLabelList)},
datasets:${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafeCollection(invoiceMarginDatasets)} },
options:{ scales:{ yAxes:[{ ticks:{beginAtZero:true} }] }, maintainAspectRatio:false } }
</@compress></#assign>
<#assign discountCostConfig><@compress single_line=true>
{ type:'line', data:{labels:${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafeCollection(invoiceLabelList)},
datasets:${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafeCollection(discountCostDatasets)} },
options:{ scales:{ yAxes:[{ ticks:{beginAtZero:true} }] }, maintainAspectRatio:false } }
</@compress></#assign>
<#if sri.getRenderMode() == "vuet" || sri.getRenderMode() == "html">
<div class="row"><div class="${statsChartColStyle}">
    <div class="chart-container" style="position:relative; height:300px; width:100%;"><canvas id="CountSummaryChart"></canvas></div>
</div><div class="${statsChartColStyle}">
    <div class="chart-container" style="position:relative; height:300px; width:100%;"><canvas id="OrderAmountChart"></canvas></div>
</div><div class="${statsChartColStyle}">
    <div class="chart-container" style="position:relative; height:300px; width:100%;"><canvas id="InvoiceMarginChart"></canvas></div>
</div><div class="${statsChartColStyle}">
    <div class="chart-container" style="position:relative; height:300px; width:100%;"><canvas id="DiscountCostChart"></canvas></div>
</div></div>
<script>
    var CountSummaryChart = new Chart(document.getElementById("CountSummaryChart"), ${countSummaryConfig});
    var OrderAmountChart = new Chart(document.getElementById("OrderAmountChart"), ${orderAmountConfig});
    var InvoiceMarginChart = new Chart(document.getElementById("InvoiceMarginChart"), ${invoiceMarginConfig});
    var DiscountCostChart = new Chart(document.getElementById("DiscountCostChart"), ${discountCostConfig});
</script>
<#elseif sri.getRenderMode() == "qvt">
<div class="row"><div class="${statsChartColStyle}">
    <m-chart height="300px" :config="${countSummaryConfig}"></m-chart>
</div><div class="${statsChartColStyle}">
    <m-chart height="300px" :config="${orderAmountConfig}"></m-chart>
</div><div class="${statsChartColStyle}">
    <m-chart height="300px" :config="${invoiceMarginConfig}"></m-chart>
</div><div class="${statsChartColStyle}">
    <m-chart height="300px" :config="${discountCostConfig}"></m-chart>
</div></div>
</#if>
