<#assign dateFormat = dateFormat!"dd MMM yyyy">

The following invoices are now past due and we have not received payment for the unpaid amounts listed below.

Please contact us immediately to discuss payment options.

Past Due Invoices

<#list invoiceList as invoice>
Your Order: ${(invoice.otherPartyOrderId!"")}
Ref #: ${(invoice.referenceNumber!"")}
Invoice: ${invoice.invoiceId}
Date: ${ec.l10n.format(invoice.invoiceDate!, dateFormat)}
Due: ${ec.l10n.format(invoice.dueDate!, dateFormat)}
Total: ${ec.l10n.formatCurrency(invoice.invoiceTotal!, invoice.currencyUomId!"USD")}
Unpaid: ${ec.l10n.formatCurrency(invoice.unpaidTotal!, invoice.currencyUomId!"USD")}

</#list>

<#if paymentList?has_content>
Payments not yet Applied

<#list paymentList as payment>
Payment Ref #: ${(payment.paymentRefNum!"")?html}
Payment #: ${payment.paymentId}
Date: ${ec.l10n.format(payment.effectiveDate!, dateFormat)}
Total: ${ec.l10n.formatCurrency(payment.amount!, payment.amountUomId!"USD")}
Unapplied: ${ec.l10n.formatCurrency(payment.unappliedTotal!, payment.amountUomId!"USD")}

</#list>
</#if>

<#if creditInvoiceList?has_content>
Credit Memos not yet Applied

<#list creditInvoiceList as invoice>
Your Order: ${(invoice.otherPartyOrderId!"")?html}
Credit Ref #: ${(invoice.referenceNumber!"")?html}
Memo #: ${invoice.invoiceId}
Date: ${ec.l10n.format(invoice.invoiceDate!, dateFormat)}
Due: ${ec.l10n.format(invoice.dueDate!, dateFormat)}
Total: ${ec.l10n.formatCurrency(invoice.invoiceTotal!, invoice.currencyUomId!"USD")}
Unapplied: ${ec.l10n.formatCurrency(invoice.unpaidTotal!, invoice.currencyUomId!"USD")}

</#list>
</#if>

Total Past Due: ${ec.l10n.format(((unpaidInvoiceTotal!0.0) - (unappliedPaymentTotal!0.0) - (creditInvoiceTotal!0.0)), "#,##0.00")}

Customer #: ${toParty.pseudoId}
