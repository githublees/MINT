import { AiOutlineStar, AiFillStar } from "react-icons/ai";
import shortenWalletAddr from "./utils/shortenWalletAddr";
import axios from 'axios';
import { useCallback, useEffect, useRef, useState } from "react";
import { ethers } from 'ethers';
import Big from "big.js";

const SideBarInfo = ({ tid, area, image, buyerAdr, trade_date, price, tokenId, onModalShow, onAddCart, myWalletAddr, dibbedLands, setDibbedLands, sellPrice, setSellPrice, myWeb3, tileInfo, contractTileInfo, newPriceTiles, selectedTileIdx }) => {
    const [dibbed, setDibbed] = useState(false);
    const [isInputNaN, setIsInputNaN] = useState(false);
    const [isOkToSell, setIsOkToSell] = useState(false);
    const [notice, setNotice] = useState("");
    const [isPending, setIsPending] = useState(false);

    const sellPriceInput = useRef();

    useEffect(() => {
        let flag = false;
        dibbedLands.forEach(tile => {
            if (tile.tileId === tid) {
                flag = true;
                setDibbed(true);
                return
            }
        });
        if (!flag) {
            setDibbed(false);
        }
    }, [dibbedLands, tid]);

    const BASE_URL = process.env.REACT_APP_SERVER_URL;
    const imageURL = `http://j6a106.p.ssafy.io/api/image/display?filename=${image}`;

    const onToggleDibs = () => {
        try {
            if (dibbed) {
                //이미 찜 목록에 있으면 찜 해제
                axios.delete(`${BASE_URL}/api/favorite/${myWalletAddr}/${tid}`)
                .then((res) => {
                    console.log(res)
                    setDibbedLands(prev => prev.filter(tile => tile.tileId !== tid))
                    setDibbed(false);
                })
                console.log("찜 해제")
            } else {
                // 찜 목록에 없으면 찜 등록
                axios.post(`${BASE_URL}/api/favorite`, {
                    tileId: tid,
                    walletId: myWalletAddr
                })
                .then((res) => {
                    console.log(res)
                    setDibbedLands(prev => [...prev, {tileId: tid}])
                    setDibbed(true);
                    console.log("찜 등록")
                })
                
            }
        } catch (err) {
            console.error(err);
        }
    }

    const onInputPrice = (event) => {
        const input = event.target.value;
        if (input.length> 0 && isNaN(Number(input))) {
            setIsInputNaN(true);
            return
        }

        if (isInputNaN) {
            setIsInputNaN(false);
        }

        setSellPrice(input);
        console.log(input)
    }


    useEffect(() => {
        tileInfo();
    }, [tileInfo])

    const sleep = (milliseconds) => {
        console.log("waiting...");
        return new Promise(resolve => setTimeout(resolve, milliseconds))
    }

    const onSellTile = async () => {
        try {
            setIsPending(true);
            setNotice("판매 신청을 요청하는 중입니다...");
    
            const { ethereum } = window;
            const provider = new ethers.providers.Web3Provider(ethereum);

            const sellPriceInWei = ethers.utils.parseEther(sellPrice)._hex;

            if (!ethereum) return;
            const res = await myWeb3.nftContract.sell(sellPriceInWei, tokenId);

            const hash = res.hash;

            // minig 끝날 때까지 기다리기
            let transactionReceipt = null
            while (transactionReceipt == null) { // Waiting expectedBlockTime until the transaction is mined
                transactionReceipt = await provider.getTransactionReceipt(hash);    //transactonHash
                await sleep(1000)    // expectedBlockTime
            }
            console.log("Got the transaction receipt: ", transactionReceipt);
            setIsPending(false);
            setNotice("");

            // tileInfo 다시 가져오기
            tileInfo();
        } catch (err) {
            console.error(err);
            setIsPending(false);
            setNotice("");
        }
    }

    const onCancelSell = async () => {
        try {
            setIsPending(true);
            setNotice("판매 신청을 취소하는 중입니다...");
    
            const { ethereum } = window;
            const provider = new ethers.providers.Web3Provider(ethereum);

            if (!ethereum) return;
            const res = await myWeb3.nftContract.cancel(tokenId);

            const hash = res.hash;

            // minig 끝날 때까지 기다리기
            let transactionReceipt = null
            while (transactionReceipt == null) { // Waiting expectedBlockTime until the transaction is mined
                transactionReceipt = await provider.getTransactionReceipt(hash);    //transactonHash
                await sleep(1000)    // expectedBlockTime
            }
            console.log("Got the transaction receipt: ", transactionReceipt);
            setIsPending(false);
            setNotice("");

            // tileInfo 다시 가져오기
            tileInfo();
        } catch (err) {
            console.error(err);
            setIsPending(false);
            setNotice("");
        }
    }

    
    // useEffect(() => {
    //     if (myWalletAddr === buyerAdr && contractTileInfo && contractTileInfo.price && !contractTileInfo.assurance) {
    //         const newPrice = new Big(Number(contractTileInfo.price._hex) * 0.1 ** 18).toFixed(2);
    //     }

    // }, [])

    return(
        <aside className="SideBar">
            <header>
                <h1>토지 정보</h1>
                <button className="toggleDibsOnLandBtn" onClick={onToggleDibs}>
                    {
                        dibbed ? <AiFillStar /> : <AiOutlineStar />
                    }
                </button>
            </header>
            <section className="info" >
                <h2>{tid}</h2>
                {
                    image 
                    ? <img className="image imageO" src={imageURL} alt="land" />
                    : <div className="image" />
                }

                <div className="SideBarCart__metadataWrapper">
                    <dl className="metadata">
                        <div>
                            <dt>크기</dt> <dd>{area * 1000}km<sup>2</sup></dd>
                        </div>
                        <div>
                            <dt>소유자</dt> <dd>{buyerAdr && tokenId ? `${shortenWalletAddr(buyerAdr)}` : "(없음)"}</dd>
                        </div>
                        <div className="price">
                            <dt>현재가</dt> 
                            <dd>
                                <img className="eth" src="../../ethereum.png" alt="ethereum" />
                                <span className="priceText">
                                    {/* {(newPrices && newPrices.hasOwnProperty(tokenId)) ?  newPrices[tokenId] : price} ETH */}
                                    {/* {(contractTileInfo && contractTileInfo.price && !contractTileInfo.assurance) 
                                    ? new Big(Number(contractTileInfo.price._hex) * 0.1 ** 18).toFixed(2) 
                                    : price} ETH */}
                                    {newPriceTiles.length > 0 && newPriceTiles[selectedTileIdx].price} ETH
                                </span>
                            </dd>
                        </div>
                    </dl>
                </div>
            </section>
            {
                    (buyerAdr && tokenId && contractTileInfo && contractTileInfo.assurance)
                    ?
                        myWalletAddr === buyerAdr
                        ?
                            isOkToSell
                            ?
                                <section className="btns">
                                    {
                                        notice.length > 0
                                        ?
                                        <p>{notice}</p>
                                        :
                                        <p className="btns__alert">
                                            <div>
                                                {`정말 토지 ${tid}를`}
                                            </div>
                                            <div>
                                                {`${sellPrice} ETH에 내놓으시겠습니까?`}
                                            </div>
                                        </p>
                                    }
                                    {
                                        !isPending
                                        &&
                                        <>
                                            <button 
                                                onClick={onSellTile}
                                                className={`${(isInputNaN || sellPrice.length <= 0) ? 'btn--disabled' : ''}`}
                                            >
                                                판매 신청하기
                                            </button>
                                            <button className='btn--disabled'
                                                onClick={() => {
                                                    setIsOkToSell(false);
                                                    setSellPrice("");
                                                }}>
                                                계속 가지고 있기
                                            </button>
                                        </>
                                    }
                                </section>
                            :
                                <section className="btns">
                                    <p className="btns__title">판매 희망 가격 (ETH)</p>
                                    <input type="text" 
                                        onInput={onInputPrice} 
                                        ref={sellPriceInput} 
                                        className="btns__priceInput"
                                    />
                                    <p>
                                        {
                                            isInputNaN
                                            ?
                                            "올바른 숫자 형식으로 입력해주세요."
                                            :
                                            ""
                                        }
                                    </p>
                                    <button 
                                        onClick={() => setIsOkToSell(true)}
                                        className={`${(isInputNaN || sellPrice.length <= 0) ? 'btn--disabled' : ''}`}
                                    >
                                        판매 신청하기
                                    </button>
                                </section>
                        :
                        <section className="notice">
                            <p className="notice__buyer">
                                {`${shortenWalletAddr(buyerAdr)}님이 소유하고 있는 토지입니다.`}
                            </p>
                        </section>
                    :
                        buyerAdr && tokenId && myWalletAddr === buyerAdr && contractTileInfo && !contractTileInfo.assurance
                        ?
                        <section className="btns">
                            {
                                notice.length > 0
                                ?
                                <p>
                                    {notice}
                                </p>
                                :
                                <p className="btns__alert">
                                    판매를 기다리고 있습니다!
                                </p>
                            }
                            {
                                !isPending
                                &&
                                <button onClick={onCancelSell}>
                                    판매 신청 취소하기
                                </button>
                            }
                        </section>
                        :
                        <section className="btns">
                            <button onClick={onAddCart}>
                                장바구니에 넣기
                            </button>
                            <button onClick={onModalShow}>
                                바로 구매하기
                            </button>
                        </section>
                    }
        </aside>
    );
}
export default SideBarInfo;