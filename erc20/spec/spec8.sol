contract Spec{
// The symbolc of the token cannot be changed
    property spec8 {
        always(Token._symbol == prev(Token._symbol));
        // Extra predicates
        (Token._name == "Sample Token");
        (Token._symbol == "STK");
    }
}
