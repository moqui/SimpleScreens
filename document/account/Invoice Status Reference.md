## Invoice Status Reference

All Invoices have From and To parties. If the From party is an internal organization it is an outgoing invoice (receivable), 
otherwise it is an incoming invoice (payable).

Incoming and outgoing invoices have separate status flows.

### Outgoing (Receivable/Sales) Invoice Status Flow

#### In-Process

This is the initial status for an outgoing invoice and used while the invoice is being entered and edited before finalizing.

#### Finalized

The invoice is finalized and ready to be sent.

When an invoice goes into this status it is automatically posted to the GL with an accounting transaction. To resume changes an 
invoice status may be changed from Finalized to In-Process and this will cause a new accounting transaction to be created to reverse
the original.

#### Sent

The Sent status is optional and may be set when the invoice has been sent to the invoice To party.

#### Payment Received

This is set when payment has been received from the invoice To party.

The Payment Received status is automatically set when sufficient payments to cover the invoice are applied.

If the invoice status is changed from Payment Received to Finalized all applied payments will be unapplied and if applicable the 
corresponding GL posting will be reversed with a new accounting transaction.

#### Write Off

Used when an invoice is not expected to be paid and the receivable should be written off.

### Incoming (Payable/Purchase) Invoice Status Flow

#### Incoming

The initial status for incoming invoices to use when recording invoice details.

#### Received

Set this status when the invoice is fully entered and awaiting approval for payment.

When approving invoices find invoices in this status to see those awaiting approval.

#### Approved

The invoice is approved for payment.

When an invoice goes into this status it is automatically posted to the GL with an accounting transaction. To resume changes an 
invoice status may be changed from Approved to Received and this will cause a new accounting transaction to be created to reverse
the original.

#### Payment Sent

This is set when payment has been sent to the invoice From party.

The Payment Sent status is automatically set when sufficient payments to cover the invoice are applied.

If the invoice status is changed from Payment Sent to Approved all applied payments will be unapplied and if applicable the 
corresponding GL posting will be reversed with a new accounting transaction.

#### Billed Through

An invoice is billed through when an outgoing (receivable) invoice has been created to bill the invoice through to a third party.
For example expenses may be paid and billed through to a customer or client.

### Invoice Cancelled

An invoice may be cancelled from most statuses.

If an outgoing invoice is in the Finalized or later status, or an outgoing invoice is in the Approved or later status, and an 
accounting transaction created then cancelling causes a reversing transaction to be posted.
