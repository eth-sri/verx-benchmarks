contract Spec {
    property receiver_does_not_undeflow {
        always(
            (FUNCTION == Melon.transfer(address,uint256))
                ==> (prev(Melon._balances[msg.sender]) >= Melon._balances[msg.sender])
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon._decimals == 18);
        (Melon.council == 0xDEADBEEF); 
    }
}
