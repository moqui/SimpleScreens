## Create Purchase Order Button

### Fields Description

#### Supplier

The supplier represents vendor or vendor organization from which order is associated.
 
#### Customer Org

Customer Org represents the organization or the party through which the customer is associated.

#### Facility

The facility represents a facility that is associated with the customer organization.

#### Ship Before Date

Date before which shipment should be happening.

#### Delivery Date

The delivery date represents an estimated delivery date.


### Actions when Create button pressed

#### Transitions

When we click on the 'Create' button, the following transition will be called.
- SimpleScreens/screen/SimpleScreens/Order/FindOrder.xml: 'createOrder'

#### Services

In the 'createOrder' transition, the following service will be called.
- mantle.order.OrderServices.create#Order
