contract Spec {
    property spec_05 {
        always(
            (FUNCTION == ZilliqaToken.transfer(address,uint256)) ==> (ZilliqaToken != ZilliqaToken.transfer(address,uint256)[0])
        );
    }
}
