contract Spec{
    property initial_supply{
        always((INIT && (BrickblockToken.predecessorAddress == 0x0)) ==> (BrickblockToken.totalSupply == (500000000 * (10 ** 18))));
    }
}
