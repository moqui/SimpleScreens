## Create Sales Order Button
​
### Fields Description
​
#### Store
A store has all the information needed to sell products. It is composed of a collections of catalogs, which are composed of product categories and products.
#### Vendor Org
The vendor (seller) of the items.
#### Facility
The Facility to fulfil the order from.
#### Customer
The customer (buyer) of the items.
#### Their Order Id
Purchase order id of the customer.
#### Priority
Numeric priority, 1 to 9 where 1 is highest priority and 9 is lowest priority (like a to do list), defaults to 5.
#### Ship Before Date
Date before which shipment should be happen.
#### Delivery Date
The Delivery represents estimated delivery date.
​
​
### Actions on Create button
​
#### Transitions
The following transition will take place on clicking the 'Create' button:
- SimpleScreens/screen/SimpleScreens/Order/FindOrder.xml: 'createOrder'


#### Services
The following service will be called through the 'createOrder' transition:
- mantle.order.OrderServices.create#Order