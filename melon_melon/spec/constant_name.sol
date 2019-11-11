contract Spec {
    property constant_name {
        always(
            prev(Melon._name) == Melon._name
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon.council == 0xDEADBEEF); 
    }
}
