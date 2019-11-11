contract Spec{
// Only the owner can elect who is the new owner
    property spec4 {
        always(
            (
                ((Token._minters.bearer[0x123]) == false) &&
                (prev(Token._minters.bearer[0x123]) == true)
            ) ==>
            (msg.sender == 0x123)
        );
        // Extra predicates
        (Token._name == "Sample Token");
        (Token._symbol == "STK");
    }
}
