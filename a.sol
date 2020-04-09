pragma solidity ^0.4.18;

contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

contract DonateContract {

    struct Donation {
        uint tokens;
        string donor;
    }
    mapping (address => Donation[]) history;
    event NewDonation(uint tokens, string donor, string message, address raddr);

    function donate(address _receiver, string _name, string _message, address tokenAddress) public payable {
        
        ERC20Interface ERC20Contract = ERC20Interface(tokenAddress);
        uint tokens = ERC20Contract.balanceOf(this);
        require(tokens >= 0); 
        history[_receiver].push(Donation(tokens, _name));
        NewDonation(tokens, _name, _message, _receiver);
        ERC20Interface(tokenAddress).transfer(_receiver, tokens);
        
    }

    function getDonation(address _addr, uint _id) public view returns(uint value, string name) {
        require(_id >= 0 && _id < history[_addr].length);
        return(history[_addr][_id].tokens, history[_addr][_id].donor);
    }

    function getDonationsCount(address _addr) public view returns(uint length) {
        return(history[_addr].length);
    }


}

