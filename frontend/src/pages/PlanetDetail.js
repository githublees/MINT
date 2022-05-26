import { useCallback, useEffect, useState } from "react";
import { useNavigate, useParams, useSearchParams } from "react-router-dom";
import styles from "../styles/PlanetDetail.module.scss";
import { BsCart3 } from "react-icons/bs";

// outlet context
import { useOutletContext } from "react-router-dom";

import Planet from "../components/Planet";
import PlanetMap from "../components/PlanetMap";
import SideBarInfo from "../components/SideBarInfo";
import PurchaseModal from "../components/PurchaseModal";

import axios from 'axios';
import { ethers } from 'ethers';
import Big from "big.js";

const PlanetDetail= ( ) => {
    const { planetId } = useParams();
    const [searchParams] = useSearchParams();
    const selectedTile = searchParams.get("selected");

    const [planetInfo, setPlanetInfo] = useState({});
    const [tiles, setTiles] = useState([]);
    const [selectedTileIdx, setSelectedTileIdx] = useState(0);
    const [selectedTileId, setSelectedTileId] = useState("");
    const [tileImgs, setTileImgs] = useState();

    const [sellPrice, setSellPrice] = useState("");
    const [contractTileInfo, setContractTileInfo] = useState();
    const [newPriceTiles, setNewPriceTiles] = useState([]);

    const [cartItemNum, setCartItemNum] = useState(0);
    const [dibbedLands, setDibbedLands] = useState([]);

    const [modalShow, setModalShow] = useState(false);
    const onModalHide = () => setModalShow(false);

    const [myWalletAddr, setMyWalletAddr] = useState("");

    const navigate = useNavigate();

    

    // web3 관련 객체 가져오기
    const myWeb3 = useOutletContext();

    const BASE_URL = process.env.REACT_APP_SERVER_URL;

    useEffect(() => {
        const prevCart = localStorage.getItem("mintCart");
        if (prevCart) {
            const cartLen = Object.keys(JSON.parse(prevCart)).length;
            setCartItemNum(cartLen);
        }

        // 내 지갑 주소 가져오기
        const { ethereum } = window;
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        signer.getAddress()
        .then((res) => {
            setMyWalletAddr(res);
        })
        .then(() => {
            // axios 백엔드에서 정보 가져오기
            axios.all([
                axios.get(`${BASE_URL}/api/planet/${planetId}`),
                axios.get(`${BASE_URL}/api/all/${planetId}`)
            ])
              .then(
                  axios.spread((planetRes, tileRes, dibbedLandsRes) => {
                    console.log(planetRes.data);
                    const planetData = planetRes.data;
                    planetData.version = "description";
                    setPlanetInfo(planetData);
    
                    console.log("tiles:", tileRes.data.tiles)
                    const tileData = tileRes.data.tiles;
                    setTiles(tileData);
                  })
              )
              .catch((err) => {
                console.log(err);
              });
        })
    }, []);

    useEffect(() => {
        if (myWalletAddr) {
            axios.get(`${BASE_URL}/api/favorite/${myWalletAddr}`)
            .then((res) => {
                console.log("dibbedLands:", res.data)
                setDibbedLands(res.data);
            })
        }
    }, [myWalletAddr])
 
    useEffect(() => {
        setNewPriceTiles(tiles);

        if (tiles.length > 0) {
            if (selectedTile) {
                setSelectedTileId(selectedTile);
            } else {
                setSelectedTileId(tiles[0].tid);
            }
        }

        const tmp = {};
        for (const tile of tiles) {
            tmp[tile["tid"]] = tile.image;
        }
        setTileImgs(tmp);
    }, [tiles]);

    useEffect(() => {
        for (let i = 0; i < tiles.length; i++) {
            if (tiles[i].tid === selectedTileId) {
                setSelectedTileIdx(i);
                break
            }
        }
    }, [selectedTileId]);

    const tileInfo = useCallback(async () => {
        const { ethereum } = window;
        const provider = new ethers.providers.Web3Provider(ethereum);

        if (tiles.length <= 0) return;

        const tokenId = tiles[selectedTileIdx].tokenId;

        if (ethereum && tokenId) {
            const res = await myWeb3.nftContract.getTileId(tokenId);
            console.log(res);
            setContractTileInfo(res);

        } else {
            setContractTileInfo({});
        }

    }, [selectedTileIdx]);

    useEffect(() => {
        // tiles[selectedTileIdx]
        if (contractTileInfo && contractTileInfo.price && !contractTileInfo.assurance) {
            setNewPriceTiles(prev => prev.map((tile, idx) => {
                if (idx === selectedTileIdx) {
                    tile.price = new Big(Number(contractTileInfo.price._hex) * 0.1 ** 18).toFixed(2)
                }
                return tile;
            }))
        }

    }, [contractTileInfo])


    // debugging!!!
    useEffect(() => {
        console.log(newPriceTiles)
    }, [newPriceTiles])


    return(
        <div className={`${styles.PlanetDetail} PlanetPage`}>
            <main>
                {
                    planetInfo.name && <Planet {...planetInfo} />
                }

                <div className={styles.planetInfoWrapper}>
                    {
                        planetInfo.name && newPriceTiles.length > 0
                        && 
                        <PlanetMap 
                            version={"detail"}
                            planetName={planetInfo.name}
                            tiles={tiles}
                            selectedTileId={selectedTileId}
                            setSelectedTileId={setSelectedTileId}
                            tileImgs={tileImgs} />
                    }
                </div>

                {/* 장바구니 버튼 */}
                <button className={styles.cartButton} 
                    onClick={() => { navigate("/planet/purchase"); }}>
                    <BsCart3 />
                    <div className={styles.cartBadge}>{cartItemNum}</div>
                </button>
            </main>
            {
                tiles.length > 0
                &&
                <PurchaseModal
                    show={modalShow}
                    onHide={onModalHide} 
                    itemsToBuy={[{
                        ...tiles[selectedTileIdx],
                        planet: {
                            id: planetId,
                            data: planetInfo
                        },
                    }]}
                    isBuyDirect={true}
                    myWeb3={myWeb3}
                    contractTileInfo={contractTileInfo}
                />
            }
            <SideBarInfo 
                {...tiles[selectedTileIdx]}
                onAddCart={() => {
                    let cart = JSON.parse(localStorage.getItem("mintCart"));
                    if (!cart) {
                        cart = {}
                    }
                    cart[tiles[selectedTileIdx].tid] = {
                                    id: planetId,
                                    data: planetInfo
                                }
                    localStorage.setItem("mintCart", JSON.stringify(cart));
                    console.log(cart);
                    setCartItemNum(prev => prev + 1);
                }}
                onModalShow={()=> setModalShow(true)}
                myWalletAddr={myWalletAddr}
                dibbedLands={dibbedLands}
                setDibbedLands={setDibbedLands}
                sellPrice={sellPrice}
                setSellPrice={setSellPrice}
                myWeb3={myWeb3}
                tileInfo={tileInfo}
                contractTileInfo={contractTileInfo}
                newPriceTiles={newPriceTiles}
                selectedTileIdx={selectedTileIdx}
            />
            
        </div>
    );
}
export default PlanetDetail;