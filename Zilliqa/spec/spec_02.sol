contract Spec {
    property spec_02 {
        always(
            SUM(ZilliqaToken.balances) == ZilliqaToken.totalSupply
        );
    }
}
