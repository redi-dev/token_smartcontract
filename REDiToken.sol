
pragma solidity ^0.5.2;

import "./IERC20.sol";
import "./SafeMath.sol";

contract REDiToken is IERC20 {

    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    string public name = "REDiToken";
    string public symbol = "REDi";
    uint8 public decimals = 18;
    uint256 private _totalSupply = 10000000000 * 10 ** uint256(decimals);

    constructor() public {
      _balances[msg.sender] = _totalSupply;
    }

    function totalSupply() public view returns (uint256) {
      return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
      return _balances[owner];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
      return _allowed[owner][spender];
    }

    function transfer(address to, uint256 value) public returns (bool) {
      _transfer(msg.sender, to, value);
      return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
      _approve(msg.sender, spender, value);
      return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
      _transfer(from, to, value);
      _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
      return true;
    }

    function burn(uint256 value) public {
      _burn(msg.sender, value);
    }

    function burnFrom(address from, uint256 value) public {
      _burnFrom(from, value);
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
      _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
      return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
      _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
      return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
      require(to != address(0));

      _balances[from] = _balances[from].sub(value);
      _balances[to] = _balances[to].add(value);
      emit Transfer(from, to, value);
    }

    function _burn(address account, uint256 value) internal {
      require(account != address(0));

      _totalSupply = _totalSupply.sub(value);
      _balances[account] = _balances[account].sub(value);
      emit Transfer(account, address(0), value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
      require(spender != address(0));
      require(owner != address(0));

      _allowed[owner][spender] = value;
      emit Approval(owner, spender, value);
    }

    function _burnFrom(address account, uint256 value) internal {
      _burn(account, value);
      _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
    }
}
