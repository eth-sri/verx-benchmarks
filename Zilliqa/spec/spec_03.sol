contract Spec {
    property spec_03 {
        always(
            (ZilliqaToken.admin != prev(ZilliqaToken.admin)) ==> (msg.sender == prev(ZilliqaToken.owner))
        );
    }
}
