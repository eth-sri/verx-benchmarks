contract Spec{
    property spec_02{
        always((MANACrowdsale.isFinalized == true) ==> ((MANACrowdsale.weiRaised >= MANACrowdsale.cap) || (block.number > MANACrowdsale.endBlock) ));
        // Extra predicates
        (block.number > MANACrowdsale.endBlock);
        (block.number > prev(MANACrowdsale.endBlock));
        (MANAContinuousSale.token == MANAToken);
        (MANACrowdsale.token == MANAToken);
        (MANACrowdsale.continuousSale == MANAContinuousSale);
    }
}
