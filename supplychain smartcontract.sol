pragma solidity 0.4.24;

contract Supplychain{
    ///////////DECLARATION//////////
    
    address Owner;
    
    struct package{
        bool isuidegenerated;
        uint itemid;
        string itemname;
        string transitstatus;
        uint orderstatus; // if 1 = ordered, if 2 = transit , if 3 = delivered , if 4= cancelled or returned 
        
        address customer;
        uint ordertime;
        
        address carrier1;
        uint carrier1_time;
        
        address carrier2;
        uint carrier2_time;
        
        address carrier3;
        uint carrier3_time;
        
        
    }
    
    mapping (address => package) public packagemapping;
    mapping (address => bool) public carriers;     ///bool to verify the carriers
    
    ////////////////DECLARATION END////////////////
    
    
    
    
    //////////////MODIFIER////////////////////////
    
    constructor(){
        Owner=msg.sender; //deployer will be the owner so itll run only once for contract while deploying 
    }
    
    modifier onlyOwner(){
        require(Owner == msg.sender);//execute only if the executer is the owner
        _;
    }
    
    //////////////MODIFIEREND/////////////////////
    
    //////////////CARRIER MANAGER////////////////////////
    
    function AssignCarriers(address _carrierAddress) onlyOwner public returns (string)  {
        
        if(!carriers[_carrierAddress]){
            carriers[_carrierAddress] = true;
        }else{
            carriers[_carrierAddress] = false;
        }
        return "Carrier is updated";
    }
    
    
    
    
    
    
    
    //////////////CARRIER MANAGER END////////////////////
    
     //////////////ORDERING////////////////////
    
    function PlaceOrder(uint _itemid, string   _itemname) public returns (address ){
        address uniqueId = address(sha256(msg.sender, now));   //uniqueid for customer so sha 256 key for difference in each user
        
        packagemapping[uniqueId].isuidegenerated = true;
        packagemapping[uniqueId].itemid = _itemid;
        packagemapping[uniqueId].itemname = _itemname;
        packagemapping[uniqueId].transitstatus = "your package is ordered and currently processing";
        packagemapping[uniqueId].orderstatus = 1;
        
        packagemapping[uniqueId].customer = msg.sender;
        packagemapping[uniqueId].ordertime - now;
        
        return uniqueId;
        
    }   
    //////////////ORDERING END////////////////////
    
    //////////////CANCELLING ORDER////////////////////
    
        function CancelOrder(address _uniqueId) public returns (string){
            require(packagemapping[_uniqueId].isuidegenerated);//to cencel uid must be generated first uid is created when ordered
            require(packagemapping[_uniqueId].customer == msg.sender);//verifies the customer is valid to cancel order
            
            packagemapping[_uniqueId].orderstatus = 4;
            packagemapping[_uniqueId].transitstatus = " ORDER  CANCELLED";
            
            return "YOUR ORDER IS CANCELLED SUCCESSFULLY ";
            
        }
    //////////////CANCELLING ORDER END////////////////////
    
    
    //////////////CARRIERS///////////////////////
    
    function Carrier1Report(address _uniqueId, string _transitStatus){
        require(packagemapping[_uniqueId].isuidegenerated);
        require(carriers[msg.sender]);
        require(packagemapping[_uniqueId].orderstatus == 1);
        
        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier1 = msg.sender;
        packagemapping[_uniqueId].carrier1_time = now;
        packagemapping[_uniqueId].orderstatus = 1;
    
    
    }
    
    function Carrier2Report(address _uniqueId, string _transitStatus){
        require(packagemapping[_uniqueId].isuidegenerated);
        require(carriers[msg.sender]);
        require(packagemapping[_uniqueId].orderstatus == 2);
        
        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier2 = msg.sender;
        packagemapping[_uniqueId].carrier2_time = now;
        packagemapping[_uniqueId].orderstatus = 2;
    
    
    }
    
    
    
    function Carrier3Report(address _uniqueId, string _transitStatus){
        require(packagemapping[_uniqueId].isuidegenerated);
        require(carriers[msg.sender]);
        require(packagemapping[_uniqueId].orderstatus == 3);
        
        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier3 = msg.sender;
        packagemapping[_uniqueId].carrier3_time = now;
        packagemapping[_uniqueId].orderstatus = 3;
    
    
    }
    
    
    
    //////////////CARRIERS END ///////////////////////
    
}
