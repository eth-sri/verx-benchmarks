contract Spec{
    property spec6 {
            always(
                ((FUNCTION == Token.transferFrom(address,address,uint256)) && (Token.transferFrom(address,address,uint256)[0] != Token.transferFrom(address,address,uint256)[1]))
                    ==> (
                            (Token._balances[Token.transferFrom(address,address,uint256)[0]] 
                                == prev(Token._balances[Token.transferFrom(address,address,uint256)[0]]) - Token.transferFrom(address,address,uint256)[2])
                            && 
                            (Token._balances[Token.transferFrom(address,address,uint256)[1]] 
                                == prev(Token._balances[Token.transferFrom(address,address,uint256)[1]]) + Token.transferFrom(address,address,uint256)[2])
                            &&
                            (prev(Token._allowances[Token.transferFrom(address,address,uint256)[0]][msg.sender]) >= Token.transferFrom(address,address,uint256)[2])
                            &&
                            (Token._allowances[Token.transferFrom(address,address,uint256)[0]][msg.sender] == 
                                prev(Token._allowances[Token.transferFrom(address,address,uint256)[0]][msg.sender]) - Token.transferFrom(address,address,uint256)[2])
                        )
            );
        // Extra predicates
        (Token._name == "Sample Token");
        (Token._symbol == "STK");
    }
}
