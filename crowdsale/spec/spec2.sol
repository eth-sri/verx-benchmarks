contract Spec{
// The refunding state of the escrow is forever and cannot be changed
    property spec2 {
        always((prev(RefundEscrow._state) == 1) ==> (RefundEscrow._state == 1));
        // Extra predicates
        (SampleCrowdsale._escrow == RefundEscrow);
        (RefundEscrow._primary == SampleCrowdsale);
        (SampleCrowdsale._token == SampleCrowdsaleToken);
        (SampleCrowdsaleToken._name == "Sample Crowdsale Token");
        (SampleCrowdsaleToken._symbol == "SCT");

    }
}
