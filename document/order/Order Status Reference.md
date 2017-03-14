## Order Status Reference

### Main Status Flow

#### Open (Tentative)

The initial status for most orders. Orders in this status may be changed by Customer or by Vendor.
 
#### Quote Requested

An order in this status is a request for a quote. This is an alternative to going directly from Open to Placed.

From this status a Customer may place an order, or a Vendor may propose a quote to be accepted (placed) by Customer.

#### Proposed By Vendor

This status means the order is a quote proposed by Vendor, but not yet accepted (placed) by Customer.

#### Placed

The order is placed by the Customer, or on behalf of Customer at the Customer's request.

A sales order in this status is generally not editable by a Customer, but may be changed by Vendor (for sales orders).

For purchase orders this means the order has been placed by a buyer but is awaiting approval before sending to Vendor.

#### Approved

An order in this status has been approved by the vendor for fulfillment. In this status one or more shipments may be created for 
items on the order.

An approved order may be modified with certain constraints. Fulfilled quantities may not be cancelled but may be returned. 
For partially fulfilled orders if unfulfilled quantities are cancelled or removed the order will go to the Completed status.

More detailed information about partial fulfillment is tracked per item by quantity.

#### Sent

Generally used only for purchase orders (Customer is an Internal Organization) to denote that the order has been sent to Vendor.

#### Completed

An order, or part of an order, goes into this status once all quantities of all items have been fulfilled.

### Other Statuses

#### Processing

This is an interim status between Placed and Approved used only when an order has started review and processing for approval.

#### Held

Use this status to hold an order after it has been Placed and before it is Approved. 

#### Rejected

Rejected by Vendor.

#### Cancelled

Cancelled by Customer.

#### Wish List

A special status for orders that represent a wish list. Orders in this status do not typically change status.

#### Gift Registry

A special status for orders that represent a gift registry list. Orders in this status do not typically change status.
