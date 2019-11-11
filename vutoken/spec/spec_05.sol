contract Spec{
    property spec_05{
        always((FUNCTION == ICOCrowdsale.withdrawTokens()) ==> ((now > ICOCrowdsale.closingTime) && (now >= ICOCrowdsale.deliveryTime)));
        // Extra predicates
        (ICOCrowdsale.openingTime == 1525039200);
        (ICOCrowdsale.closingTime == 1530309600);
        (ICOCrowdsale.deliveryTime == 1530396000);
        (VUToken.name == "VU TOKEN");
        (VUToken.symbol == "VU");
        (ICOCrowdsale.wallet == 0xDEADBEEF11111111111111111111111111111111);
        (ICOCrowdsale.tokenWallet == 0xDEADBEEF22222222222222222222222222222222);
        (ICOCrowdsale.whitelist == Whitelist);
    }
}
