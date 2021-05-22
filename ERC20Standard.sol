pragma solidity ^0.5.7;

interface ERC20 {
  function name() external  view returns (string memory);
  function symbol() external  view returns (string memory);
  function decimals() external  view returns (uint8);
  function totalSupply() external  view returns (uint256);
  function balanceOf(address _owner) external  view returns (uint256 balance);
  function transfer(address _to, uint256 _value) external  returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) external  returns (bool success);
  function approve(address _spender, uint256 _value) external  returns (bool success);
  function allowance(address _owner, address _spender) external  view returns (uint256 remaining);
  function mint(address account, uint256 amount) external;
  function burn(uint256 amount) external;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        
	    return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract ERC20Standard is ERC20 {
	using SafeMath for uint256;
	
	uint256 public _totalSupply;
	string public _name;
	uint8 public _decimals;
	string public _symbol;
	string public version;
	
	address public minter;
	mapping (address => uint256) balances;
	mapping (address => mapping (address => uint)) allowed;

    modifier onlyPayloadSize(uint size) {
		assert(msg.data.length == size + 4);
		_;
	} 

    function name() public view returns (string memory) {
        return _name;
    }
    
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
	
	function balanceOf(address _owner) public view returns (uint256 balance) {
		return balances[_owner];
	}

	function transfer(address _to, uint256 _value) public returns (bool success) {
	    require(balances[msg.sender] >= _value && _value > 0);
	    balances[msg.sender] = balances[msg.sender].sub(_value);
	    balances[_to] = balances[_to].add(_value);
	    emit Transfer(msg.sender, _to, _value);
	    return true;
    }

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
	    require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

	function  approve(address _spender, uint256 _value) public returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
		return allowed[_owner][_spender];
	}
	
	function mint(address account, uint256 amount) public {
	    require(msg.sender == minter && amount != 0);
        _totalSupply.add(amount);
        balances[account].add(amount);
        emit Transfer(address(0), account, amount);
	}
	
	function burn(uint256 amount) public {
	    require(amount != 0 && amount <= balances[minter]);
        _totalSupply = _totalSupply.sub(amount);
        balances[minter] = balances[minter].sub(amount);
        emit Transfer(minter, address(0), amount);
	}
}
