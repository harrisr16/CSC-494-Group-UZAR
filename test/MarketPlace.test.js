const assert = require("assert");
const chai = require("chai");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());
const { abi, bytecode } = require('../compile');
const { error } = require("console");

let accounts;
let user;
beforeEach(async () =>{
  accounts = await web3.eth.getAccounts();
  user = await new web3.eth.Contract(abi).deploy({data: bytecode}).send({from: accounts[0], gasPrice: 8000000000, gas: 4700000});
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
  });
  //check to make sure representive is not using the function
  if("add item with representative", async() =>{
    try {
      await user.methods.addItem(1, "123 new street", "john", 5, 2).send({from:accounts[1]});
      assert.fail("this should produce an error");
    } catch (error) {
      chai.assert.toString(error.message, "only the manager can use this function");
    }
  });
  //----------------------------------------------------------------------------------------------------------------------------------
  //addRep test
  //addRep
  it("add rep", async() => {
    await user.methods.addRep('0x5B38Da6a701c568545dCfcB03FcB875f56beddC4', "324 prez drive").send({from: accounts[0], gasPrice: 8000000000, gas:4700000});
    assert.equal(await user.methods.representatives(0).call(), accounts[0]);
  });
  //check to see if the manager is using the function and not the representative
  it("add rep", async() => {
    try{
    await user.methods.addRep('0x5B38Da6a701c568545dCfcB03FcB875f56beddC4', "324 prez drive").send({from: accounts[1], gasPrice: 8000000000, gas:4700000});
    assert.fail("this should produce an error");
    }catch(error){
      chai.assert.include(error.message, "only the manager can use the function");
    }
  });
  // check if location is a size zero
  it("add rep", async() => {
    try{
    await user.methods.addRep('0x5B38Da6a701c568545dCfcB03FcB875f56beddC4', "").send({from: accounts[0], gasPrice: 8000000000, gas:4700000});
    assert.fail("this should produce an error");
    }catch(error){
      chai.assert.include(error.message, "there must be a location");
    }
  });
  //--------------------------------------------------------------------------------------------------------------------------------
  //removeRep test
  //removeRep
  it("remove rep", async() => {
    await user.methods.removeRep('0x5B38Da6a701c568545dCfcB03FcB875f56beddC4').send({from: accounts[0], gasPrice: 8000000000, gas:4700000});
    assert.fail(await user.methods.representatives(0).call(), accounts[0]);
  });
  //check to see if the manager is using the function and not the representative
  it("remove rep", async() => {
    try{
    await user.methods.addRep('0x5B38Da6a701c568545dCfcB03FcB875f56beddC4').send({from: accounts[1], gasPrice: 8000000000, gas:4700000});
    assert.fail("this should produce an error");
    }catch(error){
      chai.assert.include(error.message, "only the manager can use the function");
    }
  });
  //---------------------------------------------------------------------------------------------------------------------------------
  //publishItems test
  //publishItems
  it("publish Items", async()=>{
    await user.methods.publishItems().send({from: accounts[0], gasPrice:8000000000, gas: 4700000});
  });
  it("publish Items", async()=>{
    try {
        await user.methods.publishItems().send({from: accounts[1], gasPrice:8000000000, gas: 4700000});
    } catch (error) {
      chai.assert.include(error.message, "only the manager can use the function");
    }
  
  });

});
