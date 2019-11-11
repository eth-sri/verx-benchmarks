contract Spec{
// The wallet of the crowdsale cannot be modified
property spec5 {
    always((SampleCrowdsale._wallet == RefundEscrow._beneficiary) 
            && (SampleCrowdsale._wallet == 0x5555555555555555555555555555555555555555));
        // Extra predicates
        (SampleCrowdsale._escrow == RefundEscrow);
        (RefundEscrow._primary == SampleCrowdsale);
        (SampleCrowdsale._token == SampleCrowdsaleToken);
        (SampleCrowdsaleToken._name == "Sample Crowdsale Token");
        (SampleCrowdsaleToken._symbol == "SCT");
}
}
