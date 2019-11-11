contract Spec{
    property spec_05{
        always((prev(MRVToken.crowdsaleEnded) ==  true) ==> (MRVToken.crowdsaleEnded ==  true));
    }
}
