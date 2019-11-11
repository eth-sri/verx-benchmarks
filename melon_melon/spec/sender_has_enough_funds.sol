contract Spec {
    property sender_has_enough_funds {
        always(
            (FUNCTION == Melon.transfer(address,uint256))
                ==> (prev(Melon._balances[msg.sender]) >= Melon.transfer(address,uint256)[1])
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon._decimals == 18);
        (Melon.council == 0xDEADBEEF); 
    }
}
