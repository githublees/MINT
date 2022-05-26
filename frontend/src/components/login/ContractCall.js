import { useWeb3React } from '@web3-react/core';
import styles from '../../styles/Metamask.scss';
import {InjectedConnector} from '@web3-react/injected-connector';
import { Web3Provider } from '@ethersproject/providers';
import { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import contract from '../../smartcontract/TileFactory.json'

const ContractCall = ()=>{

    const abi = contract.abi;
    const contractAddress = process.env.REACT_APP_CONTRACT_ADDRESS;

    const contractCallSample = async () => { // <컨트랙트 함수 연결 샘플 코드> npm install ether 및 import { ethers } from 'ethers'; 필요
        try {
            const { ethereum } = window;

            if ( ethereum ){
                const provider = new ethers.providers.Web3Provider(ethereum);
                const signer = provider.getSigner();
                const nftContract = new ethers.Contract(contractAddress, abi, signer);

                console.log("컨트랙트 연결");
                let nftTxn = await nftContract.ownerOf(1);

                //console.log("함수 호출 중");
                await nftTxn.wait();

                console.log(nftTxn);
            } else {
                console.log("metamast 연결 X")
            }
        }
        catch (error) {
            console.log(error);        
        }
    }

    return(
        <div className="login-box" style={styles}>
            <img src="/image/logos_metamask-icon.png" alt="" className='matamask-icon'/>
            <div className='metamask-title'>MetaMask</div>
            <div className='metamask-content'>
                <div>함수 호출 예시</div>
                <div style={{"margin-top":"1.5vh"}}>지정한 함수를 호출하시겠습니까?</div>    
            </div>
            <div className='connect-button' onClick={contractCallSample}>호출</div>
        </div>
    );
}
export default ContractCall;