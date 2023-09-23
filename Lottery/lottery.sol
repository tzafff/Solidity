// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery {

        //entities - manager,players and winner.

        address public manager;
        address payable[] public players; // we need to be payable because these adresses will send/receive eth.
        address payable public  winner;

         constructor(){
             manager=msg.sender;
        }

        function participate() public payable {
            require(msg.value==10 wei, "Please pay 10 wei only");
            players.push(payable (msg.sender));
        }

        function getBalance() public view returns (uint){
            require(manager==msg.sender,"Not authorized");
            return address(this).balance;
        }

        function random() public view returns(uint){
             return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
        }

        function pickWinner() public payable {
            require(msg.sender==manager);
            require(players.length >=3,"Players are less than 3");
            
            uint r = random();
            uint index = r%players.length;
            winner= players[index];
            winner.transfer(getBalance());
            players = new address payable[](0); // this will initialiaze array back to 0 
        }
}