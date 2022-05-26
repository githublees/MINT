import { useWeb3React } from '@web3-react/core';
import styles from '../../styles/Metamask.scss';
import { InjectedConnector } from '@web3-react/injected-connector';
import { Web3Provider } from '@ethersproject/providers';
import { useEffect, useState, useCallback } from 'react';
import useMetaMask from '../../hook/MetamaskHook';
import { useNavigate } from 'react-router-dom';


const Metamask = ()=>{
    const { connect, disconnect, isActive, account, shouldDisable } = useMetaMask();
    const navigate = useNavigate();
    const [path, setPath] = useState(""); 
    
    const handelPath = useCallback(() => {
        setPath(localStorage.getItem('path'));

    }, [])
    
    useEffect(() => {
        handelPath()
    }, [handelPath])
    
    const click = ()=>{
        if(account.length>0){
            navigate(path);
        }
        console.log(path)
    }
    // const connectWalletHandler = async () => {     
    //     const { ethereum } = window;

    //     if (!ethereum) {
    //         window.open('https://metamask.io/download.html');
    //     }

    //     try {
    //         const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    //         if (accounts.length !== 0){
    //             const account = accounts[0];
    //             localStorage.setItem('account',{account});
    //             console.log("현재 연결된 지갑 주소 : ", account);
    //             return true;
    //         } else {
    //             console.log("현재 연결된 지갑 X");
    //             return false;
    //         }
            
    //     } catch (err) {
    //         console.log(err);
    //     }
    // }

    return(
        <div className="login-box" style={styles}>
            <img src="/image/logos_metamask-icon.png" alt="" className='matamask-icon'/>
            <div className='metamask-title'>MetaMask</div>
            <div className='metamask-content'>
                <div>서비스를 사용하시려면 <br /> 지갑과 연결이 필요합니다.</div>
                <div className='div-meta'>MetaMask 지갑에 연결하시겠습니까?</div>    
            </div>
            <div className='connect-button' onMouseDown={account&&account.length>0? disconnect : connect} onClick={click}> {account&&account.length>0? 'Disconnect' : 'connect'}</div>
        </div>
    );
}
export default Metamask;