// SPDX-License-Identifier: GPL-3.0
// Uriel Roque
// Randy Harris
pragma solidity ^0.8.17;

contract marketplace {
    address public manager;

    constructor() {
        manager = msg.sender;
    }
}