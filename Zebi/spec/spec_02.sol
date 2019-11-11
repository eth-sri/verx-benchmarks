contract Spec{
    property spec_02{
        always((prev(ZebiCoin.transferAllowed) != ZebiCoin.transferAllowed) ==> (msg.sender == ZebiCoin.owner));
    }
}
