pragma solidity ^0.8.13;

import "./ERC20.sol";


contract ubst is IERC20 {
    uint public totalSupply = 90000000;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Token";
    string public symbol = "TKN";
    uint8 public decimals = 5;
    bool public isInitialized = false;
    uint public increaseFee = 9000000000000000;
    uint extendNo = 0;

    
    function initialize() external returns (bool) {
        require(msg.sender == 0x00, "Only Admin can initialize this token!!");
        require(!isInitialized, "token already initialized!!");
        uint equalSupply = totalSupply / 3;
        balanceOf[0x00] = equalSupply;
        balanceOf[0x00] = equalSupply;
        balanceOf[0x00] = equalSupply;
        isInitialized = true;
        return true;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        // handles uint overflow
        // require(balanceOf[msg.sender] >= amount, "The balance must be more than transfer amount");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        // handles uint overflow
        // require(balanceOf[msg.sender] >= amount, "The balance must be more than transfer amount");
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function balanceOfAccount(address _account) public view returns (uint) {
        return balanceOf[_account];
    }

    function extendSupply() public payable {
        require(msg.sender == 0x00, "Only Admin can extend supply!!");
        require(msg.value == increaseFee, "The amount must be equal to the increase fee (0.009ETH)");
        balanceOf[msg.sender] += 10000000;
        totalSupply += 10000000;
        extendNo += 1;
    }

    function reduceSupply() public payable {
        require(msg.sender == 0x00, "Only Admin can reduce supply!!");
        require(balanceOf[msg.sender] >= 10000000, "The balance must be >= 100");
        require(extendNo >= 1, "Supply has to be increased first!");
        (bool sent, bytes memory data) = payable(msg.sender).call{value: 7000000000000000}("");
        require(sent, "Failed to reduce the deposit!");
        balanceOf[msg.sender] -= 10000000;
        totalSupply -= 10000000;
        extendNo -= 1;
    }

}

