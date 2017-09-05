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
    var CountSummaryChart = new Chart(document.getElementById("CountSummaryChart"), { type: 'line',
        data: { labels:${Static["groovy.json.JsonOutput"].toJson(orderLabelList)},
            datasets:${Static["groovy.json.JsonOutput"].toJson(countSummaryDatasets)} },
        options: { scales:{ yAxes: [{ position:'left', id:'leftSide', ticks:{beginAtZero:true} },
            { position:'right', id:'rightSide', ticks:{beginAtZero:true}, gridLines:{drawOnChartArea:false} }] }, maintainAspectRatio:false }
    });
    var OrderAmountChart = new Chart(document.getElementById("OrderAmountChart"), { type: 'line',
        data: { labels:${Static["groovy.json.JsonOutput"].toJson(orderLabelList)},
            datasets:${Static["groovy.json.JsonOutput"].toJson(orderAmountsDatasets)} },
        options: { scales:{ yAxes: [{ position:'left', id:'leftSide', ticks:{beginAtZero:true} },
            { position:'right', id:'rightSide', ticks:{beginAtZero:true}, gridLines:{drawOnChartArea:false} }] }, maintainAspectRatio:false }
    });
    var InvoiceMarginChart = new Chart(document.getElementById("InvoiceMarginChart"), { type: 'bar',
        data: { labels:${Static["groovy.json.JsonOutput"].toJson(invoiceLabelList)},
            datasets:${Static["groovy.json.JsonOutput"].toJson(invoiceMarginDatasets)} },
        options: { scales:{ yAxes: [{ ticks:{beginAtZero:true} }] }, maintainAspectRatio:false }
    });
    var DiscountCostChart = new Chart(document.getElementById("DiscountCostChart"), { type: 'line',
        data: { labels:${Static["groovy.json.JsonOutput"].toJson(invoiceLabelList)},
            datasets:${Static["groovy.json.JsonOutput"].toJson(discountCostDatasets)} },
        options: { scales:{ yAxes: [{ ticks:{beginAtZero:true} }] }, maintainAspectRatio:false }
    });
</script>
