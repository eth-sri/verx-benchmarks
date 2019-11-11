contract Spec {
    property balance_safety {
        always(
            (prev(Melon._balances[1]) > Melon._balances[1])
                ==> (msg.sender == 1 || (FUNCTION == Melon.burnFrom(address,uint256))|| (FUNCTION == Melon.burn(uint256)) || (FUNCTION == Melon.transferFrom(address,address,uint256)))
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon.council == 0xDEADBEEF); 
    }
}
