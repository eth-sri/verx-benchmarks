contract Spec{
// The amount of raised funds can never exceed the hardcap
// of the crowdsale
    property spec1 {
        always((SampleCrowdsale._weiRaised <= SampleCrowdsale._cap));
        // Extra predicates
        (SampleCrowdsale._escrow == RefundEscrow);
        (RefundEscrow._primary == SampleCrowdsale);
        (SampleCrowdsale._token == SampleCrowdsaleToken);
        (SampleCrowdsaleToken._name == "Sample Crowdsale Token");
        (SampleCrowdsaleToken._symbol == "SCT");

    }
}
