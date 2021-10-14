// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// We are making a contract in which everyone joins and contributes coin 

contract Coin_collective {
    
    // Structure of a member object
    struct Member {
        string member_name;
        uint256 amount_given;
        address member_address;
    }
    
    //Creating dynamic array for members
    Member[] public member;
    mapping(string => address)public nametoaddress;
    
    //function to add member
    function add_member(string memory name_,uint256 amount_,address address_)public {
        member.push(Member({member_name: name_, amount_given:amount_, member_address:address_}));
        nametoaddress[name_] = address_;
    }
    
}
