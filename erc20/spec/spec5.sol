contract Spec{
// Only the mint function can change the supply of tokens
    property spec5 {
        always((Token._totalSupply != prev(Token._totalSupply)) ==> (FUNCTION == Token.mint(address,uint256)));
        // Extra predicates
        (Token._name == "Sample Token");
        (Token._symbol == "STK");
    }
}
