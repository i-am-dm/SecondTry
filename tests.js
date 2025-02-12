const Web3Constructor = require('web3');
const Web3 = Web3Constructor.default ? Web3Constructor.default : Web3Constructor;
const assert = require('assert');

// Connect to the validator RPC endpoint
const web3 = new Web3('http://localhost:8545');

(async () => {
  try {
    // Get client version
    const clientVersion = await web3.eth.getNodeInfo();
    console.log('Client version:', clientVersion);

    // Get network ID and check that it is 1999 (handled as number)
    const networkId = await web3.eth.net.getId();
    console.log('Network ID:', networkId);
    assert.strictEqual(Number(networkId), 1999, 'Network ID should be 1999');

    // Check current block number (should be > 0 if blocks are being sealed)
    const blockNumber = await web3.eth.getBlockNumber();
    console.log('Current block number:', blockNumber);
    assert(blockNumber >= 1, 'At least one block should have been mined');

    // Get details of the latest block
    const block = await web3.eth.getBlock(blockNumber);
    console.log('Latest block:', block);
    assert(block !== null, 'Latest block should not be null');

    // Retrieve accounts from the node
    const accounts = await web3.eth.getAccounts();
    console.log('Accounts:', accounts);
    assert(accounts.length > 0, 'There should be at least one unlocked account');

    // Send a simple transaction
    let receipt;
    if (accounts.length > 1) {
      console.log('Sending transaction from first account to second account...');
      receipt = await web3.eth.sendTransaction({
        from: accounts[0],
        to: accounts[1],
        value: web3.utils.toWei('0.01', 'ether')
      });
    } else {
      console.log('Sending self-transaction from the first account...');
      receipt = await web3.eth.sendTransaction({
        from: accounts[0],
        to: accounts[0],
        value: web3.utils.toWei('0.01', 'ether')
      });
    }
    console.log('Transaction receipt:', receipt);
    assert(receipt.status, 'Transaction should be successful');

    console.log('All tests passed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Test failed:', error);
    process.exit(1);
  }
})(); 