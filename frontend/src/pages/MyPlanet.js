import { useEffect, useState, useCallback } from 'react';
import { useParams } from 'react-router-dom';
import styles from '../styles/MyPlanet.module.scss';
import { VscChevronUp, VscChevronDown } from 'react-icons/vsc';

import Planet from '../components/Planet';
import Land from '../components/Land';
import axios from 'axios';

import { ethers } from 'ethers';
import contract from '../smartcontract/TileFactory.json';

const MyPlanet = () => {
  const { planetName } = useParams();
  const [myPlanet, setMyPlanet] = useState([]);
  const [boughtTilesObj, SetBoughtTilesObj] = useState([]);
  
  
  const mappingPid = new Map([
    ['Teegarden_b', 9],
    ['Kepler_1649c', 10],
    ['Ross_128b', 11],
    ['Kepler_22b', 12],
    ['Proxima_B', 13],
  ]);

  const abi = contract.abi;
  const contractAddress = process.env.REACT_APP_CONTRACT_ADDRESS;
  const planetCall = useCallback(async () => {
    const pid = mappingPid.get(planetName);
    await axios
      .get(process.env.REACT_APP_SERVER_URL + '/api/planet/' + pid, {})
      .then((res) => {
        const planetRes = res.data;
        setMyPlanet(planetRes);
      });
  }, []);

  const contractCall = useCallback(async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const nftContract = new ethers.Contract(contractAddress, abi, signer);

        // console.log("컨트랙트 연결!");
        const nftTxn = await nftContract.connect(signer).getMyTile();

        const filteredTxn = nftTxn.filter(
          (item) => item.planetName === planetName
        );
        console.log(filteredTxn, 'filter');

        filteredTxn.map(
          async (arr, idx) =>
            await axios
              .get(
                process.env.REACT_APP_SERVER_URL + `/api/tile/${arr.tileName}`,
                {}
              )
              .then((res) => {
                const tileRes = res.data;
                // console.log(tileRes);
                SetBoughtTilesObj((oldArray) => [...oldArray, tileRes]);
              })
              .catch((error) => {
                console.log(error);
              })
        );
        console.log(boughtTilesObj, 'obj');
      } else {
        console.log('metamast 연결 X');
      }
    } catch (error) {
      console.log(error);
    }
  }, []);

  useEffect(() => {
    planetCall();
    contractCall();
  }, [planetCall, contractCall]);

  return (
    <main className={`${styles.MyPlanet}`}>
      <h1>{myPlanet && myPlanet.name} 구매 정보</h1>
      {console.log(boughtTilesObj)}
      <div className={styles.myPlanetInfoWrapper}>
        <div className={styles.myPlanetWrapper}>
          <Planet {...myPlanet} />
        </div>
        <div className={`Box ${styles.myLandsWrapper}`}>
          <ul className={styles.myLands__inner}>
            {
              <li key={`myLand-item-1`} className={styles.myLandItem}>
                {boughtTilesObj.map((tiles, idx) => (
                  <details>
                    <summary className={styles.landItemSummary}>
                      {tiles.image ? (
                        <img
                          className={`${styles.landImg} ${styles.landImgO}`}
                          src={`http://j6a106.p.ssafy.io/api/image/display?filename=${tiles.image}`}
                          alt="landImg"
                        />
                      ) : (
                        <div className={styles.landImg} />
                      )}
                      {tiles.tid}
                      <VscChevronDown className={styles.arrowDown} />
                    </summary>
                    <Land {...{ ...tiles, ...{ version: 'card-mypage' }, ...{pid: mappingPid.get(planetName)} }} />
                  </details>
                ))}
              </li>
            }
          </ul>
        </div>
      </div>
    </main>
  );
};
export default MyPlanet;
