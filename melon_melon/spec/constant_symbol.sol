contract Spec {
    property constant_symbol {
        always(
            prev(Melon._symbol) == Melon._symbol
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon.council == 0xDEADBEEF); 
    }
}
