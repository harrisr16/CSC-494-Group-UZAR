import './App.css';
import React from 'react';
import web3 from './web3';
import marketplace from './marketplace';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      manager: '',
      //PUBLISH TO MARKETPLACE VARS
      currInventory: '',
      //REQUEST ITEM VARS
      requestedIDS: '',
      //APPROVE REQUEST VARS
      approvedAddress: '',
      //CHANGE ITEM PRICE VARS
      changedID: 0,
      changedPrice: 0,
      //REMOVE ITEM VARS
      removedID: 0,
      removedQty: 0,
      //ADD ITEM VARS
      newID: 0,
      newName: '',
      newLocation: '',
      newQty: 0,
      newPrice: 0,
      //ADD REPRESENTATIVE VARS
      newRep: '',
      newRepLocation: '',
      //REMOVE REPRESENTATIVE VARS
      removedRep: '',
    };
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  async componentDidMount() {
    const addr = await web3.currentProvider.selectedAddress;
    const manager = await marketplace.methods.manager().call();
    var currInventory = "No products!";
    // if (await marketplace.methods.marketplaceItems(0).call() != null) {
    //   currInventory = await marketplace.methods.marketplaceItems(0).call().toString();
    // }
    this.setState({ manager, addr, currInventory });
  }

  handleChange(event) {
    this.setState({
      [event.target.name]: event.target.value
    });
  }

  checkList() {
    const pList = document.querySelector('#productLabel');
    if (pList.style.visibility === 'hidden') {
      console.log("List button clicked!");
      pList.style.visibility = 'visible';
    } else {
      pList.style.visibility = 'hidden';
    }
  }

  handleSubmit = async (event) => {
    const addr = await web3.currentProvider.selectedAddress;
    const buttontype = window.event.submitter.name;
    const { requestedIDS, approvedAddress, changedID, changedPrice, removedID, removedQty, newID, newName, newLocation, newPrice, newQty, newRep, newRepLocation, removedRep } = this.state;
    if (buttontype === "addItem") {
      event.preventDefault();
      marketplace.methods.addItem(newID, newName, newLocation, newPrice, newQty).send({
        from: this.state.manager,
      });
      alert(`
       Item No. ${newID} added successfully!
     `);
    }
    else if (buttontype === "addRep") {
      event.preventDefault();
      marketplace.methods.addRep(newRep, newRepLocation).send({
        from: this.state.manager,
      });
      alert(`
       Representative at address ${newRep} added successfully!
     `);
    }
    else if (buttontype === "removeRep") {
      event.preventDefault();
      marketplace.methods.addRep(removedRep).send({
        from: this.state.manager,
      });
      alert(`
       Representative at address ${removedRep} removed successfully!
     `);
    }
    else if (buttontype === "publishItems") {
      event.preventDefault();
      marketplace.methods.publishItems().send({
        from: this.state.manager,
      });
      alert(`
       Item publish processing...
     `);
    }
    else if (buttontype === "requestItem") {
      event.preventDefault();
      var reqItemList = requestedIDS.split(',').map(function (itemID) {
        return parseInt(itemID, 10);
      });
      marketplace.methods.requestItem(reqItemList).send({
        from: addr,
      });
      alert(`
       Item request processing...
     `);
    }
    else if (buttontype === "approveRequest") {
      event.preventDefault();
      marketplace.methods.approveRequest(approvedAddress).send({
        from: addr,
      });
      alert(`
       Item approval processing...
     `);
    }
    else if (buttontype === "publishToMarket") {
      event.preventDefault();
      marketplace.methods.publishMarket().send({
        from: addr,
      });
      alert(`
       Item approval processing...
     `);
    }
    else if (buttontype === "changeMarketPrice") {
      event.preventDefault();
      marketplace.methods.changeMarketPrice(changedID, changedPrice).send({
        from: addr,
      });
      alert(`
       Item price change processing...
     `);
    }
    else if (buttontype === "removeFromMarketplace") {
      event.preventDefault();
      marketplace.methods.removeFromMarketplace(removedID, removedQty).send({
        from: addr,
      });
      alert(`
       Item removal processing...
     `);
    }
  }

  render() {
    return (
      <div className="Marketplace">
        <p>
          This is a Marketplace Site owned by {this.state.manager}.<br></br>
        </p>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gridGap: 20 }}>
          <div><form onSubmit={this.handleSubmit}>
            <h4>Add an Item</h4><h6>Manager Only</h6>
            <div>
              <label>Enter Item ID: </label><br></br>
              <input
                placeholder='Item ID'
                name='newID'
                onChange={this.handleChange}
              />
            </div>
            <div>
              <label>Enter Item Name: </label><br></br>
              <input
                placeholder='Item Name'
                name='newName'
                onChange={this.handleChange}
              />
            </div>
            <div>
              <label>Enter Item Location: </label><br></br>
              <input
                placeholder='Item Location'
                name='newLocation'
                onChange={this.handleChange}
              />
            </div>
            <div>
              <label>Enter Item Price: </label><br></br>
              <input
                placeholder='Item Price'
                name='newPrice'
                onChange={this.handleChange}
              />
            </div>
            <div>
              <label>Enter Item Quantity: </label><br></br>
              <input
                placeholder='Item Quantity'
                name='newQty'
                onChange={this.handleChange}
              />
            </div>
            <div>
              <button name="addItem">Add Item</button>
            </div>
          </form>
            <form onSubmit={this.handleSubmit}>
              <h4>Add a Representative</h4><h6>Manager Only</h6>
              <div>
                <label>Enter address of representative: </label><br></br>
                <input
                  placeholder='Representative Address'
                  name='newRep'
                  onChange={this.handleChange}
                />
              </div>
              <div>
                <label>Enter location of representative: </label><br></br>
                <input
                  placeholder='Representative Location'
                  name='newRepLocation'
                  onChange={this.handleChange}
                />
              </div>
              <div>
                <button name="addRep">Add Representative</button>
              </div>
            </form>
            <form onSubmit={this.handleSubmit}>
              <h4>Remove a Representative</h4><h6>Manager Only</h6>
              <div>
                <label>Enter address of representative: </label><br></br>
                <input
                  placeholder='Representative Address'
                  name='newRep'
                  onChange={this.handleChange}
                />
              </div>
              <div>
                <button name="removeRep">Remove Representative</button>
              </div>
            </form>
            <form onSubmit={this.handleSubmit}>
              <h4>Publish Items to Collection</h4><h6>Manager Only</h6>
              <div>
                <button name="publishItems">Publish Current Items</button>
              </div>
            </form></div>
          <div>
            <form onSubmit={this.handleSubmit}>
              <h4>Request Items</h4><h6>Representatives Only</h6>
              <div>
                <label>Enter list of items: </label><br></br>
                <input
                  placeholder='List of items in form of: 1,2,3'
                  name='requestedIDS'
                  onChange={this.handleChange}
                />
              </div>
              <div>
                <button name="requestItem">Request Items</button>
              </div>
            </form>
            <form onSubmit={this.handleSubmit}>
              <h4>Approve Item Request</h4><h6>Representatives Only</h6>
              <div>
                <label>Enter address of requester: </label><br></br>
                <input
                  placeholder='Requester Address'
                  name='approvedAddress'
                  onChange={this.handleChange}
                />
              </div>
              <div>
                <button name="approveRequest">Approve Request</button>
              </div>
            </form>
            <form onSubmit={this.handleSubmit}>
              <h4>Publish Items to Marketplace</h4><h6>Representatives Only</h6>
              <div>
                <button name="publishToMarket">Publish Current Items</button>
              </div>
            </form>
            <form onSubmit={this.handleSubmit}>
              <h4>Change Market Price</h4><h6>Representatives Only</h6>
              <div>
                <label>Enter ID of Item: </label><br></br>
                <input
                  placeholder='Item ID'
                  name='changedID'
                  onChange={this.handleChange}
                />
              </div>
              <div>
                <label>Enter New Price of Item: </label><br></br>
                <input
                  placeholder='New Item Price'
                  name='changedPrice'
                  onChange={this.handleChange}
                />
              </div>
              <div>
                <button name="changeMarketPrice">Change Market Price</button>
              </div>
            </form>
            <form onSubmit={this.handleSubmit}>
              <h4>Remove from Marketplace</h4><h6>Representatives Only</h6>
              <div>
                <label>Enter ID of Item: </label><br></br>
                <input
                  placeholder='Item ID'
                  name='removedID'
                  onChange={this.handleChange}
                />
              </div>
              <div>
                <label>Enter Quantity to Remove: </label><br></br>
                <input
                  placeholder='Item Quantity to Remove'
                  name='removedQty'
                  onChange={this.handleChange}
                />
              </div>
              <div>
                <button name="removeFromMarketplace">Remove From Marketplace</button>
              </div>
            </form>
          </div>
          <div>
            <h4>Show All Items Available</h4><h6>All Users</h6>
            <div>
              <button onClick={this.checkList} name="publishMarket">Show Items</button>
            </div>
            <div id='productLabel' style={{ visibility: 'hidden' }}>
              <h5>Current Products:</h5><br></br>
              <p>{this.state.currInventory}</p>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
