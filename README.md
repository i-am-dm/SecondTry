# Private Ethereum Network Prototype

This project sets up a private Ethereum network using Geth with Clique Proof of Authority (PoA) consensus. It uses Docker containers to run a validator and two additional nodes, and includes scripts for network initialization and testing.

## Project Structure

- **genesis.json**: Custom genesis configuration file for the Ethereum network.
- **docker-compose.yml**: (Optional) Docker Compose file for managing containers.
- **start-network.sh**: Shell script to create the Docker network, initialize nodes, create and import the validator account, and start the Ethereum nodes.
- **tests.js**: Node.js test script using web3.js to perform basic network tests and smart contract deployment/interaction tests.
- **README.md**: This documentation file.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (and optionally Docker Compose)
- [Node.js](https://nodejs.org/) and npm

## Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone <repository-url>
   cd SecondTry
   ```

2. **Set Up the Network**

   Run the provided shell script to set up the Docker containers for the validator and nodes:

   ```bash
   bash start-network.sh
   ```

   This script will:
   - Create a Docker network named `ethereum` (if it doesn't exist).
   - Remove any existing data directories and create new ones for the validator and nodes.
   - Create a password file and generate a new validator account.
   - Update the genesis file with the new validator account.
   - Initialize and start the validator and two nodes using the specified Geth image (v1.13.14).

3. **Verify the Network**

   You can verify that the network is running by checking the validator logs:

   ```bash
   docker logs geth-validator
   ```

   The logs should show that blocks are being sealed and that the network is operating on chain ID 1999.

## Running Tests

1. **Install Dependencies**

   Install the `web3` package (if not already installed):

   ```bash
   npm install web3
   ```

2. **Run the Test Suite**

   Execute the test script:

   ```bash
   node tests.js
   ```

   The test suite performs:
   - Basic network tests: confirms client version, network ID, block production, and account retrieval.
   - A simple transaction: processes either a self-transfer or a transfer between accounts.
   - Smart contract deployment and interaction tests: deploys a simple HelloWorld contract, checks its initial state, updates it, and verifies the change.

## Future Improvements

- **Additional Testing:** Expand test suite to include peer connectivity (using admin_peers), event subscriptions (WebSocket events), and performance/stress tests.
- **Smart Contract Integration:** Deploy and interact with more complex smart contracts.
- **Monitoring & Logging:** Enhance network monitoring and logging mechanisms for easier troubleshooting.
- **CI/CD Integration:** Set up continuous integration (e.g., GitHub Actions) for automated testing on commits.
- **Improved Documentation:** Add further documentation as more features and tests are added.

## Troubleshooting

- If you encounter issues:
  - Check individual node logs, e.g., `docker logs geth-node1`.
  - Ensure Docker and Node.js are up-to-date.
  - Review configuration in the genesis file and environment variables.

## License

This project is licensed under the MIT License. 