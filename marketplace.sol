// SPDX-License-Identifier: GPL-3.0
//this is uriel roque
pragma solidity ^0.8.17;

contract marketplace {
    address public manager;

    constructor() {
        manager = msg.sender;
    }
}