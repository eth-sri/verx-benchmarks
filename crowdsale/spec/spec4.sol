contract Spec{
// Deposits are possible only if the escrow is in active state
    property spec4 {
        always((FUNCTION == RefundEscrow.deposit(address)) ==> (RefundEscrow._state == 0));
        // Extra predicates
        (SampleCrowdsale._escrow == RefundEscrow);
        (RefundEscrow._primary == SampleCrowdsale);
        (SampleCrowdsale._token == SampleCrowdsaleToken);
        (SampleCrowdsaleToken._name == "Sample Crowdsale Token");
        (SampleCrowdsaleToken._symbol == "SCT");
    }
}
