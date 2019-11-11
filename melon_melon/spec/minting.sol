contract Spec {
    property minting {
        always(
            (prev(Melon.nextMinting) != Melon.nextMinting)
                ==> (prev(Melon.nextMinting) == (Melon.nextMinting - 31536000))
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon.council == 0xDEADBEEF); 
    }
}

