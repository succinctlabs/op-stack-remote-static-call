# op-stack-remote-static-call

A showcase of how to use Op Stack's remote static call precompile.

To test this witih Foundry, follow these steps:

### Spin up Optimism devnet with remote static call precompile

`git clone optimism` repo and checkout the `feat/remote-static-call` branch. 
* `git clone https://github.com/puma314/optimism`
* `git checkout feat/test-remote-static-call`

Then run:
- `git submodule update --init --recursive`
- Run `make devnet-up-deploy` in the root of the repo.

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

Now that the devnet has been spun up, you have to deploy a contract to the devnet L1. To do this, you can run
* `forge script script/Deploy.s.sol --tc DeployL1 --broadcast`

Then you must deploy your contract on L2 that uses the remote static call RPC. To do this, you can run:
* `forge script script/Deploy.s.sol --tc DeployL2 --broadcast`

Finally, to interact with that contract, you can either use `cast` manually, or you can use another forge script:
* `forge script script/Deploy.s.sol --tc UseRemoteStaticCall --broadcast`

An example of using `cast` is below:

`cast call <CONTRACT_ADDRESS> "balanceOf(address)" 0x0000000000000000000000000000000000000001 --rpc-url l2` 
