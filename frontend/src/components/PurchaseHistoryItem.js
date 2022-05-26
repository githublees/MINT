import styles from "../styles/PurchaseHistoryItem.module.scss";
import shortenWalletAddr from "./utils/shortenWalletAddr";

const PurchaseHistoryItem = ({ version, price, buyerAdr, purchaseTime }) => {
    console.log(version)
   
    return(
        <li className={styles.historyItem}>
            <div className={styles.historyItem__header}>
                <div className={styles.marker} />
                <p>{purchaseTime}</p>
            </div>
            <div className={styles.historyItem__purchaseInfo}>
                <p className={styles.historyItem__buyer}>
                    {shortenWalletAddr(buyerAdr)}
                </p>
                <div className={`price ${styles.price}`}>
                    <dd>
                        <img src="../../ethereum.png" alt="eth" className="eth" />
                        <span className={`priceText ${styles.priceText}`}>{price} ETH</span>
                    </dd>
                </div>
            </div>
        </li>
    );
}
export default PurchaseHistoryItem;