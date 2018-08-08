<#assign dateFormat = dateFormat!"dd MMM yyyy">

<p>The following invoices are now past due and we have not received payment for the unpaid amounts listed below.</p>

<p>Please contact us immediately to discuss payment options.</p>

<p><strong>Past Due Invoices</strong></p>
<table border="0" cellpadding="8px" cellspacing="3" width="100%">
    <tr><td>Your Order</td><td>Ref #</td><td>Invoice #</td><td>Date</td><td>Due</td><td>Total</td><td>Unpaid</td></tr>
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

<#if paymentList?has_content>
<p><strong>Payments not yet Applied</strong></p>
<table border="0" cellpadding="8px" cellspacing="3" width="100%">
    <tr><td>Payment Ref #</td><td>Payment #</td><td>Date</td><td>Total</td><td>Unapplied</td></tr>
    <#list paymentList as payment>
        <tr>
            <td>${(payment.paymentRefNum!"")?html}</td>
            <td>${payment.paymentId}</td>
            <td>${ec.l10n.format(payment.effectiveDate!, dateFormat)}</td>
            <td>${ec.l10n.formatCurrency(payment.amount!, payment.amountUomId!"USD")}</td>
            <td>${ec.l10n.formatCurrency(payment.unappliedTotal!, payment.amountUomId!"USD")}</td>
        </tr>
    </#list>
</table>
</#if>

<#if creditInvoiceList?has_content>
<p><strong>Credit Memos not yet Applied</strong></p>
<table border="0" cellpadding="8px" cellspacing="3" width="100%">
    <tr><td>Your Order</td><td>Credit Ref #</td><td>Memo #</td><td>Date</td><td>Due</td><td>Total</td><td>Unapplied</td></tr>
    <#list creditInvoiceList as invoice>
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
</#if>

<p><strong>Total Past Due</strong> ${ec.l10n.format(((unpaidInvoiceTotal!0.0) - (unappliedPaymentTotal!0.0) - (creditInvoiceTotal!0.0)), "#,##0.00")}</p>

<p><strong>Customer #</strong> ${toParty.pseudoId}</p>
