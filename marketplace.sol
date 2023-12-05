// SPDX-License-Identifier: GPL-3.0
// Uriel Roque
// Zachary McNay
// Andy Maratea
// Randy Harris

pragma solidity ^0.8.17;
import "solidity-json-writer/contracts/JsonWriter.sol";

contract marketplace {
    using JsonWriter for JsonWriter.Json;
    address public manager;

    constructor() {
        manager = msg.sender;
    }

    struct item {
        uint256 id;
        string location;
        string name;
        int256 quant;
        int256 price;
        uint256 dateArrived;
    }

    struct representative {
        address rep;
        string location;
        int256 idrep;
    }

    struct request {
        address rep;
        item[] requestedList;
    }

    item[] public itemList;
    representative[] public representatives;
    JsonWriter.Json[] public publishedItems;

    function addItem(
        uint256 id,
        string memory location,
        string memory name,
        int256 quant,
        int256 price
    ) public {
        item storage newItem = itemList.push();
        require(
            msg.sender == manager,
            "Only the manager may use this feature!"
        );
        newItem.id = id;
        newItem.location = location;
        newItem.name = name;
        newItem.quant = quant;
        newItem.price = price;
        newItem.dateArrived = block.timestamp;
    }

    function publishItem(
        uint256 id,
        string memory location,
        string memory name,
        uint256 quantity,
        uint256 price,
        uint256 dateArrived
    ) public view {
        require(
            msg.sender == manager,
            "Only the manager may use this feature!"
        );
        JsonWriter.Json memory itemWriter;

        itemWriter = itemWriter.writeStartObject();
        itemWriter = itemWriter.writeUintProperty("ID", id);
        itemWriter = itemWriter.writeStringProperty("Location", location);
        itemWriter = itemWriter.writeStringProperty("Name", name);
        itemWriter = itemWriter.writeUintProperty("Quantity", quantity);
        itemWriter = itemWriter.writeUintProperty("Price", price);
        itemWriter = itemWriter.writeUintProperty("Date Arrived", dateArrived);
    }

    function changeMarketPrice(
        address adreps,
        uint256 idreps,
        uint256 id,
        int256 price
    ) public {
        require(
            adreps == representatives[idreps].rep,
            "you must be a representatives"
        );
        itemList[id].price = price;
    }
}
