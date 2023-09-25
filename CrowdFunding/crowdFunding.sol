// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract CrowdFunding {

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }

    mapping(uint=>Request) public requests;
    mapping(address=>uint) public contributors;

    uint public numRequests;
    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;

    constructor(uint _target, uint _deadline) {
        target = _target;
        deadline = block.timestamp+_deadline;
        minimumContribution= 100 wei;
        manager = msg.sender;
    }
    modifier onlyManager{
        require(msg.sender==manager,"You are not the manager");
        _;
    }

    modifier minimumContribute(){
        require(msg.value>= minimumContribution,"Not enought..");
        _;
    }

    modifier isContributor(){
        require(contributors[msg.sender]>0, "You are not a contributor");
        _;
    }

    function createReqeust(string calldata _desc, address payable _recipeint, uint _value) public onlyManager{
        
        Request storage newRequest = requests[numRequests]; //With storage we are pointing to the mapping "reqeusts"
        numRequests++;
        newRequest.description=_desc;
        newRequest.recipient=_recipeint;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.noOfVoters=0;
    }

    function contribution() public payable minimumContribute{
        require(block.timestamp<deadline,"Deadline has passed");
        
        if(contributors[msg.sender]==0){ //In case the same contributor, contributes again we dont want to increase the noOfContributors
            noOfContributors++;    
        }
        contributors[msg.sender] += msg.value;
        raisedAmount+=msg.value;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    //Contributors can refund when the deadline is passed and the raised amount didnt met the target. 
    function refund() public payable isContributor {
        require(block.timestamp > deadline && raisedAmount < target,"You are not eligible for refund.");
        
        payable(msg.sender).transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;
    }

    function voteRequest(uint _requestNo) public isContributor {
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false,"You already voted");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public payable onlyManager{
        require(raisedAmount>target,"Target is not reached");
        Request storage thisRequest= requests[_requestNo];
        require(thisRequest.completed==false,"The request has been completed");
        require(thisRequest.noOfVoters>noOfContributors/2,"Majority does not support the reqeust");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed=true;

    }

}