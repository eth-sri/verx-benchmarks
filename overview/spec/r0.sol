contract Spec{
    // The sum of all investor deposits equals the ether balance
    // of the escrow unless the crowdsale is declared successful
    // @expected verified
    property r0 {
        always(
            (
                (FUNCTION == Escrow.claimRefund(address))
            ) ==>
            (BALANCE(Escrow) ==
             (prev(BALANCE(Escrow)) - prev(Escrow.deposits)[Escrow.claimRefund(address)[0]])));
        // Extra predicates
        (Crowdsale.escrow == Escrow);
        (Escrow.owner == Crowdsale);
    }
}
