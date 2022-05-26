const shortenWalletAddr = (addr) => {
    if (!addr) {
        return "없음(0x000...00000)";
    }
    const L = addr.length;
    if (L > 12) {
        return `${addr.slice(0,9)}...${addr.slice(L-6, L-1)}`
    } else return addr
}

export default shortenWalletAddr;