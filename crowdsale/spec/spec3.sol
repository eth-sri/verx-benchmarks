contract Spec{
// The closed state of the escrow is forever and cannot be changed
    property spec3 {
        always((prev(RefundEscrow._state) == 2) ==> (RefundEscrow._state == 2));
        // Extra predicates
        (SampleCrowdsale._escrow == RefundEscrow);
        (RefundEscrow._primary == SampleCrowdsale);
        (SampleCrowdsale._token == SampleCrowdsaleToken);
        (SampleCrowdsaleToken._name == "Sample Crowdsale Token");
        (SampleCrowdsaleToken._symbol == "SCT");
    }
}
