## Order Roles and Parts

### Order Roles

The primary roles for an order are Customer and Vendor.

If the Vendor is an internal organization the order is a sales order, otherwise it is a purchase order. Sales and purchase orders
share the same set of statuses though the flow through the statuses varies slightly.

All orders must has a single Customer and Vendor. In addition to these there may be additional parties such as:

- Customer
    - Ship To (shipments are sent to this Party) 
    - Bill To (invoices are sent to this Party)
    - Placed By
    - End User
- Vendor
    - Bill From
    - Ship From
    - Pick Up From
- Supplier
    - A supplier is an external vendor that an internal organization purchases from
- Sales Representative
- Order Clerk
- Buyer
- Account

### Order Parts

An order may be split into multiple parts and always has at least one part.

The main reason to split an order into parts is when shipping from and/or to different locations or by different shipping methods.
Managing different shipping or receiving dates for sets of items may also be easier using multiple parts. 
 
While each order part has a Customer and Vendor they are generally the same for all order parts. Other roles may vary by part 
including the Ship To Customer, etc.
