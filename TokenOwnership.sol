pragma solidity ^0.4.17;

import "./TaxCracker.sol";
import "./erc721.sol";

contract TokenOwnership is TaxCracker, ERC721 {

    mapping (uint => address) tokenApprovals;

    modifier onlyOwnerOf(uint _tokenId) {
        require(msg.sender == tokenToOwner[_tokenId]);
        _;
    }
  
    // // check total tokens per citizen
    // function balanceOf(address _citizen) public view returns (uint256 _balance) {
    //     return citizenTokenCount[_citizen];
    // }

    // check citizen who owns of token
    function ownerOf(uint256 _tokenId) public view returns (address _citizen) {
        return tokenToCitizen[_tokenId];
    }

    // reusable function to transfer tokens between citizens using transfer event
    function _transfer(address _from, address _to, uint256 _tokenId) private {
        citizenTokenCount[_to] = citizenTokenCount[_to].add(1);
        citizenTokenCount[_from] = citizenTokenCount[_from].sub(1);
        tokenToCitizen[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);
    }

    // allows citizen to transfer token
    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    // prepares token for transfer and waits for new citizen to take ownership
    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        tokenApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }

    // allows approved user to take ownership of token
    function takeOwnership(uint256 _tokenId) public {
        require(tokenApprovals[_tokenId] == msg.sender);
        address citizen = ownerOf(_tokenId);
        _transfer(citizen, msg.sender, _tokenId);
    }
    
}