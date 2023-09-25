// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract EventContract {
    
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }

    mapping(uint=>Event) public events; //Details of the event
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    

    function createEvent(string calldata _name, uint _date, uint _price, uint _ticketCount ) public{
         require(block.timestamp < _date,  "Date already passed");
         require(_ticketCount>0, "Ticket count must be greater than 0");
         events[nextId] =Event (msg.sender, _name, _date, _price, _ticketCount, _ticketCount); //We could use the storage like crowfunding
         nextId++;
    }

    function buyTicket(uint _id, uint _quantity) public payable{
        require(events[_id].date != 0, "Event Does not Extists");
        require(events[_id].date > block.timestamp, "Event Has Ended");
        Event storage _event = events[_id];
        require(msg.value==(_event.price*_quantity), "Ether is not enought"); //We could also use directly events[_id].price*_quantity
        require(_event.ticketRemaining>= _quantity, "Not enought tickets left");
        _event.ticketRemaining -=_quantity;
        tickets[msg.sender][_id]+=_quantity;
    }

    function transferTicket(uint _id, uint _quantity, address to) public{
        require(events[_id].date != 0, "Event Does not Extists");
        require(events[_id].date > block.timestamp, "Event Has Ended");
        require(tickets[msg.sender][_id] >= _quantity, "You dont have tickets to transfer");
        tickets[msg.sender][_id] -=_quantity;
        tickets[to][_id]+=_quantity;
    }

}

