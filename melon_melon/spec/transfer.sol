contract Spec {
    property transfer {
        always(
            ((FUNCTION == Melon.transfer(address,uint256)) && (Melon.transfer(address,uint256)[0] != msg.sender))
                ==> (
                        (Melon._balances[msg.sender] 
                            == prev(Melon._balances[msg.sender]) - Melon.transfer(address,uint256)[1])
                        && 
                        (Melon._balances[Melon.transfer(address,uint256)[0]] 
                            == prev(Melon._balances[Melon.transfer(address,uint256)[0]]) + Melon.transfer(address,uint256)[1])
                    )
        );
        // Extra predicates
        (Melon._name == "MelonToken");
        (Melon._symbol == "MLN");
        (Melon._decimals == 18);
        (Melon.council == 0xDEADBEEF); 
    }
}
