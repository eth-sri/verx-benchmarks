contract Spec{
    property spec_02{
        always((ICOCrowdsale.tokensSold <= (450000000 *  (10 ** 18))));
        // Extra predicates
        (ICOCrowdsale.limit == (450000000 * (10 ** 18)));
        (ICOCrowdsale.wallet == 0xDEADBEEF11111111111111111111111111111111);
        (ICOCrowdsale.tokenWallet == 0xDEADBEEF22222222222222222222222222222222);
        (ICOCrowdsale.whitelist == Whitelist);
        (VUToken.name == "VU TOKEN");
        (VUToken.symbol == "VU");
    }
}
