contract Spec {
    property inflation_enabled {
        always((FUNCTION == Melon.mintInflation()) ==> (now >= 1551398400));
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon.council == 0xDEADBEEF); 
    }
}
