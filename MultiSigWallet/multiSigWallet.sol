// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract MultiSigWallet {

    address[] public owners;
    uint public numConfirmationsRequired;


    struct Transaction{
        address to;
        uint value;
        bool executed;
    }

    mapping(uint=>mapping(address=>bool)) isConfirmed;
    Transaction[] public transactions;

    modifier isValidTxId(uint _transactionId){
        require(_transactionId<transactions.length,"Invalid Transaction Id");
        _;
    }
    event TransactionSubmitted(uint transactionId, address sender, address receiver, uint amount);
    event TransactionConfirmed(uint transactionId);
    event TransactionExecuted(uint transactionId); 

    constructor(address[] memory _owners, uint _numConfirmationsRequired){
        require(_owners.length>1, "Owners Required Must be Greater than 1");
        require(_numConfirmationsRequired > 0 && numConfirmationsRequired <= _owners.length, "Num of are not in sync with the number of owners");
        for(uint i=0; i<_owners.length; i++){
            require(_owners[i]!=address(0),"Invalid Owners");
            owners.push(_owners[i]);
        }
        numConfirmationsRequired=_numConfirmationsRequired;
    }


    function submitTransaction(address _to) public payable{
        require(_to != address(0), "Invalid Receiver's Address");
        require(msg.value >= 0, "Transfer Amount Must Be Greater Than 0");

        uint transactionId = transactions.length;
        transactions.push(Transaction(_to, msg.value, false));

        emit TransactionSubmitted(transactionId,msg.sender,_to,msg.value);
    }

    function confirmTransaction(uint _transactionId) public isValidTxId(_transactionId) {
        require(!isConfirmed[_transactionId][msg.sender],"Transaction is Already Confirmed By the Owner"); //We are checking if that particular address has give the confirmation for that transaction
        isConfirmed[_transactionId][msg.sender]=true; 
        emit TransactionConfirmed(_transactionId);
        
        if(isTransactionConfirmed(_transactionId)){
            executeTransaction(_transactionId);
        }
    }

    function executeTransaction(uint _transactionId) public  payable isValidTxId(_transactionId){
        require(!transactions[_transactionId].executed,"Transaction is already executed");        
        (bool success,)= transactions[_transactionId].to.call{value:transactions[_transactionId].value}("");
        require(success, "Transaction Execution Failed");
        transactions[_transactionId].executed=true;
        emit TransactionExecuted(_transactionId);
    }

    function isTransactionConfirmed(uint _transactionId) internal view isValidTxId(_transactionId) returns(bool) {
        uint confirmationCount;//initiazlly zero

        for(uint i=0; i<owners.length; i++){
            if(isConfirmed[_transactionId][owners[i]]){
                confirmationCount++;
            }
        }
        return confirmationCount>=numConfirmationsRequired;
    }

}

