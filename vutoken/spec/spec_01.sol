contract Spec{

    property spec_01{

        always(PresaleCrowdsale.tokensSold <= PresaleCrowdsale.phases[2].limit);

        // Extra predicates
        (VUToken.name == "VU TOKEN");

        (VUToken.symbol == "VU");
        (PresaleCrowdsale.tokenWallet == 0xDEADBEEF11111111111111111111111111111111);
        (PresaleCrowdsale.wallet == 0xDEADBEEF22222222222222222222222222222222);
        (PresaleCrowdsale.whitelist == Whitelist);

        (PresaleCrowdsale.phases[0].rate == 7500);
        (PresaleCrowdsale.phases[1].rate == 6900);
        (PresaleCrowdsale.phases[2].rate == 6300);

        (PresaleCrowdsale.phases[0].cap == 30000000000000000000000000);
        (PresaleCrowdsale.phases[1].cap == 40000000000000000000000000);
        (PresaleCrowdsale.phases[2].cap == 80000000000000000000000000);

        (PresaleCrowdsale.phases[0].limit == 30000000000000000000000000);
        (PresaleCrowdsale.phases[1].limit == 70000000000000000000000000);
        (PresaleCrowdsale.phases[2].limit == 150000000000000000000000000);

    }

}
