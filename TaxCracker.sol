pragma solidity ^0.4.17;


contract TaxCracker {
    mapping (bytes32 => uint8) public votesReceived;
    mapping(bytes32 => address) internal optionsAccounts;
    bytes32[] public optionsList;
    address funder;
    uint fund;

    address ownerAccount;
    uint256 voteTokenOwnerId;
    bytes32 ownerName;

    function TaxCracker(bytes32[] options, address[] toAccounts, uint256 ownerId, bytes32 _ownerName) public payable {
        optionsList = options;
        for (uint i = 0; i < optionsList.length; i++) {
            optionsAccounts[optionsList[i]] = toAccounts[i];
        }
        voteTokenOwnerId = ownerId;
        ownerName = _ownerName;
        ownerAccount = msg.sender;
    }

    function fundContract() public payable {
        msg.sender.transfer(msg.value);
    }
    
    function getContractBalance() public constant returns (uint){
        return msg.value;    
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

    function calculateWinner() view public returns(uint winningOptionIndex) {
        uint highestVote = 0;
        uint highestVotedOptionIndex = 0;
        for (uint i = 0; i < optionsList.length; i++) {
            if (votesReceived[optionsList[i]] >= highestVote) {
                highestVotedOptionIndex = i;
                highestVote = votesReceived[optionsList[i]];
            }
        }
        return highestVotedOptionIndex;
    }

    function transferFunds(uint winningOptionIndex) public returns(uint) {
        bytes32 winningOption = optionsList[winningOptionIndex];
        address winningOptionAccount = optionsAccounts[winningOption];
        winningOptionAccount.transfer(msg.value);
        return msg.value;
    }

    function getVoteTokenOwner() view public returns(bytes32 name) {
        return ownerName;
    }

    function transferVoteToken(address _to, uint256 _tokenId, bytes32 _name) public {
        ownerAccount = _to;
        voteTokenOwnerId = _tokenId;
        ownerName = _name;
    }

    function verifyVoteTokenOwner() view public returns(bool) {
        if (ownerAccount == msg.sender) {
            return true;
        } else {
            return false;
        }
    }
}
