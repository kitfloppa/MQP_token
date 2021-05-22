pragma solidity ^0.5.7;

import "./ERC20Standard.sol";

contract MQPToken is ERC20Standard {
	constructor() public {
		_totalSupply = 1000000;
		_name = "MQP coin";
		_decimals = 8;
		_symbol = "MQP";
		version = "1.0";
		minter = msg.sender;
		balances[msg.sender] = _totalSupply;
	}
}
