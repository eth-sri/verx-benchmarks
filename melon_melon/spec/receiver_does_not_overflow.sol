contract Spec {
    property receiver_does_not_overflow {
        always(
            (FUNCTION == Melon.transfer(address,uint256))
                ==> (prev(Melon._balances[Melon.transfer(address,uint256)[0]])
                     <= Melon._balances[Melon.transfer(address,uint256)[0]])
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon._decimals == 18);
        (Melon.council == 0xDEADBEEF); 
    }
}
