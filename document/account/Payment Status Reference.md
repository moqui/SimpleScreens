## Payment Status Reference

All Payments have From and To parties. If the From party is an internal organization it is an outgoing payment, 
otherwise it is an incoming payment.

### Main Payment Status Flow

#### Proposed

This is generally the initial status of a payment, unless the payment has already been delivered.

Payments in this status are tentative and generally being modified before a promise or authorization.

#### Promised

The payment has been promised for some purpose such as intended payment for an order.

For example payments for sales orders with credit card payment instrument are in this status until they are authorized.
 
For payment instruments that do not support authorization (such as checks) payments will generally be in this status until they
are delivered (sent or received).

#### Authorized

For outgoing payments this means the payment has been authorized to be sent to the To party.

For incoming payments this used where the payment instrument supports some sort of authorization including credit card authorization.
When authorized the reference number should be populated with the authorization's transaction or authorization code.

#### Delivered

For outgoing payments the payment has been sent, and for incoming payments it has been received but not yet confirmed.

#### Confirmed Paid

For outgoing payments this can be set when the To party has verified they have received the payment.

For incoming payments this is set when the payment is confirmed such as reconciliation with a bank account. 

### Other Statuses

#### Cancelled

The payment was cancelled before funds were sent.

#### Void

The payment was voided before funds were transferred.

#### Declined

The payment was declined (such as a credit card decline) or failed to clear.

#### Refunded

The payment has been refunded by the To party to the From party.
