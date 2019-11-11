contract Spec{
    property sum_Token_balances_eq_totalSupply{
        always(SUM(PolicyPalNetworkToken.balances) == PolicyPalNetworkToken.totalSupply_);
        // Extra predicates
        (PolicyPalNetworkCrowdsale.token == PolicyPalNetworkToken);
        (PolicyPalNetworkToken.owner == PolicyPalNetworkCrowdsale);
        (PolicyPalNetworkCrowdsale.multiSigWallet == 0xabc2222222222222222222222222222222222222);
        (PolicyPalNetworkCrowdsale.admin == 0xabc1111111111111111111111111111111111111);
        (PolicyPalNetworkToken.owner == 0xabc1111111111111111111111111111111111111);
    }
}
