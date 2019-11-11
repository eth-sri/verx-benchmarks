contract Spec {
    property constant_decimals {
        always(
            prev(Melon._decimals) == Melon._decimals
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon.council == 0xDEADBEEF); 
    }
}
