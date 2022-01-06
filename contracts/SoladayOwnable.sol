// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <=0.8.11;

error NotOwner();

/**
 * @title SoladayOwnable
 * @dev Stupid little Ownable implementation
 */
contract SoladayOwnable {

    /*********
    * Events *
    **********/  
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /************
    * Variables *
    *************/
    address internal _owner;

    /*******************
    * Public Functions *
    ********************/
    modifier isOwner()
    {
        if(_owner != msg.sender) revert NotOwner();
        _;
    }

    constructor()
    {
        _owner = msg.sender;
    }

    function owner() view external returns(address)
    {
        return _owner;
    }

    function transferOwnership(address _newOwner) external isOwner()
    {
        address _previousOwner =  _owner;
        _owner = _newOwner;
        emit OwnershipTransferred( _previousOwner, _newOwner);
    }
}
