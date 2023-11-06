## Place/Place Warnings
Users can place the order using this button. If no information is missing in the order, then the user will see the 'Place' button else user will see 'Place Warnings' button.
On clicking the 'Place Warnings' button, a pop-up window will come containing warnings about the missing information in the order.

Following are some examples of warnings:

- Order has no items
- Part 01 has no customer
- Part 01 has no shipping address selected
- Part 01 has no shipment method selected

However, the user can ignore the warnings and place the order by clicking on the 'Place Order Anyways' button.

### Transitions
The following transition will take place on clicking the 'Place' or 'Place Order Anyway' button:
- SimpleScreens/screen/SimpleScreens/Order/FindOrder.xml: placeOrder

### Services
The following service will be called through the 'placeOrder' transition:
- mantle.order.OrderServices.place#Order

## Quote Requested
If a customer requested for a quote then we can this feature to change the status of the order to 'Quote Requested' status.

### Transitions
The following transition will take place on clicking the 'Quote Requested' button:
- SimpleScreens/screen/SimpleScreens/Order/OrderDetail.xml: requestOrder

### Services
The following service will be called through the 'requestOrder' transition:
- mantle.order.OrderServices.update#OrderStatus

