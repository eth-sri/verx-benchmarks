contract Spec{
    property spec_03{
        always((prev(SUM(ICOCrowdsale.balances)) > SUM(ICOCrowdsale.balances)) ==> ((now > ICOCrowdsale.deliveryTime) || (now > ICOCrowdsale.closingTime)));
        // Extra predicates
        (VUToken.name == "VU TOKEN");
        (VUToken.symbol == "VU");
        (ICOCrowdsale.wallet == 0xDEADBEEF11111111111111111111111111111111);
        (ICOCrowdsale.tokenWallet == 0xDEADBEEF22222222222222222222222222222222);
        (ICOCrowdsale.whitelist == Whitelist);
    }
}
