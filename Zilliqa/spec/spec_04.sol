contract Spec {
    property spec_04 {
        always(
            (FUNCTION == ZilliqaToken.transfer(address,uint256)) ==> (0x0 != ZilliqaToken.transfer(address,uint256)[0])
        );
    }
}
