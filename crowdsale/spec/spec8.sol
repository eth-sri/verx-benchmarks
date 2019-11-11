contract Spec{
// The token distributed by the crowdsale is Token
    property spec8 {
        always(SampleCrowdsale._token == SampleCrowdsaleToken);
        // Extra predicates
        (SampleCrowdsale._escrow == RefundEscrow);
        (RefundEscrow._primary == SampleCrowdsale);
        (SampleCrowdsale._token == SampleCrowdsaleToken);
        (SampleCrowdsaleToken._name == "Sample Crowdsale Token");
        (SampleCrowdsaleToken._symbol == "SCT");
    }
}
