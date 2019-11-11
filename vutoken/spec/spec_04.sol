contract Spec{
    property spec_04{
        always(!once(FUNCTION == VUToken.burn(uint256)) ==> (VUToken.totalSupply_ >= (1000000000 *  (10 ** 18))));
        // Extra predicates
        (VUToken.name == "VU TOKEN");
        (VUToken.symbol == "VU");
        (ICOCrowdsale.wallet == 0xDEADBEEF11111111111111111111111111111111);
        (ICOCrowdsale.tokenWallet == 0xDEADBEEF22222222222222222222222222222222);
        (ICOCrowdsale.whitelist == Whitelist);
    }
}
