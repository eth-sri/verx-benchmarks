contract Spec{
    property spec_01{
        always(INIT ==> (ZebiCoin.owner == ZebiCoinCrowdsale) );
        // Extra predicates
        (ZebiCoinCrowdsale.wallet == 0x123);
        (ZebiCoinCrowdsale.token == ZebiCoin);
        (ZebiCoin.owner == ZebiCoinCrowdsale);
    }
}
