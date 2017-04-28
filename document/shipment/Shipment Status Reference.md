## Shipment Status Reference

All Shipments have From and To parties. If the From party is an internal organization it is an outgoing shipment, 
otherwise it is an incoming shipment.

### Incoming Status Flow

- Input
- Scheduled
- Picked (optional, if notified by From party)
- Packed (optional, if notified by From party)
- Shipped (optional, if notified by From party)
- Delivered (received)

To be received an incoming shipment must be in the Scheduled or later status.

A shipment may be marked Delivered if it is at least partially received and means that no further items are expected.

When a shipment goes into the Delivered status an incoming (payable/purchase) invoice will be generated for items not already billed.

### Outgoing Status Flow

- Input
- Scheduled
- Picked (optional)
- Packed (required)
- Shipped (optional)
- Delivered (optional)

To be packed an outgoing shipment must be in the Scheduled or later status.

Note that as item quantities are packed (independent of the packed status) they are issued to the shipment and accounting transactions are posted.

The most important status for an outgoing shipment is Packed. In this status the shipment is considered final and maybe invoiced.
For outgoing shipments with items associated with order items and an outgoing (receivable/sales) invoice will be generated and 
authorized payments captured when a shipment changes to the Packed status.

### Status Definitions

#### Input

This is generally the initial status for a Shipment and means it is being input and prepared.

In this status a shipment is still tentative. Incoming shipments may not be received, and outgoing shipments may not be packed.

#### Scheduled

The shipment is scheduled, or at least the input is complete and the shipment ready to be processed.

#### Picked

Items for the shipment have been picked from storage locations.

#### Packed

Items for the shipment have been packed into final packaging and packages have been weighed, etc.

For outgoing shipments this triggers creating an outgoing (receivable/sales) invoice for items not already billed.

#### Shipped

The shipment has been scheduled for shipping (with label, tracking code, etc) and optionally picked up by the Carrier or loaded onto a delivery truck.

If a Shipment Shipped email is configured on the store associated with an order on the Shipment then it will be sent when this status is reached.

#### Delivered

The shipment has been delivered to the To party. For incoming shipments this denotes the shipment has been fully received.

For incoming shipments this triggers creating an incoming (payable/purchase) invoice for items not already billed.

If a Shipment Delivered email is configured on the store associated with an order on the Shipment then it will be sent when this status is reached.

#### Rejected

Rejected on attempt to deliver.

#### Cancelled

Cancelled before shipping.
