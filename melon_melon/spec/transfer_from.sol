contract Spec {
    property transfer_from {
        always(
            ((FUNCTION == Melon.transferFrom(address,address,uint256)) && (Melon.transferFrom(address,address,uint256)[0] != Melon.transferFrom(address,address,uint256)[1]))
                ==> (
                        (Melon._balances[Melon.transferFrom(address,address,uint256)[0]] 
                            == prev(Melon._balances[Melon.transferFrom(address,address,uint256)[0]]) - Melon.transferFrom(address,address,uint256)[2])
                        && 
                        (Melon._balances[Melon.transferFrom(address,address,uint256)[1]] 
                            == prev(Melon._balances[Melon.transferFrom(address,address,uint256)[1]]) + Melon.transferFrom(address,address,uint256)[2])
                        &&
                        (prev(Melon._allowed[Melon.transferFrom(address,address,uint256)[0]][msg.sender]) >= Melon.transferFrom(address,address,uint256)[2])
                    )
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon._decimals == 18);
        (Melon.council == 0xDEADBEEF); 
    }
}
