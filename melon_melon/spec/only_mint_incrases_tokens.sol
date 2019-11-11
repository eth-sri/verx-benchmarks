contract Spec {
    property only_mint_incrases_tokens {
        always (
            (prev(Melon._totalSupply) < Melon._totalSupply)
                ==> ((FUNCTION == Melon.mintInitialSupply(address)) || (FUNCTION == Melon.mintInflation()))
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon.council == 0xDEADBEEF); 
    }
}
