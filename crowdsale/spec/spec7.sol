contract Spec{
// Functions deposit, withdraw, close, and enableRefunds
// of the escrow can be only invoked by the primary account
// of the escrow
    property spec7 {
        always((FUNCTION == RefundEscrow.deposit(address)) ||
               (FUNCTION == RefundEscrow.withdraw(address)) ||
               (FUNCTION == RefundEscrow.close()) ||
               (FUNCTION == RefundEscrow.enableRefunds())
               ==>
               (msg.sender == RefundEscrow._primary)
        );
        // Extra predicates
        (SampleCrowdsale._escrow == RefundEscrow);
        (RefundEscrow._primary == SampleCrowdsale);
        (SampleCrowdsale._token == SampleCrowdsaleToken);
        (SampleCrowdsaleToken._name == "Sample Crowdsale Token");
        (SampleCrowdsaleToken._symbol == "SCT");
    }
}
