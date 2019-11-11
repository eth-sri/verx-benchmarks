pragma solidity ^0.4.24;




/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract ERC20 is IERC20 {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;

  uint256 private _totalSupply;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param owner The address to query the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param owner address The address which owns the funds.
   * @param spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address owner,
    address spender
   )
    public
    view
    returns (uint256)
  {
    return _allowed[owner][spender];
  }

  /**
  * @dev Transfer token for a specified address
  * @param to The address to transfer to.
  * @param value The amount to be transferred.
  */
  function transfer(address to, uint256 value) public returns (bool) {
    _transfer(msg.sender, to, value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param spender The address which will spend the funds.
   * @param value The amount of tokens to be spent.
   */
  function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param from address The address which you want to send tokens from
   * @param to address The address which you want to transfer to
   * @param value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address from,
    address to,
    uint256 value
  )
    public
    returns (bool)
  {
    require(value <= _allowed[from][msg.sender]);

    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    _transfer(from, to, value);
    return true;
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param spender The address which will spend the funds.
   * @param addedValue The amount of tokens to increase the allowance by.
   */
  function increaseAllowance(
    address spender,
    uint256 addedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].add(addedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param spender The address which will spend the funds.
   * @param subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].sub(subtractedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  /**
  * @dev Transfer token for a specified addresses
  * @param from The address to transfer from.
  * @param to The address to transfer to.
  * @param value The amount to be transferred.
  */
  function _transfer(address from, address to, uint256 value) internal {
    require(value <= _balances[from]);
    require(to != address(0));

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);
    emit Transfer(from, to, value);
  }

  /**
   * @dev Internal function that mints an amount of the token and assigns it to
   * an account. This encapsulates the modification of balances such that the
   * proper events are emitted.
   * @param account The account that will receive the created tokens.
   * @param value The amount that will be created.
   */
  function _mint(address account, uint256 value) internal {
    require(account != 0);
    _totalSupply = _totalSupply.add(value);
    _balances[account] = _balances[account].add(value);
    emit Transfer(address(0), account, value);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account.
   * @param account The account whose tokens will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burn(address account, uint256 value) internal {
    require(account != 0);
    require(value <= _balances[account]);

    _totalSupply = _totalSupply.sub(value);
    _balances[account] = _balances[account].sub(value);
    emit Transfer(account, address(0), value);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account, deducting from the sender's allowance for said account. Uses the
   * internal burn function.
   * @param account The account whose tokens will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burnFrom(address account, uint256 value) internal {
    require(value <= _allowed[account][msg.sender]);

    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
    // this function needs to emit an event with the updated approval.
    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
      value);
    _burn(account, value);
  }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
  }

  /**
   * @return the address of the owner.
   */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true if `msg.sender` is the owner of the contract.
   */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

/** 
 * @title Contracts that should not own Tokens
 * @author Remco Bloemen <remco@2π.com>
 * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
 * Should tokens (any IERC20 compatible) end up in the contract, it allows the
 * owner to reclaim the tokens.
 */
contract HasNoTokens is Ownable {

 /** 
  * @dev Reject all ERC23 compatible tokens
  */
  function tokenFallback(address /* from_ */, uint256 /* value_ */, bytes /* data_ */) external pure {
    revert();
  }

  /**
   * @dev Reclaim all IERC20 compatible tokens
   * @param tokenAddr address The address of the token contract
   */
  function reclaimToken(address tokenAddr) external onlyOwner {
    IERC20 tokenInst = IERC20(tokenAddr);
    address _owner = owner();
    uint256 balance = tokenInst.balanceOf(this);
    tokenInst.transfer(_owner, balance);
  }
}

/*
The MIT License (MIT)

Copyright (c) 2016 Smart Contract Solutions, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/



/** 
 * @title Contracts that should not own Contracts
 * @author Remco Bloemen <remco@2π.com>
 * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
 * of this contract to reclaim ownership of the contracts.
 */
contract HasNoContracts is Ownable {

  /**
   * @dev Reclaim ownership of Ownable contracts
   * @param contractAddr The address of the Ownable to be reclaimed.
   */
  function reclaimContract(address contractAddr) external onlyOwner {
    Ownable contractInst = Ownable(contractAddr);
    contractInst.transferOwnership(owner());
  }
}

/*
The MIT License (MIT)

Copyright (c) 2016 Smart Contract Solutions, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/




/**
 * MRV token, distributed by crowdsale. Token and crowdsale functionality are unified in a single
 * contract, to make clear and restrict the conditions under which tokens can be created or destroyed.
 * Derived from OpenZeppelin CrowdsaleToken template.
 *
 * Key Crowdsale Facts:
 * 
 * * MRV tokens will be sold at a rate of 5,000 per ETH.
 *
 * * All MRV token sales are final. No refunds can be issued by the contract.
 *
 * * Unless adjusted later by the crowdsale operator, up to 100 million tokens will be available.
 *
 * * An additional 5,000 tokens are reserved. 
 *
 * * Participate in the crowdsale by sending ETH to this contract, when the crowdsale is open.
 *
 * * Sending more ETH than required to purchase all the remaining tokens will fail.
 *
 * * Timers can be set to allow anyone to open/close the crowdsale at the proper time. The crowdsale
 *   operator reserves the right to set, unset, and reset these timers at any time, for any reason,
 *   and without notice.
 *
 * * The operator of the crowdsale has the ability to manually open it and close it, and reserves
 *   the right to do so at any time, for any reason, and without notice.
 *
 * * The crowdsale cannot be reopened, and no tokens can be created, after the crowdsale closes.
 *
 * * The crowdsale operator reserves the right to adjust the decimal places of the MRV token at
 *   any time after the crowdsale closes, for any reason, and without notice. MRV tokens are
 *   initially divisible to 18 decimal places.
 *
 * * The crowdsale operator reserves the right to not open or close the crowdsale, not set the
 *   open or close timer, and generally refrain from doing things that the contract would otherwise
 *   authorize them to do.
 *
 * * The crowdsale operator reserves the right to claim and keep any ETH or tokens that end up in
 *   the contract's account. During normal crowdsale operation, ETH is not stored in the contract's
 *   account, and is instead sent directly to the beneficiary.
 */
contract MRVToken is ERC20, Ownable, HasNoTokens, HasNoContracts {

    // Token Parameters

    // From StandardToken we inherit balances and totalSupply.
    
    // What is the full name of the token?
    string public constant name = "Macroverse Token";
    // What is its suggested symbol?
    string public constant symbol = "MRV";
    // How many of the low base-10 digits are to the right of the decimal point?
    // Note that this is not constant! After the crowdsale, the contract owner can
    // adjust the decimal places, allowing for 10-to-1 splits and merges.
    uint8 public decimals;
    
    // Crowdsale Parameters
    
    // Where will funds collected during the crowdsale be sent?
    address beneficiary;
    // How many MRV can be sold in the crowdsale?
    uint public maxCrowdsaleSupplyInWholeTokens;
    // How many whole tokens are reserved for the beneficiary?
    uint public constant wholeTokensReserved = 5000;
    // How many tokens per ETH during the crowdsale?
    uint public constant wholeTokensPerEth = 5000;
    
    // Set to true when the crowdsale starts
    // Internal flag. Use isCrowdsaleActive instead().
    bool crowdsaleStarted;
    // Set to true when the crowdsale ends
    // Internal flag. Use isCrowdsaleActive instead().
    bool crowdsaleEnded;
    // We can also set some timers to open and close the crowdsale. 0 = timer is not set.
    // After this time, the crowdsale will open with a call to checkOpenTimer().
    uint public openTimer = 0;
    // After this time, no contributions will be accepted, and the crowdsale will close with a call to checkCloseTimer().
    uint public closeTimer = 0;
    
    ////////////
    // Constructor
    ////////////
    
    /**
    * Deploy a new MRVToken contract, paying crowdsale proceeds to the given address,
    * and awarding reserved tokens to the other given address.
    */
    constructor(address sendProceedsTo, address sendTokensTo) public {
        // Proceeds of the crowdsale go here.
        beneficiary = sendProceedsTo;
        
        // Start with 18 decimals, same as ETH
        decimals = 18;
        
        // Initially, the reserved tokens belong to the given address.
        // TODO: This change for OZ 2.0 compatibility causes the code to differ from the behavior of the mainnet deployed contract!
        _mint(sendTokensTo, wholeTokensReserved * 10 ** 18);
        
        // Initially the crowdsale has not yet started or ended.
        crowdsaleStarted = false;
        crowdsaleEnded = false;
        // Default to a max supply of 100 million tokens available.
        maxCrowdsaleSupplyInWholeTokens = 100000000;
    }
    
    ////////////
    // Fallback function
    ////////////
    
    /**
    * This is the MAIN CROWDSALE ENTRY POINT. You participate in the crowdsale by 
    * sending ETH to this contract. That calls this function, which credits tokens
    * to the address or contract that sent the ETH.
    *
    * Since MRV tokens are sold at a rate of more than one per ether, and since
    * they, like ETH, have 18 decimal places (at the time of sale), any fractional
    * amount of ETH should be handled safely.
    *
    * Note that all orders are fill-or-kill. If you send in more ether than there are
    * tokens remaining to be bought, your transaction will be rolled back and you will
    * get no tokens and waste your gas.
    */
    function() public payable onlyDuringCrowdsale {
        createTokens(msg.sender);
    }
    
    ////////////
    // Events
    ////////////
    
    // Fired when the crowdsale is recorded as started.
    event CrowdsaleOpen(uint time);
    // Fired when someone contributes to the crowdsale and buys MRV
    event TokenPurchase(uint time, uint etherAmount, address from);
    // Fired when the crowdsale is recorded as ended.
    event CrowdsaleClose(uint time);
    // Fired when the decimal point moves
    event DecimalChange(uint8 newDecimals);
    
    ////////////
    // Modifiers (encoding important crowdsale logic)
    ////////////
    
    /**
     * Only allow some actions before the crowdsale closes, whether it's open or not.
     */
    modifier onlyBeforeClosed {
        checkCloseTimer();
        if (crowdsaleEnded) revert();
        _;
    }
    
    /**
     * Only allow some actions after the crowdsale is over.
     * Will set the crowdsale closed if it should be.
     */
    modifier onlyAfterClosed {
        checkCloseTimer();
        if (!crowdsaleEnded) revert();
        _;
    }
    
    /**
     * Only allow some actions before the crowdsale starts.
     */
    modifier onlyBeforeOpened {
        checkOpenTimer();
        if (crowdsaleStarted) revert();
        _;
    }
    
    /**
     * Only allow some actions while the crowdsale is active.
     * Will set the crowdsale open if it should be.
     */
    modifier onlyDuringCrowdsale {
        checkOpenTimer();
        checkCloseTimer();
        if (crowdsaleEnded) revert();
        if (!crowdsaleStarted) revert();
        _;
    }

    ////////////
    // Status and utility functions
    ////////////
    
    /**
     * Determine if the crowdsale should open by timer.
     */
    function openTimerElapsed() public constant returns (bool) {
        return (openTimer != 0 && now > openTimer);
    }
    
    /**
     * Determine if the crowdsale should close by timer.
     */
    function closeTimerElapsed() public constant returns (bool) {
        return (closeTimer != 0 && now > closeTimer);
    }
    
    /**
     * If the open timer has elapsed, start the crowdsale.
     * Can be called by people, but also gets called when people try to contribute.
     */
    function checkOpenTimer() public {
        if (openTimerElapsed()) {
            crowdsaleStarted = true;
            openTimer = 0;
            emit CrowdsaleOpen(now);
        }
    }
    
    /**
     * If the close timer has elapsed, stop the crowdsale.
     */
    function checkCloseTimer() public {
        if (closeTimerElapsed()) {
            crowdsaleEnded = true;
            closeTimer = 0;
            emit CrowdsaleClose(now);
        }
    }
    
    /**
     * Determine if the crowdsale is currently happening.
     */
    function isCrowdsaleActive() public constant returns (bool) {
        // The crowdsale is happening if it is open or due to open, and it isn't closed or due to close.
        return ((crowdsaleStarted || openTimerElapsed()) && !(crowdsaleEnded || closeTimerElapsed()));
    }
    
    ////////////
    // Before the crowdsale: configuration
    ////////////
    
    /**
     * Before the crowdsale opens, the max token count can be configured.
     */
    function setMaxSupply(uint newMaxInWholeTokens) public onlyOwner onlyBeforeOpened {
        maxCrowdsaleSupplyInWholeTokens = newMaxInWholeTokens;
    }
    
    /**
     * Allow the owner to start the crowdsale manually.
     */
    function openCrowdsale() public onlyOwner onlyBeforeOpened {
        crowdsaleStarted = true;
        openTimer = 0;
        emit CrowdsaleOpen(now);
    }
    
    /**
     * Let the owner start the timer for the crowdsale start. Without further owner intervention,
     * anyone will be able to open the crowdsale when the timer expires.
     * Further calls will re-set the timer to count from the time the transaction is processed.
     * The timer can be re-set after it has tripped, unless someone has already opened the crowdsale.
     */
    function setCrowdsaleOpenTimerFor(uint minutesFromNow) public onlyOwner onlyBeforeOpened {
        openTimer = now + minutesFromNow * 1 minutes;
    }
    
    /**
     * Let the owner stop the crowdsale open timer, as long as the crowdsale has not yet opened.
     */
    function clearCrowdsaleOpenTimer() public onlyOwner onlyBeforeOpened {
        openTimer = 0;
    }
    
    /**
     * Let the owner start the timer for the crowdsale end. Counts from when the function is called,
     * *not* from the start of the crowdsale.
     * It is possible, but a bad idea, to set this before the open timer.
     */
    function setCrowdsaleCloseTimerFor(uint minutesFromNow) public onlyOwner onlyBeforeClosed {
        closeTimer = now + minutesFromNow * 1 minutes;
    }
    
    /**
     * Let the owner stop the crowdsale close timer, as long as it has not yet expired.
     */
    function clearCrowdsaleCloseTimer() public onlyOwner onlyBeforeClosed {
        closeTimer = 0;
    }
    
    
    ////////////
    // During the crowdsale
    ////////////
    
    /**
     * Create tokens for the given address, in response to a payment.
     * Cannot be called by outside callers; use the fallback function, which will create tokens for whoever pays it.
     */
    function createTokens(address recipient) internal onlyDuringCrowdsale {
        if (msg.value == 0) {
            revert();
        }

        uint tokens = msg.value.mul(wholeTokensPerEth); // Exploits the fact that we have 18 decimals, like ETH.
        
        uint256 newTotalSupply = totalSupply().add(tokens);
        
        if (newTotalSupply > (wholeTokensReserved + maxCrowdsaleSupplyInWholeTokens) * 10 ** 18) {
            // This would be too many tokens issued.
            // Don't mess around with partial order fills.
            revert();
        }
        
        // Otherwise, we can fill the order entirely, so make the tokens and put them in the specified account.
        // TODO: This has been updated for OZ 2.0; the deployed onctract on chain does NOT use the OZ minting logic.
        // In particular, it did not emit transfer events for minted tokens, which confuses some blockchain viewers.
        _mint(recipient, tokens);
        
        // Announce the purchase
        emit TokenPurchase(now, msg.value, recipient);

        // Lastly (after all state changes), send the money to the crowdsale beneficiary.
        // This allows the crowdsale contract itself not to hold any ETH.
        // It also means that ALL SALES ARE FINAL!
        if (!beneficiary.send(msg.value)) {
            revert();
        }
    }
    
    /**
     * Allow the owner to end the crowdsale manually.
     */
    function closeCrowdsale() public onlyOwner onlyDuringCrowdsale {
        crowdsaleEnded = true;
        closeTimer = 0;
        emit CrowdsaleClose(now);
    }  
    
    ////////////
    // After the crowdsale: token maintainance
    ////////////
    
    /**
     * When the crowdsale is finished, the contract owner may adjust the decimal places for display purposes.
     * This should work like a 10-to-1 split or reverse-split.
     * The point of this mechanism is to keep the individual MRV tokens from getting inconveniently valuable or cheap.
     * However, it relies on the contract owner taking the time to update the decimal place value.
     * Note that this changes the decimals IMMEDIATELY with NO NOTICE to users.
     */
    function setDecimals(uint8 newDecimals) public onlyOwner onlyAfterClosed {
        decimals = newDecimals;
        // Announce the change
        emit DecimalChange(decimals);
    }
    
    /**
     * If Ether somehow manages to get into this contract, provide a way to get it out again.
     * During normal crowdsale operation, ETH is immediately forwarded to the beneficiary.
     */
    function reclaimEther() external onlyOwner {
        // Send the ETH. Make sure it worked.
        assert(owner().send(address(this).balance));
    }

    // TODO: the following two functions do NOT exist in the on-chain mainnet
    // version of the contract. They are here to allow the project to build
    // with newer versions of OpenZeppelin.

    /**
     * Block the increaseAllowance method which is not in the mainned deployed
     * contract, but which OZ added to their library after we deployed.
     */
    function increaseAllowance(address /* spender */, uint256 /* addedValue */) public returns (bool) {
        revert();
    }

    /**
     * Block the decreaseAllowance method which is not in the mainned deployed
     * contract, but which OZ added to their library after we deployed.
     */
    function decreaseAllowance(address /* spender */, uint256 /* addedValue */) public returns (bool) {
        revert();
    }

}

contract Deployer{
  MRVToken t = new MRVToken(0xCAB1111111111111111111111111111111111111, 0xCAB2222222222222222222222222222222222222);
}
