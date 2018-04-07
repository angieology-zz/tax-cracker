pragma solidity ^0.4.17;

contract TaxCracker {
    mapping (bytes32 => uint8) public votesReceived;
    
    bytes32[] public optionsList;

    function TaxCracker(bytes32[] options) public {
        optionsList = options;
    }

    function totalVotesFor(bytes32 option) view public returns (uint8) {
        require(validOption(option));
        return votesReceived[option];
    }

    function voteForOption(bytes32 option) public {
        require(validOption(option));
        votesReceived[option] += 1;
    }

    function validOption(bytes32 option) view public returns (bool) {
        for (uint i = 0; i < optionsList.length; i++) {
            if (optionsList[i] == option) {
                return true;
            }
        }
        return false;
    }
}