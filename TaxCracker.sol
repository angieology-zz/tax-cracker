pragma solidity ^0.4.17;

contract TaxCracker {
    mapping (bytes32 => uint8) public votesReceived;
    
    bytes32[] public optionsList;
    bytes32[] internal tokensList;

    function TaxCracker(bytes32[] options, bytes32[] tokens) public {
        optionsList = options;
        tokensList = tokens;
    }

    function totalVotesFor(bytes32 option) view public returns (uint8) {
        require(validOption(option));
        return votesReceived[option];
    }

    function voteForOption(bytes32 option, bytes32 token) public {
        require(validOption(option));
        require(validToken(token));
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

    function validToken(bytes32 token) view internal returns (bool) {
        for (uint i = 0; i < tokensList.length; i++) {
            if (tokensList[i] == token) {
                return true;
            }
        }
    }
}