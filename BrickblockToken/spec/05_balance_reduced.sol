contract Spec{
    property balance_reduced{
        always(FUNCTION == BrickblockToken.distributeTokens(address,uint256)) ==> (prev(BrickblockToken.balances[BrickblockToken]) >= BrickblockToken.balances[BrickblockToken] );
    }
}
