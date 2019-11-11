contract Spec{
    property spec_03{
        always((MANAContinuousSale.started != true) ==> (MANAToken.owner == MANACrowdsale));
        // Extra predicates
        (MANACrowdsale.token == MANAToken);
        (MANACrowdsale.continuousSale == MANAContinuousSale);
        (MANAContinuousSale.owner == MANACrowdsale);
        (MANAToken.owner == MANACrowdsale);
        (MANAContinuousSale.token == MANAToken);
    }
}
