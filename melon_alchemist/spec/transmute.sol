contract Spec {
    property transmute {
        always (
            (FUNCTION == Alchemist.transmute(uint256)) ==>
            (
                (Lead._balances[msg.sender] == (prev(Lead._balances[msg.sender]) - Alchemist.transmute(uint256)[0])) &&
                (Gold._balances[msg.sender] == (prev(Gold._balances[msg.sender]) + Alchemist.transmute(uint256)[0]))
            )
        );
        // Extra predicates
        (Alchemist.GOLD == Gold);
        (Alchemist.LEAD == Lead);
    }
}
