const assert = require("assert");
const chai = require("chai");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());
const { abi, bytecode } = require('../compile')

let accounts;
let user;
beforeEach(async () =>{
