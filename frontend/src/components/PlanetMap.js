import { useEffect, useState } from "react";
import Lottie from 'react-lottie';
import styles from "../styles/PlanetMap.module.scss";

// versions
// 1. detail (상세, 선택 셀 색깔 민트색)
// 2. purchase (구매과정, 선택 셀 색깔 민트색)
// 3. admin (관리자 페이지, 선택 셀(구매 완료된 셀들) 색깔 빨간색)

const ConvertToplanetCode = {
    "Kepler_1649c": "KepC",
    "Teegarden_b": "TG",
    "Proxima_B": "PrxB",
    "Kepler_22b": "KepB",
    "Ross_128b": "RB"
}

const PlanetMap = ({ version, planetName, tiles, selectedTileId, setSelectedTileId, soldTiles, tileImgs }) => {
    const planetCode = ConvertToplanetCode[planetName];

    const onClickTile = (targetTileId) => {
        if (version !== "detail") return;
        console.log(targetTileId)
        setSelectedTileId(targetTileId);
    }

    const tileGenerator = (planetId, blockId, totalTileNum) => {
        return new Array(totalTileNum).fill("").map((tile, idx) => {
                const tileId = `${planetId}-${blockId}-${String(idx+1).padStart(3,'0')}`;
                return (
                    <li key={`grid-item-${idx}`}
                        className={`${styles.planetMapGridItem} 
                            ${styles[tileId]}
                            ${tileId === selectedTileId ? styles['planetMapGridItem--selected'] : ""}
                            ${version === "admin" && soldTiles.includes(tileId) ? styles['planetMapGridItem--sold'] : ""}`}
                        onClick={() => onClickTile(tileId)}
                    >
                        {
                            (version==="detail"&&tileImgs[tileId])
                            ?
                            <div className={styles.tileImg}
                                style={{ 
                                    backgroundImage : `url(http://j6a106.p.ssafy.io/api/image/display?filename=${tileImgs[tileId]})`
                                }}>
                            </div>
                            : <div className={styles.tileImg}></div>
                        }
                    </li>
                )
            })
    }

    const blockGenerator = (tilesInBlock, planetId) => {
        return tilesInBlock.map((tileNum, idx) => {
            const blockName = String.fromCharCode(65 + idx);
            const blockId = `${planetId}-${blockName}`;
            return (
                <div className={styles[blockId]} key={`block-${blockId}`}>
                    { tileGenerator(planetId, blockName, tileNum) }
                </div>
            )
        })
    }

    return(
        <article className={`${styles.PlanetMap} ${styles[version]}`}>
            <img src={`../../../planetMap/${planetName}.svg`} 
                alt={`planet map - ${planetName}`} className={styles.planet2DMap} />
            {
                (tileImgs || version!=="detail")
                &&
                <ul className={`${styles.planetMapGrid} ${styles[planetCode]}`}>
                    {
                        planetCode === "KepC"
                        &&
                        blockGenerator([12, 3, 1, 4, 5], planetCode)
                    }
                    {
                        planetCode === "TG"
                        &&
                        blockGenerator([7, 6, 5, 3, 3, 1], planetCode)
                    }
                    {
                        planetCode === "RB"
                        &&
                        blockGenerator([2, 1, 8, 1, 1, 3, 3, 6], planetCode)
                    }
                    {
                        planetCode === "KepB"
                        &&
                        blockGenerator([9, 2, 1, 1, 2, 5, 1, 3, 4], planetCode)
                    }
                    {
                        planetCode === "PrxB"
                        &&
                        blockGenerator([9, 3, 8, 2, 2, 3, 3], planetCode)
                    }
                </ul>
             } 
        </article>
    );
}
export default PlanetMap;