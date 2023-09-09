# op-stack-remote-static-call

A showcase of how to use Op Stack's remote static call precompile.

To test this witih Foundry, follow these steps:

### Spin up Optimism devnet with remote static call precompile

`git clone optimism` repo and checkout the `feat/remote-static-call` branch

- `git submodule update --init --recursive`
- Run `make devnet-up-deploy` in the root of the repo.

If you want to vary which "L1" remote static call quries, change the hard-coded archive node RPC url in this file [here](https://github.com/ethereum-optimism/optimism/pull/7147/files#diff-ca4764bab3f68b2e30e32063c6c7e5bd375afbff7ad82cd17fe6fd37753e9d2cR52). Right now it's hardcoded to a default RPC that likely won't work for a lot of use-cases.

**Common Errors:**

If you get the following error, make sure you ran `git submodule update --init --recursive`

```
Error:
Failed to resolve file: ".../optimism/packages/contracts-bedrock/lib/forge-std/src/Script.sol": No such file or directory (os error 2).
Check configured remappings..
--> ".../optimism/packages/contracts-bedrock/scripts/Deploy.s.sol"
"forge-std/Script.sol"
Traceback (most recent call last):
```

### Deploy contract to Optimism devnet using devnet RPC

Now that the devnet has been spun up, you have to deploy your contract to the devnet. To do this, you can run
* `forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:9545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast`

To interact with the contract, you can use `cast`. Run

`cast call <CONTRACT_ADDRESS> "balanceOf(address)" 0x2573c60a6d127755aa2dc85e342f7da2378a0cc5 --rpc-url http://127.0.0.1:9545` 

The above will get the `balanceOf` the `nounders.eth` address.

You can also try:

`cast call <CONTRACT_ADDRESS> ownerOf(uint256) 1`
