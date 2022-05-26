import { Outlet } from "react-router-dom";
import Sidebar from "./components/navbar/Sidebar";
import SidebarUSer from "./components/navbar/SidebarUser";
import SidebarAdmin from "./components/navbar/SidebarAdmin";
import { useEffect, useState } from "react";
import { useLocation,useNavigate } from "react-router-dom";
import useMetaMask from './hook/MetamaskHook';

import { ethers } from 'ethers';
import contract from './smartcontract/TileFactory.json';


const App = ( ) => {
    const navigate = useNavigate();
    const { pathname } = useLocation();

    const [myWeb3, setMyWeb3] = useState({});
    const { connect, disconnect, isActive, account, shouldDisable } = useMetaMask();

    useEffect(() => {
      if (pathname === '/') {
        navigate('/home');
        localStorage.setItem("path",'/home');
      }

      const abi = contract.abi;
      const contractAddress = process.env.REACT_APP_CONTRACT_ADDRESS;
      // const contractAddress = "0x58A1E6FFf914C23011A3fF99CdE84E7DaD3D82AC";
      console.log("contractAddress::::::", contractAddress);

      try {
          const { ethereum } = window;
          console.log("web3 객체 생성!!!!!!!!!!!!!!!!!!!!")

          if ( ethereum ){
              const provider = new ethers.providers.Web3Provider(ethereum);
              const signer = provider.getSigner();
              const nftContract = new ethers.Contract(contractAddress, abi, signer);
              
              setMyWeb3({
                provider: provider,
                signer: signer,
                nftContract: nftContract
              });

              console.log("컨트랙트 연결");

          } else {
              console.log("metamast 연결 X")
          }
        localStorage.setItem("path",{pathname});
      }
      catch (error) {
          console.log(error);        
      }

    }, []);

    return(
        <div style={{height:"100%"}}>
         {account&&account.length>0 ? (account === "0xF385B773f16722eEC8932A19224b7095c7928c2f" ? <SidebarAdmin/>:<SidebarUSer/>):<Sidebar/>}
            {/* <SidebarUSer/> */}
            {/* <SidebarAdmin/> */}
            <Outlet context={myWeb3} />

        </div>
    );
}
export default App;