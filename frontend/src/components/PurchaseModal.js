import PurchaseBtnSection from "./PurchaseBtnSection";
import styles from "../styles/PurchaseModal.module.scss";
import { VscChromeClose } from "react-icons/vsc";
import { useState, useEffect } from "react";
import shortenWalletAddr from "./utils/shortenWalletAddr";

import { ethers } from 'ethers';
import axios from 'axios';
import Big from "big.js";

import Lottie from 'react-lottie';
import Mint_Lodo from '../lottie/Mint_Logo_Long_Font.json';
import { useNavigate } from "react-router-dom";

const PurchaseModal = ({ show, onHide, itemsToBuy, myWeb3, isBuyDirect, contractTileInfo }) => {
    // console.log("PurchaseModal Created")
    const [myWalletAddr, setMyWalletAddr] = useState();
    const [isWaiting, setIsWaiting] = useState(false);
    const [isDone, setIsDone] = useState(false);

    const lottieOptions = {
        animationData: Mint_Lodo,
        loop: true,
        autoplay: true,
        rendererSettings: {
          className: 'add-class', // svg에 적용
          preserveAspectRatio: 'xMidYMid slice',
        },
    };

    const navigate = useNavigate();

    const BASE_URL = process.env.REACT_APP_SERVER_URL;

    useEffect(() => {
        const { ethereum } = window;
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        signer.getAddress()
        .then((res) => {
            setMyWalletAddr(res);
        })
    }, []);

    const sleep = (milliseconds) => {
        console.log("waiting...");
        return new Promise(resolve => setTimeout(resolve, milliseconds))
    }

    const buy = async () => {
        console.log("구매!")
        const { ethereum } = window;
        const provider = new ethers.providers.Web3Provider(ethereum);

        // 구매 함수 호출
        try {
            setIsWaiting(true);

            const bool = contractTileInfo && contractTileInfo.price && !contractTileInfo.assurance;
            console.log(bool)

            for (const item of itemsToBuy) {
                const priceInWei = ethers.utils.parseEther(String(item.price))._hex;
                console.log(priceInWei)
                // const price = item.price * 10**18;
                console.log(item.planet.data.galaxy, item.planet.data.name, item.tid, priceInWei)

                let res;
                if (bool) {
                    console.log("buy!!!")
                    res = await myWeb3.nftContract.buy(item.tokenId,  { value: priceInWei});
                } else {
                    console.log("create and buy!!!")
                    res = await myWeb3.nftContract.createAndBuy(item.planet.data.galaxy, item.planet.data.name, item.tid, priceInWei, { value: priceInWei});
                }
                
                const hash = res.hash;
                
                // minig 끝날 때까지 기다리기
                let transactionReceipt = null
                while (transactionReceipt == null) { // Waiting expectedBlockTime until the transaction is mined
                    transactionReceipt = await provider.getTransactionReceipt(hash);    //transactonHash
                    await sleep(1000)    // expectedBlockTime
                }
                console.log("Got the transaction receipt: ", transactionReceipt)
                
                
                // tokenId 가져와서 DB에 저장
                const tokenId = await myWeb3.nftContract.currentTileId();
                console.log("tokenId: ", tokenId)
                console.log("item tokenId: ", item.tokenId)

                axios.put(`${BASE_URL}/api/tile/`, {
                    buyerAdr: myWalletAddr,
                    buyerId: null,
                    tokenId: bool ? item.tokenId : tokenId._hex,
                    area: item.area,
                    planet: Number(item.planet.id),
                    price: item.price,
                    tid: item.tid,
                    tradeDate: new Date()
                })
                .then(() => {
                    axios.get(`${BASE_URL}/api/tile/${item.tid}`)
                    .then((res) => {
                        console.log(res);
                    })
                })
                console.log(item)
            }

            if (!isBuyDirect) {
                localStorage.removeItem("mintCart");
            }

            setIsWaiting(false);
            setIsDone(true);
            console.log("구매 끝!");
        } catch (err) {
            console.log(err);
            onHide();
            setIsWaiting(false);
        }
    }

    return (
        <div className={`${styles.PurchaseModalWrapper} ${show ? styles.show : ""}`}>
            <div className={styles.PurchaseModal}>
                <header>
                    <button className={styles.closeBtn} onClick={() => {
                            onHide();
                            setIsDone(false);
                     }}>
                        <VscChromeClose />
                    </button>
                </header>
                {
                    isWaiting && !isDone
                    ?
                        <div className={styles.waiting}>
                            <Lottie
                                className="logo_lottie"
                                options={lottieOptions}
                                isStopped={false}
                                isPaused={false}
                                isClickToPauseDisabled={false}
                                style={{ width: '300px', height: '300px' }} // svg의 부모 div에 적용
                                eventListeners={[
                                {
                                    eventName: 'complete',
                                    callback: () => console.log('the animation completed'),
                                },
                                ]}
                            />
                            <p>
                                구매 진행중입니다...
                            </p>
                            <p>
                                잠시만 기다려주세요! 
                            </p>
                        </div>
                    :
                        !isWaiting && isDone
                        ?
                            <div className={styles.done}>
                                <div className={styles.done__notice}>
                                    <p>
                                        구매가 모두 완료되었습니다!
                                    </p>
                                    <p>
                                        MyPage에서 내가 구매한 땅을 확인해보세요:)
                                    </p>
                                </div>
                                <div className="btns">
                                    <button onClick={() => {
                                        navigate(`/mypage`);
                                    }}>
                                        MyPage 바로가기
                                    </button>
                                </div>
                            </div>
                        :
                        <>
                            <section className={styles.myWalletInfo}>
                                <h2>
                                    내 지갑
                                    <img className={styles.metamaskLogo} alt="metamask"
                                        src="https://upload.wikimedia.org/wikipedia/commons/3/36/MetaMask_Fox.svg" />
                                </h2>
                                <p className={styles.walletAddr}>{myWalletAddr}</p>
                            </section>
                            <div className={styles.purchaseModal__bottomWrapper}>
                                <section className={styles.myPurchaseInfoWrapper}>
                                    <h2>거래정보</h2>
                                    <ul className={`${styles.purchaseGrid} ${styles.purchaseGridTitle}`}>
                                        <li className={styles.purchaseGridItem}>토지</li>
                                        <li className={styles.purchaseGridItem}>판매자</li>
                                        <li className={styles.purchaseGridItem}>구매자</li>
                                        <li className={styles.purchaseGridItem}>가격</li>
                                    </ul>
                                    <div className={styles.myPurchaseInfo}>
                                        <ul className={styles.myPurchaseInfo__inner}>
                                            {
                                                itemsToBuy.map((item, idx) => (
                                                    <li key={`purchaseItem-${idx}`} className={`${styles.purchaseGrid} ${styles.purchaseGridLi}`}>
                                                        <span className={styles.purchaseGridItem}>
                                                            <span className={`${styles.purchaseGridItem__title} ${styles.purchaseGridItem__landId}`}>{item.tid}</span>
                                                        </span>
                                                        <span className={styles.purchaseGridItem}>
                                                            <span className={styles.purchaseGridItem__title}>FROM</span>
                                                            {`${shortenWalletAddr(item.buyerAdr)}`}
                                                        </span>
                                                        <span className={styles.purchaseGridItem}>
                                                        <span className={styles.purchaseGridItem__title}>TO</span>
                                                            {`${shortenWalletAddr(myWalletAddr)}`}
                                                        </span>
                                                        <span className={`price ${styles.price} ${styles.purchaseGridItem}`}>
                                                            <img src="../../ethereum.png" alt="eth" className="eth"/>
                                                            <span className={`priceText ${styles.priceText}`}>{item.price}</span>
                                                        </span>
                                                        <span className={`price ${styles.price} ${styles.purchaseGridItem}`}></span>
                                                    </li>
                                                ))
                                            }
                                        </ul>
                                    </div>
                                </section>
                                <div className={styles.purchaseBtnWrapper}>
                                    <section className={styles.purchaseBtnWrapper__inner}>
                                        <div className={styles.purchaseNotice}>
                                            <p>
                                                행성 토지 구매시 해당 토지의 소유권은 구매자에게 귀속됩니다.
                                            </p>
                                            <p>
                                                구매자는 추후 자신이 구매한 토지를 타인에게 재판매할 수 있습니다.
                                            </p>
                                            <p>
                                                단, 재판매시 얻은 수익의 일부(재판매가의 10%)는 자동으로 MINT에 납부됩니다.
                                            </p>
                                        </div>
                                        <div>
                                            <PurchaseBtnSection 
                                                cartSize={itemsToBuy.length} 
                                                totalPrice={new Big(itemsToBuy.reduce((acc, item) => { return acc + item.price }, 0)).toFixed(2)}
                                                onClick={buy} />
                                        </div>
                                    </section>
                                </div>
                            </div>
                        </>
                }
            </div>
        </div>
    );
  }

export default PurchaseModal;