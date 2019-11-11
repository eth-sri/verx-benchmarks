contract Spec{
// Only users may change their own balances of tokens
    property spec2 {
        always(((FUNCTION == Token.transfer(address,uint256)) && (prev(Token._balances[0x123]) > Token._balances[0x123])) ==> (msg.sender == 0x123));
        // Extra predicates
        (Token._name == "Sample Token");
        (Token._symbol == "STK");
    }
}
