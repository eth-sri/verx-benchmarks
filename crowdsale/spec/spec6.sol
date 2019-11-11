contract Spec{
// The balance of the escrow contract increases with the amount
// of ether sent by users to buy tokens
    property spec6 {
        always(
            (FUNCTION == SampleCrowdsale.buyTokens(address)) ==>
            (BALANCE(RefundEscrow) >= (prev(BALANCE(RefundEscrow)) + msg.value))
        );
        // Extra predicates
        (SampleCrowdsale._escrow == RefundEscrow);
        (RefundEscrow._primary == SampleCrowdsale);
        (SampleCrowdsale._token == SampleCrowdsaleToken);
        (SampleCrowdsaleToken._name == "Sample Crowdsale Token");
        (SampleCrowdsaleToken._symbol == "SCT");
    }
}
