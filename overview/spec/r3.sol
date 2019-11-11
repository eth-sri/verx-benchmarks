contract Spec{
    // Investors cannot claim refunds after the crowdsale's goal of
    // ether is collected.
    property r3 {
        always(
            (Escrow.claimRefund(address) == FUNCTION) ==> always(SUM(Escrow.deposits) < Crowdsale.goal)
        );
        // Extra predicates
        //once(prev(SUM(Escrow.deposits)) >= prev(Crowdsale.goal));
        //(prev(SUM(Escrow.deposits)) >= prev(Crowdsale.goal));
        ((SUM(Escrow.deposits) < Crowdsale.goal) ==> (always(SUM(Escrow.deposits) < Crowdsale.goal)));
        frame(Crowdsale.escrow == Escrow);
        (Escrow.owner == Crowdsale);
        (Crowdsale.goal == 10000 * 10**18);
        (Escrow.state == 0);
        (Escrow.state == 1);
        (Escrow.state == 2);
        (SUM(Escrow.deposits) < Crowdsale.goal);

        (SUM(Escrow.deposits) == Crowdsale.raised);
        (now <= Crowdsale.closeTime);
    }
}
