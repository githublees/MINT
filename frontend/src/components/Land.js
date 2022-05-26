import styles from "../styles/Land.module.scss";
import PurchaseHistoryItem from "./PurchaseHistoryItem";

import shortenWalletAddr from "./utils/shortenWalletAddr";

import { VscChevronDown } from "react-icons/vsc";
import { useCallback, useEffect, useState } from "react";

import { ethers } from 'ethers';
import contract from '../smartcontract/TileFactory.json';
import Big from "big.js";
import axios from "axios";
import { useNavigate } from "react-router-dom";


// version
// card-purchase: 행성 구매페이지 (history: open)
// card-mypage: 마이페이지 - 내가 구매한 토지 정보 (history default: close)

const Land = ({ version, tid, area, image, buyerAdr, tradeDate, price, tokenId, pid }) => {
    console.log("tokenId:", tokenId)
    const [purchaseLog, setPurchaseLog] = useState({});

    const abi = ["event nftPurchase(uint256 indexed tileId, address indexed buyer, uint256 price, uint256 indexed purchaseTime)"];
    const contractAddress = process.env.REACT_APP_CONTRACT_ADDRESS;
    // const contractAddress = "0x58A1E6FFf914C23011A3fF99CdE84E7DaD3D82AC";
    console.log(version)

    const imageURL = `http://j6a106.p.ssafy.io/api/image/display?filename=${image}`;

    const navigate = useNavigate();

    if (tradeDate && tradeDate.length > 10) {
        const date = new Date(tradeDate);
        tradeDate = `${date.getFullYear()}.${String(date.getMonth() + 1).padStart(2, '0')}.${String(date.getDate()).padStart(2, '0')}`;
    }

    const HistoryLog = useCallback(async () => {
        const { ethereum } = window;
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(contractAddress, abi, signer);

        const transferEvent = await contract.queryFilter('nftPurchase');

        console.log(transferEvent);
        console.log(transferEvent.map(event => event.args));
        // console.log(transferEvent[0].args);
        // console.log(Number(transferEvent[0].args.tileId));
        // console.log(transferEvent[0].args.buyer);
        // console.log(Number(transferEvent[0].args.purchaseTime));

        const parsedTransferEvents = {};
        for (const event of transferEvent) {
            const data = event.args;
            const tileTokenId = data.tileId._hex;

            const price = new Big(Number(data.price._hex));
            const priceInEther = price.div(new Big(10).pow(18)).toFixed(2)
            // console.log(priceInEther)

            // block.timestamp가 unix 시간 단위로 되어 있으므로 변환해줌  ->  2022.04.07
            const timeInNum = Number(data.purchaseTime._hex);
            const time = new Date(timeInNum * 1000);
            const timeFormatted = `${time.getFullYear()}.${String(time.getMonth() + 1).padStart(2, '0')}.${String(time.getDate()).padStart(2, '0')}`
            // console.log(timeInNum)
            // console.log(time)

            const tmp = {
                tileTokenId: tileTokenId,
                tileBuyerAdr: data.buyer,
                tilePurchaseTime: timeFormatted,
                tilePurchaseUnixTime: time,
                tilePrice: priceInEther
            }
            if (!(tileTokenId in parsedTransferEvents)) {
                parsedTransferEvents[tileTokenId] = [];
            }
            parsedTransferEvents[tileTokenId].push(tmp);
        }
        for (const key in parsedTransferEvents) {
            const tmp = parsedTransferEvents[key];
            tmp.sort((a, b) => b.tilePurchaseUnixTime - a.tilePurchaseUnixTime);
        }

        setPurchaseLog(parsedTransferEvents)
    }, []);

    // debugging!
    useEffect(() => {
        console.log("purchaseLog: ", purchaseLog)
    }, [purchaseLog])

    const imageChange = async (e) => {
        e.preventDefault();
        if(e.target.files){
            const uploadFile = e.target.files[0]
            const formData = new FormData()
            formData.append('uploadfile',uploadFile)
            formData.append('tid',tid)
            axios
            .post(process.env.REACT_APP_SERVER_URL + '/api/image/upload', formData, {
                headers: {
                    "Content-Type": "multipart/form-data",
                },
            })
            .then((res) => {
            window.location.reload();
            // console.log(res);
            });
        }
    }

    useEffect(() => {
        HistoryLog();
    }, [HistoryLog]);

    return(
        <article className={`${styles.Land} ${styles[version]} ${version === "card-purchase" ? "Box" : ""}`}>
            {
                version === "card-purchase" 
                &&
                <header>
                    {
                        image !== null && image !== undefined
                        ? <img className={`${styles.landImg} ${styles.landImgO}`} src={imageURL} alt="landImg" />
                        : <div className={styles.landImg} />
                    }
                    <h2>{tid}</h2>
                </header>
            }
            <div className={styles.landInfoWrapper}>
                {
                    version === "card-mypage"
                    &&
                    <div className={styles.landImgWrapper}>
                        {
                            image !== null && image !== undefined
                            ? <img className={`${styles.landImg} ${styles.landImgO} ${styles.landImgBig}`} src={imageURL} alt="landImg" />
                            : <div className={`${styles.landImg} ${styles.landImgBig}`} />
                        }
                        {/* <button className={styles.landImgUploadBtn} htmlFor="file">사진 등록</button> */}
                        <div className={styles.filebox}>
                            <label htmlFor="file">
                                {
                                    image
                                    ? "사진 변경"
                                    : "사진 등록"
                                }
                            </label>
                            <input
                                type="file"
                                id="file"
                                accept="image/*"
                                onChange={imageChange}
                            />
                        </div>
                    </div>
                }
                <dl className={`metadata ${styles.metadata}`}>
                    <div>
                        <dt>크기</dt> <dd>{area * 1000}km<sup>2</sup></dd>
                    </div>
                    <div className="price">
                        <dt>현재가</dt> 
                        <dd>
                            <img src="../../ethereum.png" alt="eth" className="eth" />
                            <span className={`priceText ${styles.priceText}`}>{price} ETH</span>
                        </dd>
                    </div>
                    {
                        version !== "card-purchase" 
                        &&
                        <div className={styles.tradeDate}>
                            <dt>취득일</dt> <dd>{tradeDate}</dd>
                        </div>
                    }
                    <div>
                        <dt>소유자</dt> <dd>{`${buyerAdr && tokenId ? shortenWalletAddr(buyerAdr) : "( 없음 )"}`}</dd>
                    </div>
                    <details open={version === "card-purchase" ? true : false} className={styles.purchaseHistory}>
                        <summary>
                            history 
                            {
                                version !== "card-purchase"
                                &&
                                <VscChevronDown className={styles.arrowDown} />
                            }
                        </summary>
                        <ul className={styles.historyItems}>
                            {   
                                tokenId && tokenId in purchaseLog
                                ?
                                purchaseLog[tokenId].map((log, idx) => (
                                    <PurchaseHistoryItem 
                                        buyerAdr={log.tileBuyerAdr}
                                        purchaseTime={log.tilePurchaseTime}
                                        price={log.tilePrice}
                                        key={`purchaseHistoryItem-${tokenId}-${idx}`} />
                                ))
                                :
                                `(구매 이력 없음)`
                            }
                        </ul>
                    </details>
                </dl>
            </div>
            {
                version === "card-mypage"
                &&
                <button className={styles.landInMapBtn}
                    onClick={
                        () => navigate({
                            pathname: `/planet/${pid}`,
                            search: `?selected=${tid}`,
                          })
                    }
                >
                    지도에서 위치 확인하기
                </button>
            }

        </article>
    );
}
export default Land;