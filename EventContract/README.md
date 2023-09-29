# EventContract Smart Contract

The EventContract is a Solidity smart contract designed to manage and sell tickets for events on the Ethereum blockchain. It provides functionality to create events, purchase tickets, and transfer tickets between addresses.

## Contract Features

### Event Creation

- Owners can create events by specifying the event name, date, ticket price, and the number of available tickets.

### Ticket Purchase

- Users can purchase tickets for events by providing the event ID and the quantity of tickets they want to buy.

### Ticket Transfer

- Users can transfer tickets to other addresses, enabling them to resell or gift their tickets.

## Event Details

- Each event has details including the organizer's address, event name, date, ticket price, total ticket count, and remaining ticket count.

## Usage

1. **Create an Event**:

   - Owners can create events using the `createEvent` function by providing the event name, date, ticket price, and the number of available tickets.

2. **Purchase Tickets**:

   - Users can purchase event tickets using the `buyTicket` function by specifying the event ID and the quantity of tickets they want to buy. Payment must be sent with the transaction, and the contract checks if the payment matches the ticket price.

3. **Transfer Tickets**:

   - Users can transfer event tickets to other addresses using the `transferTicket` function. They need to specify the event ID, the quantity of tickets to transfer, and the recipient's address.

## Security Considerations

- Ensure the contract is deployed on a secure and well-audited blockchain.
- Review and test the contract thoroughly before using it in a production environment.
- Be cautious about event dates and ensure that events cannot be created with dates in the past.

## Functions and Data

- `createEvent`: Create a new event.
- `buyTicket`: Purchase event tickets.
- `transferTicket`: Transfer event tickets to another address.
- `events`: View event details.
- `tickets`: View the number of tickets owned by an address for a specific event.
- `nextId`: The ID to assign to the next created event.

This contract simplifies the management of event tickets on the Ethereum blockchain, making it easier to create and sell tickets for various events.

---

Feel free to expand upon this `readme.md` by providing more context, usage examples, or additional information specific to your use case. This document serves as an introductory guide to your EventContract.
