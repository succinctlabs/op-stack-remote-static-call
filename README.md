# op-stack-remote-static-call

A showcase of how to use Op Stack's remote static call precompile.

To test this witih Foundry, follow these steps:

### Spin up Optimism devnet with remote static call precompile

`git clone optimism` repo and checkout the `feat/remote-static-call` branch

- `git submodule update --init --recursive`
- Run `make devnet-up-deploy` in the root of the repo.

If you want to vary which "L1" remote static call quries, change the hard-coded archive node RPC url to: INSERT HERE.

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
* `forge script script/Deploy.s.sol --rpc-url <DEVNET_RPC_URL>`

To interact with the contract, you can use `cast`. Run

`cast call ...` <TODO>

## Development Process

In general, this documents the development process for developing the remote static call precompile, which should serve as a useful guide to other's want to modify the OP stack.

#### Modify `op-geth`

Modify op-geth by forking it and making whatever changes are needed. An example PR of adding the remote static call precompile is [here](https://github.com/ethereum-optimism/op-geth/pull/114).

#### End-to-end testing with `op-e2e` and custom `op-geth`

The next step is to test Optimism end-to-end with your custom `op-geth`. To do this, fork the Optimism monorepo and follow these steps:

- Change the `go.mod` to point to your local `op-geth` folder (by editing the `replace` at the bottom of the file).
- Run `make install-geth` at the top-level of the directory
- Run `make clean`
- In case you get an error, you might have to also run: `brew install jq`
- To test the local op-e2e, go into that folder and run `make test`.

You might also want to add a test in the `op-e2e` folder that spins up `op-geth` in memory. An example of a PR that does this for remote static call is this: TODO INSERT HERE.

#### To run a devnet with a modified `op-geth`

The devnet is run through a docker-compose: https://github.com/ethereum-optimism/optimism/blob/develop/ops-bedrock/docker-compose.yml.

To run a devnet with a custom `op-geth`, you have to do the following steps:
- Generate a image from your local `op-geth` by running `docker build -f Dockerfile . --tag REPO/IMAGE:TAG` and upload this image to publicly availably container registry (can do this with `docker push REPO/IMAGE` to the docker hub)
- Modify the L2 dockerfile to point to a image that you have: https://github.com/ethereum-optimism/optimism/blob/develop/ops-bedrock/Dockerfile.l2

- Start the devnet with the following instructions: https://github.com/ethereum-optimism/optimism/blob/develop/bedrock-devnet/README.md which says to run `make devnet-up-deploy` from the root of the repo.

**Common Pitfalls**
* Remember to change back the replace to your local op-geth in the `go.mod` to the original `op-geth` implementation when trying to run the devnet


**Debug Session with Mark**
* Can't run this devnet when I switch back the replace to not-local and can't run it with the replace to local op-geth
* The e2e test I added fails because the `http` endpoint that I get is just `http://` so it's useless