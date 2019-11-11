contract Spec{
    property same_wei_after_end{
        always((now > PolicyPalNetworkCrowdsale.saleEndTime) ==> (prev(PolicyPalNetworkCrowdsale.raisedWei) == PolicyPalNetworkCrowdsale.raisedWei));
        // Extra predicates
        (PolicyPalNetworkToken.owner == PolicyPalNetworkCrowdsale);
        (PolicyPalNetworkToken.owner == 0xabc1111111111111111111111111111111111111);
        (PolicyPalNetworkCrowdsale.token == PolicyPalNetworkToken);
        (PolicyPalNetworkCrowdsale.multiSigWallet == 0xabc2222222222222222222222222222222222222);
        (PolicyPalNetworkCrowdsale.admin == 0xabc1111111111111111111111111111111111111);
    }
}
