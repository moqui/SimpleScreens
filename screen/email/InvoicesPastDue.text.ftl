<#assign dateFormat = dateFormat!"dd MMM yyyy">

The following invoices are now past due and we have not received payment for the unpaid amounts listed below.

Please contact us immediately to discuss payment options.

<#list invoiceList as invoice>
Your Order: ${(invoice.otherPartyOrderId!"")}
Ref #: ${(invoice.referenceNumber!"")}
Invoice: ${invoice.invoiceId}
Date: ${ec.l10n.format(invoice.invoiceDate!, dateFormat)}
Due: ${ec.l10n.format(invoice.dueDate!, dateFormat)}
Total: ${ec.l10n.formatCurrency(invoice.invoiceTotal!, invoice.currencyUomId!"USD")}
Unpaid: ${ec.l10n.formatCurrency(invoice.unpaidTotal!, invoice.currencyUomId!"USD")}

</#list>

Customer #: ${toParty.pseudoId}
