contract Spec{
    // The sum of all investor deposits equals the ether balance
    // of the escrow unless the crowdsale is declared successful
    // @expected verified
    property r1 {
        always( (Escrow.state != 1) ==> (BALANCE(Escrow) >= SUM(Escrow.deposits)));

        // Extra predicates
        // without this predicate the call loop happens. Crowdsale.close calls `escrow.close();`.
        // Without exact knowledge that Crowdsale.escrow points to Escrow contract the execution won't terminate as the Crowdsale will keep calling all other deployed contracts including itself.
        // That will result in a trace `Crowdsale.close() ->  Crowdsale.close() -> ...` being reachable. 
        (Crowdsale.escrow == Escrow);
        // Without constrain on the owner, anyone can call the
        // functions Escrow.close() and Escrow.deposit(address) that have onlyOwner modifier. That will violate the behaviour
        (Escrow.owner == Crowdsale);
        // Without stage constraint require(state == State.REFUND) or require(state == State.SUCCESS);
        // can be called and violate the execution
        (Escrow.state == 0);
        (Escrow.state == 1);
        (Escrow.state == 2);

        //  Without this constrant the violation trace:
        // Deployer.init(), Crowdsale.close(), Escrow.withdraw(), Crowdsale.close()
        // the Crowdsale closes to the success and withdraw transfers everything to beneficiary. Then extra close will close the State to the REFUND state, where the property r1 violated.
        // This second close cannot close to the REFUND in practice, and this predicate tracks it.
        (Crowdsale.raised < Crowdsale.goal);
    }
}
