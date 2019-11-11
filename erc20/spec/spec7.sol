contract Spec{
// The name of the token cannot be changed
    property spec7 {
        always(Token._name == prev(Token._name));
        // Extra predicates
        (Token._name == "Sample Token");
        (Token._symbol == "STK");
    }
}
