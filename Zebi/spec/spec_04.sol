contract Spec{
    property spec_04{
        always(SUM(ZebiCoin.balances) == ZebiCoin.totalSupply_);
    }
}
