import React from 'react';
import ReactDOM from 'react-dom';
import './styles/style.scss';
import AppRouter from './Router'
import reportWebVitals from './reportWebVitals';
import { Web3Provider } from '@ethersproject/providers';
import { Web3ReactProvider } from '@web3-react/core';
import { MetaMaskProvider } from './hook/MetamaskHook'

function getLibrary(provider) {
  const library = new Web3Provider(provider, "any");
  return library;
}

ReactDOM.render(
  <React.StrictMode>
    <Web3ReactProvider getLibrary={getLibrary}>
      <MetaMaskProvider>
        <AppRouter/>
      </MetaMaskProvider>
    </Web3ReactProvider>
  </React.StrictMode>,
  document.getElementById('root')
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();