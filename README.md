# VerX smart contract verification benchmarks

This repository contains the benchmarks used to evaluate the performance of the [VerX](https://verx.ch) verifier.

Details on the verification method behind VerX and the benchmarks are available in the following research paper:

- [VerX: Safety Verification of Smart Contracts](https://files.sri.inf.ethz.ch/website/papers/sp20-verx.pdf)   
Anton Permenev, Dimitar Dimitrov, Petar Tsankov, Dana Drachsler-Cohen, Martin Vechev    
[IEEE Symposium of Security and Privacy 2020](https://www.ieee-security.org/TC/SP2020/).

## Benchmarks structure

Each folder contains a single benchmark and contains the following:

- A file `main.sol` is the flattened Solidity file. Each Solidity file has a designated `Deployer` contract which specifies the initial state of the contract. Namely, the `Deployer` contract has a constructor that does not take any arguments and deploys all contracts part of the benchmark.
- A folder `specs` contains a safety specification specified in the VerX specification language. The syntax of the VerX specification language is available [here](http://verx.ch/docs/spec.html).
