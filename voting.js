web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
abi = JSON.parse('[{"constant":true,"inputs":[{"name":"option","type":"bytes32"}],"name":"validOption","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"option","type":"bytes32"}],"name":"voteForOption","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"option","type":"bytes32"}],"name":"totalVotesFor","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"optionsList","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"votesReceived","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"options","type":"bytes32[]"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]')


VotingContract = web3.eth.contract(abi);
// In your nodejs console, execute contractInstance.address to get the address at which the contract is deployed and change the line below to use your deployed address
contractInstance = VotingContract.at('0xcff6ce3091aee5c0247a80e11d197540a0ee4177');
options = {"Renewables": "option-1", "Pension": "option-2", "Education": "option-3"}

function voteForOption() {
  optionName = $('input[name=issues]:checked').val();
  console.log(optionName);
  contractInstance.voteForOption(optionName, {from: web3.eth.accounts[0]}, function() {
    let div_id = options[optionName];
    $("#" + div_id).html(contractInstance.totalVotesFor.call(optionName).toString());
  });
}

$(document).ready(function() {
  optionNames = Object.keys(options);
  for (var i = 0; i < optionNames.length; i++) {
    let option = optionNames[i];
    let val = contractInstance.totalVotesFor.call(option).toString()
    $("#" + options[option]).html(val);
  }
});
