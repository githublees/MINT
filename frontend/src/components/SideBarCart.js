import PurchaseBtnSection from "./PurchaseBtnSection";
import { VscChromeClose } from "react-icons/vsc";
import PlanetLottie from "../components/PlanetLottie";
import { useEffect, useState } from "react";
import Big from "big.js";

const SideBarCart = ({ cartItems, selectedIdx, setSelectedIdx, setModalShow, setCartItems }) => {
    console.log(cartItems)
    console.log("selectedIdx!!!", selectedIdx)
    const [totalPrice, setTotalPrice] = useState(0);

    const onDelete = (event, targetIdx)=> {
        event.stopPropagation();
        if (targetIdx === cartItems.length - 1) {
            setSelectedIdx(targetIdx-1);
        }
        setCartItems(prev => {
            const newCart = prev.filter((item, i) => i !== targetIdx);
            if (newCart.length > 0) {
                localStorage.setItem("mintCart", JSON.stringify(newCart));
            } else {
                localStorage.removeItem("mintCart");
            }
            return newCart
        })
    }

    return(
        <aside className="SideBar">
            <header>
                <h1>장바구니</h1>
            </header>
            <section className="cartList" >
                {
                    cartItems.map((item, idx) => (
                        <section key={`cartItem-${idx}`} 
                            className={`cartItem ${idx === selectedIdx ? "cartItem--selected" : ""}`}
                            onClick={() => setSelectedIdx(idx)}>
                            <button className="deleteBtn" onClick={(event) => onDelete(event, idx)}><VscChromeClose/></button>
                            <PlanetLottie 
                                planetName={item.planet.data.name}
                                width={90}
                                height={90}
                            />
                            <div className="itemInfo">
                                <p className="planetName">{item.planet.data.name}</p>
                                <h2 className="landId">{item.tid}</h2>
                                <div className="itemPrice">
                                    <img src="../../ethereum.png" alt="ethereum" className="eth"/>
                                    <span className="priceText">{item.price} ETH</span>
                                </div>
                            </div>
                        </section>))
                }
            </section>
            <div className="PurchaseBtnSectionWrapper">
                <PurchaseBtnSection 
                    cartSize={cartItems.length} 
                    totalPrice={new Big(cartItems.reduce((acc, item) => { return acc + item.price }, 0)).toFixed(2)}
                    onClick={() => setModalShow(true)} />
            </div>
        </aside>
    );
}
export default SideBarCart;