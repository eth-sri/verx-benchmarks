contract Spec{
    property no_ether_transfer{
        always( (BrickblockToken.dead == true) ==> (BrickblockToken.paused == true));
    }
}
