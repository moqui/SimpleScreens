## New Outgoing Shipment Button

If the 'From Party' is an internal organization, it is an outgoing shipment.
​
### Fields Description
​
#### Type

It defines the type of outgoing shipment i.e:

- Outgoing
- Purchase Return 
- Sales Shipment

#### Origin Facility

The facility from the shipment was originated i.e., the starting location of the shipment.

#### To Party

Party Id of the user who will receive the shipment.

#### Ready Date

The ready date is the date on which the shipment is expected to be ready.

### Actions on Create button

#### Transitions

The following transition will take place on clicking the 'Create' button:
- SimpleScreens/screen/SimpleScreens/Shipment/FindShipment.xml: 'createShipment'


#### Services

The following service will be called through the 'createShipment' transition:
- mantle.shipment.ShipmentServices.create#Shipment