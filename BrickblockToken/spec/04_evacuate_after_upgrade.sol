contract Spec{
    property evacuate_after_upgrade{
        always((FUNCTION == BrickblockToken.evacuate(address)) ==> (once(FUNCTION == BrickblockToken.upgrade(address))));
        // Extra predicates
        (BrickblockToken.dead == false);
    }
}
