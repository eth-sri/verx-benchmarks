contract Spec{
    property spec_03{
        always(MRVToken._totalSupply ==  SUM(MRVToken._balances));
    }
}
