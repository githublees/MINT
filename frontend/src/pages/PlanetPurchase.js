import { useEffect, useState } from "react";
import styles from "../styles/PlanetPurchase.module.scss";

import Planet from "../components/Planet";
import Land from "../components/Land";
import PlanetMap from "../components/PlanetMap";
import SideBarCart from "../components/SideBarCart";
import PurchaseModal from "../components/PurchaseModal";
import { useNavigate } from "react-router-dom";

// outlet context
import { useOutletContext } from "react-router-dom";

import { ethers } from 'ethers';
import axios from 'axios';

const PlanetPurchase= () => {
    const [cartItems, setCartItems] = useState([]);
    const [selectedIdx, setSelectedIdx] = useState(0);
    const [selectedId, setSelectedId] = useState("");

    const [modalShow, setModalShow] = useState(false);
    const onModalHide = () => setModalShow(false);

    const navigate = useNavigate();

    // web3 관련 객체 가져오기
    const myWeb3 = useOutletContext();
    console.log(myWeb3)

    const BASE_URL = process.env.REACT_APP_SERVER_URL;

    useEffect(() => {
        const cartItemsInStorage = JSON.parse(localStorage.getItem("mintCart"));
        console.log(cartItemsInStorage);
        const reqs = [];
        for (const key in cartItemsInStorage) {
            const axiosReq = axios.get(`${BASE_URL}/api/tile/${key}`);
            reqs.push(axiosReq);
        }
        console.log(reqs)
        
        if (cartItemsInStorage) {
            axios.all([...reqs])
              .then(res => {
                console.log(res);
                const cartItemParsedRes = res.map(item => {
                    const newData = item.data;
                    const planetData = cartItemsInStorage[newData.tid];
                    return {
                        ...newData,
                        planet: planetData
                    }
                })
                setCartItems([...cartItemParsedRes]);
                  
              })
              .catch((err) => {
                console.log(err);
              });
        }

    }, []);

    useEffect(() => {
        if (cartItems.length > 0) {
            setSelectedId(cartItems[0].id);
        }
        console.log(cartItems)
    }, [cartItems]);

    useEffect(() => {
        for (let i = 0; i < cartItems.length; i++) {
            if (cartItems[i].id === selectedId) {
                setSelectedIdx(i);
                break
            }
        }
    }, [selectedId]);


    return(
        <div className={`${styles.PlanetPurchase} PlanetPage`}>
            <main>
                <h1>행성 토지 정보</h1>
                {
                    cartItems.length > 0
                    ?
                    <div className={styles.PlanetPurchaseInfoWrapper}>
                        <div>
                            {
                                cartItems.length && <Planet {...{...cartItems[selectedIdx].planet.data, ...{version: "card"}}} />
                            }

                            {
                                cartItems.length 
                                && 
                                 <PlanetMap 
                                    version={"purchase"}
                                    planetName={cartItems[selectedIdx].planet.data.name}
                                    tiles={cartItems[selectedIdx]}
                                    selectedTileId={cartItems[selectedIdx].tid}
                                    setSelectedTileId={setSelectedId} />
                            }
                        </div>
                        <div>
                            <Land {...{...cartItems[selectedIdx], ...{version: "card-purchase"}}} />
                        </div>
                    </div>
                    :
                    <div className="btns">
                        <button onClick={() => {
                            navigate("/home");
                        }}>
                            메인페이지로 가기
                        </button>
                    </div>
                }
            </main>
            
            <PurchaseModal
                show={modalShow}
                onHide={onModalHide} 
                itemsToBuy={cartItems}
                myWeb3={myWeb3}
                isBuyDirect={false}
            />
            <SideBarCart  
                cartItems={cartItems}
                selectedIdx={selectedIdx}
                setSelectedIdx={setSelectedIdx}
                setModalShow={setModalShow}
                setCartItems={setCartItems}
                onBuyDirect={false}
            />
        </div>
    );
}
export default PlanetPurchase;