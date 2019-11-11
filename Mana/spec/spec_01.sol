contract Spec{
    property spec_01{
        always(MANAContinuousSale.bucketAmount <= MANAContinuousSale.issuance);
        // Extra predicates
        (MANAContinuousSale.token == MANAToken);
        (MANACrowdsale.token == MANAToken);
        (MANACrowdsale.continuousSale == MANAContinuousSale);
        (MANAContinuousSale.started == true);
        (MANAContinuousSale.bucketAmount == 0);
        (MANAToken.totalSupply == 0);
    }
}
