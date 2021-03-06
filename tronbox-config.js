const port = process.env.HOST_PORT || 9090;

module.exports = {
	networks: {
		//     mainnet: {
		//       // Don't put your private key here:
		//       privateKey: process.env.PRIVATE_KEY_MAINNET,
		//       /*
		// Create a .env file (it must be gitignored) containing something like

		//   export PRIVATE_KEY_MAINNET=4E7FECCB71207B867C495B51A9758B104B1D4422088A87F4978BE64636656243

		// Then, run the migration with:

		//   source .env && tronbox migrate --network mainnet

		// */
		//       userFeePercentage: 100,
		//       feeLimit: 1e8,
		//       fullHost: 'https://api.trongrid.io',
		//       network_id: '1'
		//     },
		shasta: {
			privateKey: 'c82d26b7013c73c4481f8dd4d35140a637287fd9680b1a3101dad264089d4a7d',
			userFeePercentage: 50,
			feeLimit: 1e8,
			fullHost: 'https://api.shasta.trongrid.io',
			network_id: '2'
		},
		// nile: {
		//   privateKey: process.env.PRIVATE_KEY_NILE,
		//   fullNode: 'https://httpapi.nileex.io/wallet',
		//   solidityNode: 'https://httpapi.nileex.io/walletsolidity',
		//   eventServer: 'https://eventtest.nileex.io',
		//   network_id: '3'
		// },
		// development: {
		// 	// For trontools/quickstart docker image
		// 	privateKey: 'c82d26b7013c73c4481f8dd4d35140a637287fd9680b1a3101dad264089d4a7d',
		// 	userFeePercentage: 0,
		// 	feeLimit: 1e8,
		// 	fullHost: 'http://127.0.0.1:' + port,
		// 	network_id: '9'
		// },
		compilers: {
			solc: {
				version: '0.5.10'
			}
		}
	}
};
