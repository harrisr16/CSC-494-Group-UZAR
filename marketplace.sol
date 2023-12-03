// SPDX-License-Identifier: GPL-3.0
// Uriel Roque
// Randy Harris
// Zachary McNay

pragma solidity ^0.8.17;

contract marketplace {
    address public manager;

    constructor() {
        manager = msg.sender;
    }
    struct item{
        address user;
        uint id;
        string location;
        string name;
        int quant;
        int price;
        string dataarrived;

    }
    struct representive{
        address rep;
        string location;
        int idrep;
    }
    item[] public spreadsheat;
    representive[] public representives;
    function addItem(
        address user,
        uint256 id,
        string memory location,
        string memory name,
        int256 quant,
        int256 price,
        string memory datearrive
    ) public {item storage newSpreadsheat = spreadsheat.push();require(user == manager,"only the manager may use this function");
        newSpreadsheat.user = user;
        newSpreadsheat.id = id;
        newSpreadsheat.location = location;
        newSpreadsheat.name = name;
        newSpreadsheat.quant = quant;
        newSpreadsheat.price = price;
        newSpreadsheat.dataarrived = datearrive;

    }
    function changeMarketPrice (address adreps, uint idreps,  uint id, int price) public{
        require(adreps == representives[idreps].rep, "you must be a representive");
        representives[id].price = price

    }
    
}
