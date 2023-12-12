const assert = require("assert");
const chai = require("chai");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());
const { abi, bytecode } = require('../compile')

let accounts;
let user;
beforeEach(async () =>{
  accounts = await web3.eth.getAccounts();
  user = await new web3.eth.Contract(abi}.deploy({data: bytecode}).send({from: accounts[0], gasPrice: 8000000000, gas: 4700000});
});

describe("Market Place", () =>{
  //deploy test contract
  it("deploy test", () =>{
    assert.ok(user.option.address);
  });
//------------------------------------------------------------------------------------------------------------------------------------
  //add item test
  //add item
  it("Add Item", async() =>{
    await user.methods.addItem(1, "123 new street", "john", 5, 2).send({from:accounts[0], gasPrice:8000000000, gas: 4700000});
    assert.equal(await user.methods.itemList(0).call(), accounts[0]);
  }
});
