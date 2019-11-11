contract Spec{
    property spec_05{
        always((prev(ICO.icoState) == 4) ==> (ICO.icoState == 4));
        // Extra predicates
        (ICO.optionProgram == GVOptionProgram);
        (ICO.gvToken == GVToken);
        (GVToken.ico == ICO);
        (GVOptionProgram.gvOptionToken10 == GVOptionToken2);
        (GVOptionProgram.gvOptionToken20 == GVOptionToken1);
        (GVOptionProgram.gvOptionToken30 == GVOptionToken0);
        (GVOptionToken0.optionProgram == GVOptionProgram);
        (GVOptionToken1.optionProgram == GVOptionProgram);
        (GVOptionToken2.optionProgram == GVOptionProgram);

        (GVOptionToken0.name ==  "30% GVOT");
        (GVOptionToken0.symbol ==  "GVOT30");

        (GVOptionToken1.name ==  "20% GVOT");
        (GVOptionToken1.symbol ==  "GVOT20");

        (GVOptionToken2.name ==  "10% GVOT");
        (GVOptionToken2.symbol ==  "GVOT10");
    }
}
