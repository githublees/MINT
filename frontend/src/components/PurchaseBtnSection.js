
const PurchaseBtnSection = ({ cartSize, totalPrice, onClick }) => {
    const shortenPrice = (price) => {
        const priceString = price.toString();
        if (priceString.length > 6) {
            return priceString.slice(0,6) + "...";
        } else return priceString;
    }

    return (
        <div className="PurchaseBtnSection">
            <section className="totalPrice">
                <h2 className="priceTitle">
                    총 금액 {`(${cartSize})`}
                </h2>
                <div className="priceWrapper">
                    <img src="../../ethereum.png" alt="ethereum" className="eth"/>
                    <span className="priceText">{`${shortenPrice(totalPrice)}`} ETH</span>
                    <div className="price__fullLength">
                        총 {totalPrice} ETH
                    </div>
                </div>

            </section>
            <section className="btns">
                <button className={cartSize > 0 ? "" : "btn--disabled"} onClick={() => {
                    if (cartSize <= 0) return;
                    onClick();
                }}>구매하기</button>
            </section>
        </div>
    )
}

export default PurchaseBtnSection;