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
<#macro statsPanel title mainFormat valThis valLast valPrior valAvg>
<div class="panel panel-default"><div class="panel-body">
    <h5 class="text-center" style="margin-top:0;">${title}</h5>
    <div class="row"><div class="col-xs-6 text-right">
        <h4 class="text-primary">${ec.l10n.format(valThis, mainFormat)}</h4>
    </div><div class="col-xs-6">
        <div>
            <i class="glyphicon <#if (valThis < valLast)>glyphicon-triangle-bottom text-danger<#else>glyphicon-triangle-top text-success</#if>"></i>
            <span class="<#if (valThis < valLast)>text-danger<#else>text-success</#if>"><#if valLast != 0>${ec.l10n.format(((valThis - valLast)?abs/valLast)*100, '0')}<#else>0</#if>%</span>
            <span class="small">last</span>
        </div>
        <div>
            <i class="glyphicon <#if (valThis < valAvg)>glyphicon-triangle-bottom text-danger<#else>glyphicon-triangle-top text-success</#if>"></i>
            <span class="<#if (valThis < valAvg)>text-danger<#else>text-success</#if>"><#if valAvg != 0>${ec.l10n.format(((valThis - valAvg)?abs/valAvg)*100, '0')}<#else>0</#if>%</span>
            <span class="small">avg</span>
        </div>
    </div></div>
    <div class="row"><div class="col-xs-6 text-right">
        <h4 class="text-primary">${ec.l10n.format(valLast, mainFormat)}</h4>
    </div><div class="col-xs-6">
        <div>
            <i class="glyphicon <#if (valLast < valPrior)>glyphicon-triangle-bottom text-danger<#else>glyphicon-triangle-top text-success</#if>"></i>
            <span class="<#if (valLast < valPrior)>text-danger<#else>text-success</#if>"><#if valPrior != 0>${ec.l10n.format(((valLast - valPrior)?abs/valPrior)*100, '0')}<#else>0</#if>%</span>
            <span class="small">prev</span>
        </div>
        <div>
            <i class="glyphicon <#if (valLast < valAvg)>glyphicon-triangle-bottom text-danger<#else>glyphicon-triangle-top text-success</#if>"></i>
            <span class="<#if (valLast < valAvg)>text-danger<#else>text-success</#if>"><#if valAvg != 0>${ec.l10n.format(((valLast - valAvg)?abs/valAvg)*100, '0')}<#else>0</#if>%</span>
            <span class="small">avg</span>
        </div>
    </div></div>
</div></div>
</#macro>

<div class="row"><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Order Count", '#,##0', (ordersThis.orderCount)!0.0, (ordersLast.orderCount)!0.0, (ordersPrior.orderCount)!0.0, (ordersAverage.orderCount)!0.0/>
</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "New Customer Percent", '0.0%', ((ordersThis.newCustomerPercent)!0.0), ((ordersLast.newCustomerPercent)!0.0), ((ordersPrior.newCustomerPercent)!0.0), ((ordersAverage.newCustomerPercent)!0.0)/>
</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Quantity Sold", '#,##0', (ordersThis.productQuantityTotal)!0.0, (ordersLast.productQuantityTotal)!0.0, (ordersPrior.productQuantityTotal)!0.0, (ordersAverage.productQuantityTotal)!0.0/>
</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Product Sales", '$#,##0', (ordersThis.productSaleTotal)!0.0, (ordersLast.productSaleTotal)!0.0, (ordersPrior.productSaleTotal)!0.0, (ordersAverage.productSaleTotal)!0.0/>
</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Discount Percent", '0.0%', ((ordersThis.discountPercent)!0.0), ((ordersLast.discountPercent)!0.0), ((ordersPrior.discountPercent)!0.0), ((ordersAverage.discountPercent)!0.0)/>
</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Net Sales", '$#,##0', (ordersThis.netSales)!0.0, (ordersLast.netSales)!0.0, (ordersPrior.netSales)!0.0, (ordersAverage.netSales)!0.0/>

</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Invoice Count", '#,##0', (invoicesThis.invoiceCount)!0.0, (invoicesLast.invoiceCount)!0.0, (invoicesPrior.invoiceCount)!0.0, (invoicesAverage.invoiceCount)!0.0/>
</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Invoiced Quantity", '#,##0', (invoicesThis.productQuantityTotal)!0.0, (invoicesLast.productQuantityTotal)!0.0, (invoicesPrior.productQuantityTotal)!0.0, (invoicesAverage.productQuantityTotal)!0.0/>
</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Invoiced Amount", '$#,##0', (invoicesThis.invoiceTotal)!0.0, (invoicesLast.invoiceTotal)!0.0, (invoicesPrior.invoiceTotal)!0.0, (invoicesAverage.invoiceTotal)!0.0/>
</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Paid Percent", '0.0%', ((invoicesThis.paidPercent)!0.0), ((invoicesLast.paidPercent)!0.0), ((invoicesPrior.paidPercent)!0.0), ((invoicesAverage.paidPercent)!0.0)/>
</div><div class="col-lg-3 col-md-4 col-sm-4 col-xs-6">
<@statsPanel "Cost Percent", '0.0%', ((invoicesThis.costPercent)!0.0), ((invoicesLast.costPercent)!0.0), ((invoicesPrior.costPercent)!0.0), ((invoicesAverage.costPercent)!0.0)/>

</div></div>
