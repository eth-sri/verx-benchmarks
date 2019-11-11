contract Spec {
    property spec_01 {
        always(
            (ZilliqaToken.owner != prev(ZilliqaToken.owner)) ==> (msg.sender == prev(ZilliqaToken.owner))
        );
    }
}
