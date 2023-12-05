// SPDX-License-Identifier: GPL-3.0
// Uriel Roque
// Zachary McNay
// Andy Maratea
// Randy Harris

pragma solidity ^0.8.17;
import "solidity-json-writer/contracts/JsonWriter.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

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
        uint256 quant;
        uint256 price;
        uint256 dateArrived;
    }

    struct representative {
        address rep;
        string location;
        int256 idrep;
    }

    struct request {
        address requester;
        item[] requestedList;
        uint256 approvers;
        mapping(address => bool) hasApproved;
        bool approved;
    }

    item[] public itemList;
    representative[] public representatives;
    string[] public publishedItems;
    mapping(address => request) requests;

    function addItem(
        uint256 id,
        string memory location,
        string memory name,
        uint256 quant,
        uint256 price
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

    function publishItems() public {
        require(
            msg.sender == manager,
            "Only the manager may use this feature!"
        );
        for (uint256 i = 0; i < itemList.length; i++) {
            JsonWriter.Json memory itemWriter;

            itemWriter = itemWriter.writeStartObject();
            itemWriter = itemWriter.writeUintProperty("ID", itemList[i].id);
            itemWriter = itemWriter.writeStringProperty(
                "Location",
                itemList[i].location
            );
            itemWriter = itemWriter.writeStringProperty(
                "Name",
                itemList[i].name
            );
            itemWriter = itemWriter.writeUintProperty(
                "Quantity",
                itemList[i].quant
            );
            itemWriter = itemWriter.writeUintProperty(
                "Price",
                itemList[i].price
            );
            itemWriter = itemWriter.writeUintProperty(
                "Date Arrived",
                itemList[i].dateArrived
            );
            itemWriter = itemWriter.writeEndObject();
            publishedItems.push(itemWriter.value);
        }
    }

    function changeMarketPrice(
        address adreps,
        uint256 idreps,
        uint256 id,
        uint256 price
    ) public {
        require(
            adreps == representatives[idreps].rep,
            "you must be a representatives"
        );
        itemList[id].price = price;
    }

    function isRep(address addr) public view returns (bool) {
        for (uint256 i = 0; i < representatives.length; i++) {
            if (addr == representatives[i].rep) {
                return true;
            }
        }
        return false;
    }

    function isValidID(uint256 id) public view returns (bool) {
        for (uint256 i = 0; i < itemList.length; i++) {
            if (id == itemList[i].id) {
                return true;
            }
        }
        return false;
    }

    function isValidQuantity(uint256 id, uint256 qty)
        public
        view
        returns (bool)
    {
        require(isValidID(id), "Not a valid ID");
        for (uint256 i = 0; i < itemList.length; i++) {
            if (id == itemList[i].id) {
                if (itemList[i].quant > qty) {
                    return true;
                }
            }
        }
        return false;
    }

    function requestItem(uint256[] calldata ids) public {
        require(
            isRep(msg.sender),
            "You must be a representative to use this feature!"
        );
        request storage currRequest = requests[msg.sender];
        currRequest.requester = msg.sender;
        currRequest.approvers = 0;

        for (uint256 i = 0; i < ids.length; i++) {
            string memory warnStatement = string.concat(
                "Not a valid item ID at ID number: ",
                Strings.toString(ids[i]),
                "!"
            );
            require(isValidID(ids[i]), warnStatement);
            for (uint256 j = 0; j < itemList.length; j++) {
                if (itemList[j].id == ids[i]) {
                    currRequest.requestedList.push(itemList[j]);
                }
            }
        }
    }

    function approveRequest(address addr) public {
        require(
            !requests[addr].approved,
            "This request has already been approved!"
        );
        require(
            isRep(msg.sender),
            "You must be a representative to use this feature!"
        );
        require(
            !requests[addr].hasApproved[addr],
            "You have already approved this request!"
        );
        requests[addr].approvers += 1;
    }

    function isApproved(address addr) public {
        if (requests[addr].approvers >= representatives.length / 2) {
            requests[addr].approved = true;
        }
    }

    function itemToString(item memory currItem) public pure returns (string memory) {
        string memory itemString;
        // uint256 id;
        // string location;
        // string name;
        // uint256 quant;
        // uint256 price;
        // uint256 dateArrived;
        itemString = string.concat(
            "ID: ",
            Strings.toString(currItem.id),
            "\nLocation: ",
            currItem.location,
            "\nName: ",
            currItem.name,
            "\nQuantity: ",
            Strings.toString(currItem.quant),
            "\nPrice: ",
            Strings.toString(currItem.price),
            "\nDate Arrived: ",
            Strings.toString(currItem.dateArrived)
        );

        return itemString;
    }

    function publishMarket() public view returns (string[] memory) {
        string[] memory marketplaces;
        for (uint256 i = 0; i < representatives.length; i++) {
            string memory mktplace;
            request storage currRequest = requests[representatives[i].rep];
            for (uint256 j = 0; j < currRequest.requestedList.length; j++) {
                mktplace = string.concat(
                    mktplace,
                    "\n",
                    itemToString(currRequest.requestedList[j])
                );
            }
            marketplaces[i] = mktplace;
        }
        return marketplaces;
    }
}
