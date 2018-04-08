pragma solidity ^0.4.17;


contract TaxCracker {
    mapping (bytes32 => uint8) public votesReceived;
    bytes32[] public optionsList;
    address ownerAccount;
    uint256 tokenOwnerId;
    bytes32 ownerName;

    function TaxCracker(bytes32[] options, uint256 ownerId, bytes32 _ownerName) public {
        optionsList = options;
        tokenOwnerId = ownerId;
        ownerName = _ownerName;
        ownerAccount = msg.sender;
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

    function getTokenOwner() view public returns(bytes32 name) {
        return ownerName;
    }

    function transfer(address _to, uint256 _tokenId, bytes32 _name) public {
        ownerAccount = _to;
        tokenOwnerId = _tokenId;
        ownerName = _name;
    }

    function verifyOwner() view public returns(bool) {
        if (ownerAccount == msg.sender) {
            return true;
        } else {
            return false;
        }
    }
}
