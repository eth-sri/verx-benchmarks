contract Spec{
    property spec_01{
        always((MRVToken.crowdsaleStarted ==  true) ==> (MRVToken.maxCrowdsaleSupplyInWholeTokens ==  prev(MRVToken.maxCrowdsaleSupplyInWholeTokens)));
        // Extra predicates
        (MRVToken.beneficiary == 0xCAB1111111111111111111111111111111111111);
    }
}
