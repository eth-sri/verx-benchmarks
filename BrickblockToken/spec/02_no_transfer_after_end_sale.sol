contract Spec{
    property no_transfer_after_end_sale{
        always((FUNCTION == BrickblockToken.distributeTokens(address, uint256)) ==> (! once(FUNCTION == BrickblockToken.finalizeTokenSale())));
        // Extra predicates
        (BrickblockToken.owner == prev(BrickblockToken.owner));
        (BrickblockToken.tokenSaleActive == true);
    }
}
