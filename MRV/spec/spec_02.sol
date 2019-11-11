contract Spec{
    property spec_02{
        always((MRVToken.crowdsaleEnded ==  true) ==> (MRVToken._totalSupply ==  prev(MRVToken._totalSupply)));
    }
}
