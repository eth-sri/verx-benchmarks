contract Spec{
// The sum of user balances equals the supply of tokens
    property spec3 {
        always(SUM(Token._balances) == Token._totalSupply);
        // Extra predicates
        (Token._name == "Sample Token");
        (Token._symbol == "STK");
    }
}
