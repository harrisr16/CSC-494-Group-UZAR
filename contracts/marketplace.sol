// SPDX-License-Identifier: GPL-3.0
// Uriel Roque
// Zachary McNay
// Andy Maratea
// Randy Harris

pragma solidity ^0.8.20;
import "solidity-json-writer/contracts/JsonWriter.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Marketplace {
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
    item[] public marketplaceItems;
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

    function addRep(address rep, string memory location) public {
        require(msg.sender == manager);
        require(bytes(location).length > 0, "Location cannot be null!");
        representative memory newRep;
        newRep.rep = rep;
        newRep.location = location;

        representatives.push(newRep);
    }

    function removeRep(address addr) public {
        require(msg.sender == manager);
        for (uint i = 0; i < representatives.length; i++) 
        {
            if (representatives[i].rep == addr) {
                delete representatives[i];
            }
        }
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
        isApproved(addr);
    }

    function isApproved(address addr) public {
        if (requests[addr].approvers >= representatives.length / 2) {
            requests[addr].approved = true;
            for (uint256 i = 0; i < requests[addr].requestedList.length; i++) {
                marketplaceItems.push(requests[addr].requestedList[i]);
            }
        }
    }

    function itemToString(item memory currItem)
        public
        pure
        returns (string memory)
    {
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

    function publishMarket() public view returns (string memory) {
        string memory mktplace;
        for (uint256 j = 0; j < marketplaceItems.length; j++) {
            
            mktplace = string.concat(
                mktplace,
                "\n----------------------------------\n",
                itemToString(marketplaceItems[j])
            );
        }
        return mktplace;
    }

    function removeFromMarketplace(
        uint256 id,
        uint256 qty,
        uint256 flag
    ) public returns (uint256) {
        require(isRep(msg.sender));
        require(
            flag == 0 || flag == 1 || flag == 2,
            "Must choose a valid flag bit number (0, 1, or 2)!"
        );
        for (uint256 i = 0; i < marketplaceItems.length; i++) {
            if (marketplaceItems[i].id == id) {
                require(
                    qty <= marketplaceItems[i].quant,
                    string.concat(
                        "Invalid quantity, current stock is: ",
                        Strings.toString(marketplaceItems[i].quant),
                        "!"
                    )
                );
                if (qty == marketplaceItems[i].quant) {
                    delete marketplaceItems[i];
                }
                marketplaceItems[i].quant -= qty;
            }
        }
        //0 flag for purchased item
        //1 flag for stolen item
        //2 flag for destroyed item
        return flag;
    }

    function changeMarketPrice(uint256 id, uint256 newPrice) public {
        require(isRep(msg.sender));
        require(newPrice > 0, "Price cannot be 0!");
        for (uint256 i = 0; i < marketplaceItems.length; i++) {
            if (marketplaceItems[i].id == id) {
                marketplaceItems[i].price = newPrice;
            }
        }
    }
}
