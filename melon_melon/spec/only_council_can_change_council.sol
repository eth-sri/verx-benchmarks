contract Spec {
    property only_council_can_change_council {
        always(
            (prev(Melon.council) != Melon.council)
                ==> (msg.sender == prev(Melon.council))
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon.council == 0xDEADBEEF); 
    }
}
