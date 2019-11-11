contract Spec{
// The decimals of the token cannot be changed
    property spec9 {
        always(Token._decimals == prev(Token._decimals));
        // Extra predicates
        (Token._name == "Sample Token");
        (Token._symbol == "STK");
    }
}
