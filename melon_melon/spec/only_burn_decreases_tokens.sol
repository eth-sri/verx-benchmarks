contract Spec {
    property only_burn_decreases_tokens {
        always (
            (prev(Melon._totalSupply) > Melon._totalSupply)
                ==> ((FUNCTION == Melon.burn(uint256)) || (FUNCTION == Melon.burnFrom(address,uint256)))
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon.council == 0xDEADBEEF); 
    }
}
