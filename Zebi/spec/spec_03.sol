contract Spec{
    property spec_03{
        always((prev(ZebiCoinCrowdsale.withinRefundPeriod) != ZebiCoinCrowdsale.withinRefundPeriod) ==> (msg.sender == ZebiCoinCrowdsale.owner));
        // Extra predicates
        (ZebiCoinCrowdsale.wallet == 0x123);
        (ZebiCoinCrowdsale.token == ZebiCoin);
    }
}
