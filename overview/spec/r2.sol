contract Spec{
    // The escrow never allows the beneficiary to withdraw the
    // investments and the investors to claim refunds.
    property r2 {
        always(
            !(once(FUNCTION == Escrow.claimRefund(address)) && once(FUNCTION == Escrow.withdraw()))
        );
        // Extra predicates
        (Crowdsale.escrow == Escrow);
        (Escrow.owner == Crowdsale);
        (Crowdsale.goal == 10000 * 10**18);

        (Escrow.state == 0);
        (Escrow.state == 1);
        (Escrow.state == 2);


        (Crowdsale.raised < Crowdsale.goal);

        (now <= Crowdsale.closeTime);
    }

}
