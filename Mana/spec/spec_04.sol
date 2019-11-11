contract Spec{
    property spec_04{
        always((MANAContinuousSale.started == true) ==> (MANAToken.owner == MANAContinuousSale));
        // Extra predicates
        (MANAContinuousSale.owner == MANACrowdsale);
        (MANAToken.owner == MANACrowdsale);
        (MANAContinuousSale.token == MANAToken);
        (MANACrowdsale.token == MANAToken);
        (MANACrowdsale.continuousSale == MANAContinuousSale);
    }
}
