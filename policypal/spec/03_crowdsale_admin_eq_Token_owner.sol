contract Spec{
    property crowdsale_admin_eq_Token_owner{
        always((!once(FUNCTION == PolicyPalNetworkToken.transferOwnership(address))) ==> (PolicyPalNetworkCrowdsale.admin == PolicyPalNetworkToken.owner));
        // Extra predicates
        (PolicyPalNetworkToken.owner == PolicyPalNetworkCrowdsale);
        (PolicyPalNetworkToken.owner == 0xabc1111111111111111111111111111111111111);
        (PolicyPalNetworkCrowdsale.token == PolicyPalNetworkToken);
        (PolicyPalNetworkCrowdsale.multiSigWallet == 0xabc2222222222222222222222222222222222222);
        (PolicyPalNetworkCrowdsale.admin == 0xabc1111111111111111111111111111111111111);
    }
}
