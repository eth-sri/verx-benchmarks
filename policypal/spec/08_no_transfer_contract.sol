contract Spec{
    property no_transfer_contract{
        always((FUNCTION == PolicyPalNetworkCrowdsale.buy(address)) ==> (msg.sender != PolicyPalNetworkCrowdsale));
        // Extra predicates
        (PolicyPalNetworkToken.owner == PolicyPalNetworkCrowdsale);
        (PolicyPalNetworkToken.owner == 0xabc1111111111111111111111111111111111111);
        (PolicyPalNetworkCrowdsale.token == PolicyPalNetworkToken);
        (PolicyPalNetworkCrowdsale.multiSigWallet == 0xabc2222222222222222222222222222222222222);
        (PolicyPalNetworkCrowdsale.admin == 0xabc1111111111111111111111111111111111111);
    }
}
