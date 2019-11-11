contract Spec{
    property spec_05{
        always(((ZebiCoin.transferAllowed == false) && (msg.sender != ZebiCoin.owner)) ==> (ZebiCoin.balances[0x321] == prev(ZebiCoin.balances[0x321])));
    }
}
