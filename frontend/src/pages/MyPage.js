import { useEffect, useState, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import styles from "../styles/MyPage.module.scss";
import { ethers } from "ethers";
import contract from '../smartcontract/TileFactory.json'

const MyPage= ( ) => {
    const [dibbedLands, setDibbedLands] = useState([]);
    const [boughtPlanets, SetBoughtPlanets] = useState([]);
    const username = "username";
    const abi = contract.abi;
    const contractAddress = "0x37B92D4960c8CE8fDaBDf3d5bB1FE4438e25cB4E"

    const contractCall = useCallback(async () => {
        try {
            const { ethereum } = window;
            

            if ( ethereum ){
                const provider = new ethers.providers.Web3Provider(ethereum);
                const signer = provider.getSigner();
                const nftContract = new ethers.Contract(contractAddress, abi, signer);

                console.log("컨트랙트 연결!");
                const nftTxn = await nftContract.connect(signer).getMyTile();

                console.log(nftTxn.length);
                console.log(nftTxn);

                const boughtPlanetsRes = new Set();

                await nftTxn.map((item, idx) => (
                    boughtPlanetsRes.add(item.planetName)
                ))

                console.log(boughtPlanetsRes);

                const boughtPlanetArr = Array.from(boughtPlanetsRes);

                console.log(boughtPlanetArr);
                SetBoughtPlanets(boughtPlanetArr);

            } else {
                console.log("metamast 연결 X")
            }
        }
        catch (error) {
            console.log(error);
        }
    },[])

    useEffect(() => {

        contractCall();

        /*const dibbedLandsRes = [
            {
                planetId: 1,
                planetName: "Teegarden_b",
                imgSrc: "../../planet_ex.png",
                landId: "A-001",
            },
            {
                planetId: 1,
                planetName: "Teegarden_b",
                imgSrc: "../../planet_ex.png",
                landId: "A-002",
            },
            {
                planetId: 1,
                planetName: "Teegarden_b",
                imgSrc: "../../planet_ex.png",
                landId: "A-003",
            },
            {
                planetId: 1,
                planetName: "Teegarden_b",
                imgSrc: "../../planet_ex.png",
                landId: "A-004",
            },
            {
                planetId: 1,
                planetName: "Teegarden_b",
                imgSrc: "../../planet_ex.png",
                landId: "A-005",
            },
        ]
        setDibbedLands(dibbedLandsRes);*/

    }, [contractCall]);

    const navigate = useNavigate();

    return (
       <main className={styles.MyPage}>
           <header>
                <h1>{username}</h1>
                <button className={styles.ProfileEditBtn}>회원정보수정</button>
           </header>
           <div className={styles.MyPageInfo}>
                <section className={styles.MyReceipts}>
                    <h2>구매 내역</h2>
                    <div className={`${styles.ProfileBox} Box`}>
                            <ul className={styles.ProfileBox__inner}>
                                {
                                    boughtPlanets.map((planetName, idx) => (
                                        <li className={styles.ProfileBox__item} onClick={() => navigate(`/mypage/${planetName}`)} key={idx}>
                                            <img src="../../planet_ex.png" alt={`bought-planet-${idx}`} className={styles.planetImg} />
                                            <p className={styles.planetName}>{planetName}</p>
                                        </li>
                                    ))
                                }
                            </ul>
                    </div>
                </section>

                <section className={styles.MyDibbedLands}>
                    <h2>내가 찜한 땅</h2>
                    <div className={`${styles.ProfileBox} Box`}>
                            <ul className={styles.ProfileBox__inner}>
                                {
                                    dibbedLands.map((item, idx) => (
                                        <li className={styles.ProfileBox__item} key={idx}>
                                            <img src={item.imgSrc} alt="planet" className={styles.planetImg} />
                                            <p className={styles.planetName}>{item.planetName}</p>
                                            <p className={styles.landName}>{item.landId}</p>
                                        </li>
                                    ))
                                }
                            </ul>
                    </div>
                </section>
           </div>

        </main>
    );
}
export default MyPage;