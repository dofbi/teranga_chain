# Utiliser une image officielle Node.js
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-18

# Installer Truffle et Ganache globalement
RUN npm install -g truffle ganache-cli

# Définir le répertoire de travail
WORKDIR /workspace

# Exposer le port utilisé par Ganache
EXPOSE 8545

# Exécuter Ganache en arrière-plan lorsque le conteneur démarre
CMD ["ganache-cli", "--host", "0.0.0.0"]