pragma solidity ^ 0.4.18;







/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
 * the methods to add functionality. Consider using 'super' where appropiate to concatenate
 * behavior.
 */

contract Crowdsale {
  using SafeMath for uint256;

  // The token being sold
  ERC20 public token;

  // Address where funds are collected
  address public wallet;

  // How many token units a buyer gets per wei
  uint256 public rate;

  // Amount of wei raised
  uint256 public weiRaised;

  /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  /**
   * @param _rate Number of token units a buyer gets per wei
   * @param _wallet Address where collected funds will be forwarded to
   * @param _token Address of the token being sold
   */
  function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
    require(_rate > 0);
    require(_wallet != address(0));
    require(_token != address(0));

    rate = _rate;
    wallet = _wallet;
    token = _token;
  }

  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------

  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    buyTokens(msg.sender);
  }

  /**
   * @dev low level token purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the token purchase
   */
  function buyTokens(address _beneficiary) public payable {

    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    _processPurchase(_beneficiary, tokens);
    TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);

    _updatePurchasingState(_beneficiary, weiAmount);

    _forwardFunds();
    _postValidatePurchase(_beneficiary, weiAmount);
  }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

  /**
   * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
  }

  /**
   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
    // optional override
  }

  /**
   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
   * @param _beneficiary Address performing the token purchase
   * @param _tokenAmount Number of tokens to be emitted
   */
  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    token.transfer(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
   * @param _beneficiary Address receiving the tokens
   * @param _tokenAmount Number of tokens to be purchased
   */
  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
    _deliverTokens(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
   * @param _beneficiary Address receiving the tokens
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
    // optional override
  }

  /**
   * @dev Override to extend the way in which ether is converted to tokens.
   * @param _weiAmount Value in wei to be converted into tokens
   * @return Number of tokens that can be purchased with the specified _weiAmount
   */
  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
    return _weiAmount.mul(rate);
  }

  /**
   * @dev Determines how ETH is stored/forwarded on purchases.
   */
  function _forwardFunds() internal {
    wallet.transfer(msg.value);
  }
}


/**
 * @title AllowanceCrowdsale
 * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
 */
contract AllowanceCrowdsale is Crowdsale {
  using SafeMath for uint256;

  address public tokenWallet;

  /**
   * @dev Constructor, takes token wallet address. 
   * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
   */
  function AllowanceCrowdsale(address _tokenWallet) public {
    require(_tokenWallet != address(0));
    tokenWallet = _tokenWallet;
  }

  /**
   * @dev Checks the amount of tokens left in the allowance.
   * @return Amount of tokens left in the allowance
   */
  function remainingTokens() public view returns (uint256) {
    return token.allowance(tokenWallet, this);
  }

  /**
   * @dev Overrides parent behavior by transferring tokens from wallet.
   * @param _beneficiary Token purchaser
   * @param _tokenAmount Amount of tokens purchased
   */
  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
  }
}




/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame.
 */
contract TimedCrowdsale is Crowdsale {
  using SafeMath for uint256;

  uint256 public openingTime;
  uint256 public closingTime;

  /**
   * @dev Reverts if not in crowdsale time range. 
   */
  modifier onlyWhileOpen {
    require(now >= openingTime && now <= closingTime);
    _;
  }

  /**
   * @dev Constructor, takes crowdsale opening and closing times.
   * @param _openingTime Crowdsale opening time
   * @param _closingTime Crowdsale closing time
   */
  function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
    require(_openingTime >= now);
    require(_closingTime >= _openingTime);

    openingTime = _openingTime;
    closingTime = _closingTime;
  }

  /**
   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
   * @return Whether crowdsale period has elapsed
   */
  function hasClosed() public view returns (bool) {
    return now > closingTime;
  }
  
  /**
   * @dev Extend parent behavior requiring to be within contributing period
   * @param _beneficiary Token purchaser
   * @param _weiAmount Amount of wei contributed
   */
  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }

}

/**
 * @title PostDeliveryCrowdsale
 * @dev Crowdsale that locks tokens from withdrawal until it ends.
 */
contract PostDeliveryCrowdsale is TimedCrowdsale {
  using SafeMath for uint256;

  mapping(address => uint256) public balances;

  /**
   * @dev Overrides parent by storing balances instead of issuing tokens right away.
   * @param _beneficiary Token purchaser
   * @param _tokenAmount Amount of tokens purchased
   */
  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
    balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
  }

  /**
   * @dev Withdraw tokens only after crowdsale ends.
   */
  function withdrawTokens() public {
    require(hasClosed());
    uint256 amount = balances[msg.sender];
    require(amount > 0);
    balances[msg.sender] = 0;
    _deliverTokens(msg.sender, amount);
  }
}





/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}


/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is BasicToken {

  event Burn(address indexed burner, uint256 value);

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */
  function burn(uint256 _value) public {
    require(_value <= balances[msg.sender]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    address burner = msg.sender;
    balances[burner] = balances[burner].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
    Burn(burner, _value);
  }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}



/**
 * @title Whitelist
 * @dev List of whitelisted users who can contribute.
 */
contract Whitelist is Ownable {
    mapping(address => bool) public whitelist;
    mapping(address => bool) public authorized;

    event UserAllowed(address user);
    event UserDisallowed(address user);

    modifier onlyAuthorized {
        require(msg.sender == owner || authorized[msg.sender]);
        _;
    }

    /**
    * @dev Adds single address to admins.
    * @param _admin Address to be added to the admins
    */
    function authorize(address _admin) external onlyOwner {
        authorized[_admin] = true;
    }

    /**
    * @dev Removes single address from admins.
    * @param _admin Address to be removed from the admins
    */
    function reject(address _admin) external onlyOwner {
        authorized[_admin] = false;
    }

    /**
    * @dev Adds single address to whitelist.
    * @param _beneficiary Address to be added to the whitelist
    */
    function addToWhitelist(address _beneficiary) external onlyAuthorized {
        whitelist[_beneficiary] = true;
        UserAllowed(_beneficiary);
    }

    /**
    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
    * @param _beneficiaries Addresses to be added to the whitelist
    */
    function addManyToWhitelist(address[] _beneficiaries) external onlyAuthorized {
        for (uint i = 0; i < _beneficiaries.length; i++) {
            whitelist[_beneficiaries[i]] = true;
            UserAllowed(_beneficiaries[i]);
        }
    }

    /**
    * @dev Removes single address from whitelist.
    * @param _beneficiary Address to be removed to the whitelist
    */
    function removeFromWhitelist(address _beneficiary) external onlyAuthorized {
        whitelist[_beneficiary] = false;
        UserDisallowed(_beneficiary);
    }

    /**
    * @dev Tells whether the given address is whitelisted or not
    * @param _beneficiary Address to be checked
    */
    function isWhitelisted(address _beneficiary) public view returns (bool) {
        return whitelist[_beneficiary];
    }
}


/**
 * @title BaseCrowdsale
 * @dev BaseCrowdsale is a base contract for managing a VU token crowdsale
 * Crowdsale that locks tokens from withdrawal until special time.
 *
 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
 */
contract BaseCrowdsale is AllowanceCrowdsale, PostDeliveryCrowdsale, Ownable {
    // whitelist data provider
    Whitelist public whitelist;
    // amount of tokens sold
    uint public tokensSold = 0;
    uint public deliveryTime;
    uint public limit;

    /**
    * @dev Reverts if beneficiary is not whitelisted.
    */
    modifier onlyWhitelisted(address _beneficiary) {
        require(whitelist.isWhitelisted(_beneficiary));
        _;
    }

    /**
    * @dev Constructor
    * @param _token Address of the token being sold
    * @param _whitelist the list of whitelisted users
    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
    * @param _wallet Address where collected funds will be forwarded to
    * @param _rate How many token units a buyer gets per wei
    * @param _openingTime Crowdsale opening time
    * @param _closingTime Crowdsale closing time
    */
    function BaseCrowdsale(
        ERC20 _token,
        address _whitelist,
        address _tokenWallet,
        address _wallet,
        uint _rate,
        uint _openingTime,
        uint _closingTime,
        uint _deliveryTime,
        uint _limit)
    public
        Crowdsale(_rate, _wallet, _token)
        AllowanceCrowdsale(_tokenWallet)
        TimedCrowdsale(_openingTime, _closingTime)
    {
        require(_whitelist != 0x0);
        require(now < _deliveryTime);
        require(_limit > 0);
        // we know that the end is planned for ~June 30th, just to be sure that
        // _deliveryTime will not be unexpectedly big (mistake during deployment, for example)
        require(_deliveryTime < now + 100 days);

        whitelist = Whitelist(_whitelist);

        deliveryTime = _deliveryTime;
        limit = _limit;

        _init();
    }

    /**
    * @dev Withdraw tokens only after delivery date
    */
    function withdrawTokens() public {
        require(now >= deliveryTime);
        super.withdrawTokens();
    }

    /**
    * @dev Override for extensions that require a custom crowdsale initialization flow
    */
    function _init()
    internal
    {
        // optional override
    }

    /**
    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
    * @param _beneficiary Token beneficiary
    * @param _weiAmount Amount of wei contributed
    */
    function _preValidatePurchase(address _beneficiary, uint _weiAmount)
    internal
    onlyWhitelisted(_beneficiary)
    {
        super._preValidatePurchase(_beneficiary, _weiAmount);
    }

    /**
    * @dev Overrides parent
    * @param _beneficiary Token purchaser
    * @param _tokenAmount Amount of tokens purchased
    */
    function _processPurchase(address _beneficiary, uint _tokenAmount)
    internal
    {
        tokensSold = tokensSold.add(_tokenAmount);
        require(limit >= tokensSold);

        PostDeliveryCrowdsale._processPurchase(_beneficiary, _tokenAmount);
    }
}


/**
 * @title PresaleCrowdsale
 * @dev PresaleCrowdsale is a contract for managing a token presale
 *
 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
 */
contract PresaleCrowdsale is BaseCrowdsale {
    uint public constant PHASE1_RATE = 7500;
    uint public constant PHASE2_RATE = 6900;
    uint public constant PHASE3_RATE = 6300;

    uint public constant PHASE1_CAP = 30000000 * (10**18);
    uint public constant PHASE2_CAP = 40000000 * (10**18);
    uint public constant PHASE3_CAP = 80000000 * (10**18);

    uint public constant PHASE1_LIMIT = PHASE1_CAP;
    uint public constant PHASE2_LIMIT = PHASE1_CAP + PHASE2_CAP;
    uint public constant PHASE3_LIMIT = PHASE1_CAP + PHASE2_CAP + PHASE3_CAP;

    enum PhaseId {Phase1, Phase2, Phase3}

    struct Phase {
        uint rate;
        uint cap;
        uint limit;
    }

    Phase[] public phases;

    /**
    * @dev Constructor
    * @param _token Address of the token being sold
    * @param _whitelist the whitelisted users data provider
    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
    * @param _openingTime Crowdsale opening time
    * @param _closingTime Crowdsale closing time
    * @param _wallet Address where collected funds will be forwarded to
    */
    function PresaleCrowdsale(
        ERC20 _token,
        address _whitelist,
        address _tokenWallet,
        address _wallet,
        uint _openingTime,
        uint _closingTime,
        uint _deliveryTime)
    public
        BaseCrowdsale(
            _token,
            _whitelist,
            _tokenWallet,
            _wallet,
            PHASE1_RATE,
            _openingTime,
            _closingTime,
            _deliveryTime,
            PHASE3_LIMIT)
    {
    }

    /**
    * @dev Returns id of the current phase
    */
    function getPhase()
    public
    view
    returns (uint)
    {
        return uint(_getPhase());
    }

    /**
    * @dev Returns the rate of tokens per wei at the present time.
    * @return The number of tokens a buyer gets per wei at a given time
    */
    function getPhaseRate(PhaseId _phase)
    public
    view
    returns (uint)
    {
        uint rate = phases[uint(_phase)].rate;
        assert(rate > 0);
        return rate;
    }

    /**
    * @dev Returns cap of the given phase
    */
    function getPhaseCap(PhaseId _phase)
    public
    view
    returns (uint)
    {
        uint cap = phases[uint(_phase)].cap;
        assert(cap > 0);
        return cap;
    }

    /**
    * @dev Can be overridden to add initialization logic. The overriding function
    * should call super._init() to ensure the chain of initialization is
    * executed entirely.
    */
    function _init()
    internal
    {
        super._init();

        phases.push(Phase(PHASE1_RATE, PHASE1_CAP, PHASE1_LIMIT));
        phases.push(Phase(PHASE2_RATE, PHASE2_CAP, PHASE2_LIMIT));
        phases.push(Phase(PHASE3_RATE, PHASE3_CAP, PHASE3_LIMIT));
    }

    /**
    * @dev Returns phase at the present time.
    */
    function _getPhase()
    internal
    view
    returns (PhaseId)
    {
        if (tokensSold <= _getPhaseUpperLimit(PhaseId.Phase1)) {
            return PhaseId.Phase1;
        } else if (tokensSold <= _getPhaseUpperLimit(PhaseId.Phase2)) {
            return PhaseId.Phase2;
        } else {
            assert(tokensSold <= _getPhaseUpperLimit(PhaseId.Phase3));
            return PhaseId.Phase3;
        }
    }

    /**
    * @dev Returns amount of sold tokens when the given phase is ended.
    */
    function _getPhaseUpperLimit(PhaseId _phase)
    internal
    view
    returns (uint)
    {
        uint limit = phases[uint(_phase)].limit;
        assert(limit > 0);
        return limit;
    }

    /**
    * @dev Overrides parent method taking into account variable rate.
    * @param _weiAmount The value in wei to be converted into tokens
    * @return The number of tokens _weiAmount wei will buy at present time
    */
    function _getTokenAmount(uint _weiAmount)
    internal
    view
    returns (uint)
    {
        PhaseId currentPhase = _getPhase();
        return _calcTokenAmount(currentPhase, _weiAmount, tokensSold);
    }

    /**
    * @dev Calculates amount of tokens which can purchased
    * @param _phase the phase of presale
    * @param _weiAmount the value in wei to be converted into tokens
    * @param _tokensSold the amount of sold tokens
    * @return The number of tokens _weiAmount wei will buy at present time
    */
    function _calcTokenAmount(PhaseId _phase, uint _weiAmount, uint _tokensSold)
    private
    view
    returns (uint tokensBought)
    {
        uint rate = getPhaseRate(_phase);

        tokensBought = rate.mul(_weiAmount);

        if (_tokensSold.add(tokensBought) > _getPhaseUpperLimit(_phase)) {
            uint tokens = _getPhaseUpperLimit(_phase).sub(_tokensSold);

            PhaseId nextPhase = PhaseId(uint(_phase) + 1);
            tokensBought = _calcTokenAmount(nextPhase, _weiAmount.sub(tokens.div(rate)), _tokensSold.add(tokens));

            tokensBought = tokensBought.add(tokens);
        }

        return tokensBought;
    }
}
pragma solidity ^0.4.17;




contract DetailedERC20 is ERC20 {
  string public name;
  string public symbol;
  uint8 public decimals;

  function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }
}




/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}




/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    Unpause();
  }
}


/**
 * @title Pausable token
 * @dev StandardToken modified with pausable transfers.
 **/
contract PausableToken is StandardToken, Pausable {

  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
    return super.approve(_spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}


/**
 * @title VU Token
 * @dev VU Token token smart contract
 *
 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
 */
contract VUToken is DetailedERC20, BurnableToken, PausableToken {
    using SafeMath for uint256;

    uint public constant INITIAL_SUPPLY = 1000000000 * (10**18);

    /**
    * @dev Constructor
    */
    function VUToken() public
    DetailedERC20("VU TOKEN", "VU", 18)
    {
        totalSupply_ = INITIAL_SUPPLY;

        balances[msg.sender] = INITIAL_SUPPLY;
        Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }

    /**
    * @dev Function to transfer tokens
    * @param _recipients The addresses that will receive the tokens.
    * @param _amounts The list of the amounts of tokens to transfer.
    * @return A boolean that indicates if the operation was successful.
    */
    function massTransfer(address[] _recipients, uint[] _amounts) external returns (bool) {
        require(_recipients.length == _amounts.length);

        for (uint i = 0; i < _recipients.length; i++) {
            require(transfer(_recipients[i], _amounts[i]));
        }

        return true;
    }
}
pragma solidity ^ 0.4.18;



/**
 * @title ICOCrowdsale
 * @dev ICOCrowdsale is an ICO contract for managing a token crowdsale
 *
 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
 */
contract ICOCrowdsale is BaseCrowdsale {
    // how many token units a buyer gets per wei
    uint public constant RATE = 6000;
    uint public constant MAX_LIMIT = 450000000 * (10**18);

    /**
    * @dev Constructor
    * @param _token Address of the token being sold
    * @param _whitelist the whitelisted users data provider
    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
    * @param _wallet Address where collected funds will be forwarded to
    * @param _openingTime Crowdsale opening time
    * @param _closingTime Crowdsale closing time
    */
    function ICOCrowdsale(
        ERC20 _token,
        address _whitelist,
        address _tokenWallet,
        address _wallet,
        uint _openingTime,
        uint _closingTime,
        uint _deliveryTime)
    public
        BaseCrowdsale(
            _token,
            _whitelist,
            _tokenWallet,
            _wallet,
            RATE,
            _openingTime,
            _closingTime,
            _deliveryTime,
            MAX_LIMIT)
    {
    }
}

contract Deployer{
   VUToken v = new VUToken();
   Whitelist w = new Whitelist();
   PresaleCrowdsale i = new PresaleCrowdsale(v, w, 0xDEADBEEF11111111111111111111111111111111, 0xDEADBEEF22222222222222222222222222222222, 1525039200, 1530309600, 1530396000);
}
