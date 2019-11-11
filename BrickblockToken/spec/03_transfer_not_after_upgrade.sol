contract Spec{
    property transfer_not_after_upgrade{
        always((FUNCTION == BrickblockToken.transfer(address, uint256)) ==> (once(FUNCTION == BrickblockToken.unpause())));
        // Extra predicates
        (BrickblockToken.paused == true);
    }
}
