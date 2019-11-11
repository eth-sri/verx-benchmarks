contract Spec {
    property sum_of_balances_equals_total_supply {
        always(
            SUM(Melon._balances) == Melon._totalSupply
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon._decimals == 18);
        (Melon.council == 0xDEADBEEF); 
    }
}
