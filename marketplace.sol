// SPDX-License-Identifier: GPL-3.0
// Uriel Roque
pragma solidity ^0.8.17;

contract marketplace {
    address public manager;

    constructor() {
        manager = msg.sender;
    }
}