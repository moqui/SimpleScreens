<#assign dateFormat = dateFormat!"dd MMM yyyy">

<p>The following invoices are now past due and we have not received payment for the unpaid amounts listed below.</p>

<p>Please contact us immediately to discuss payment options.</p>

<table border="0" cellpadding="8px" cellspacing="3" width="100%">
    <tr><td>Your Order</td><td>Ref #</td><td>Invoice</td><td>Date</td><td>Due</td><td>Total</td><td>Unpaid</td></tr>
    <#list invoiceList as invoice>
        <tr>
            <td>${(invoice.otherPartyOrderId!"")?html}</td>
            <td>${(invoice.referenceNumber!"")?html}</td>
            <td>${invoice.invoiceId}</td>
            <td>${ec.l10n.format(invoice.invoiceDate!, dateFormat)}</td>
            <td>${ec.l10n.format(invoice.dueDate!, dateFormat)}</td>
            <td>${ec.l10n.formatCurrency(invoice.invoiceTotal!, invoice.currencyUomId!"USD")}</td>
            <td>${ec.l10n.formatCurrency(invoice.unpaidTotal!, invoice.currencyUomId!"USD")}</td>
        </tr>
    </#list>
</table>

<p><strong>Customer #</strong> ${toParty.pseudoId}</p>
