module.exports = {
  networks: {
    development: {
      host: "0.0.0.0",    // Adresse correcte pour Codespaces
      port: 8545,         // Port utilisé par Ganache
      network_id: "*",    // N'importe quel réseau
    },
  },
  compilers: {
    solc: {
      version: "0.8.0",   // Version spécifique du compilateur Solidity
    },
  },
};