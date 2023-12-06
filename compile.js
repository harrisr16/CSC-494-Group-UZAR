const path = require('path');
const fs = require('fs');
const solc = require('solc');

const marketplacePath = path.resolve(__dirname, 'contracts', 'Marketplace.sol');
const source = fs.readFileSync(marketplacePath, 'utf8');
//console.log(source);

let input = {
    language: "Solidity",
    sources: {
        "Marketplace.sol": {
            content: source,
        },
    },
    settings: {
        outputSelection: {
            "*": {
                "*": ["abi", "evm.bytecode"],
            },
        },
    },
};
//console.log(JSON.stringify(input))
//console.log(solc.compile(JSON.stringify(input)));
const output = JSON.parse(solc.compile(JSON.stringify(input)));
console.log(output);
//console.log(output.contracts["Marketplace.sol"].Marketplace);
const contracts = output.contracts["Marketplace.sol"];
const contract = contracts['Marketplace'];
console.log(contract);
console.log("------------------------------------------");
console.log(JSON.stringify(contract.abi));
module.exports = { "abi": contract.abi, "bytecode": contract.evm.bytecode.object };