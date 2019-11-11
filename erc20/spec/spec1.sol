contract Spec{
// Only the owner can change the supply of tokens
    property spec1 {
        always((Token._totalSupply > prev(Token._totalSupply)) ==> (prev(Token._minters.bearer[msg.sender]) == true));
        // Extra predicates
        (Token._name == "Sample Token");
        (Token._symbol == "STK");
    }
}
