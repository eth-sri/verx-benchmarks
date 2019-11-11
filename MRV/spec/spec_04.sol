contract Spec{
    property spec_04{
        always((prev(MRVToken.crowdsaleStarted) ==  true) ==> (MRVToken.crowdsaleStarted ==  true));
    }
}
