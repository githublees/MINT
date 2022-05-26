import styles from "../styles/Planet.module.scss";
import { useState } from "react";
import PlanetLottie from "./PlanetLottie";


// version
// 1. description: 행성 설명 포함된 버전
// 2. card: 행성 설명x 간단하게 카드형식으로 표현되는 버전
// 3. (default) 기본

const Planet = ({ version, name, imgSrc, diameter, mass, galaxy, distance, content }) => {
    // console.log(version)
    let slogan, detail;
    if (content) {
        [slogan, detail] = content.split("<br>");
    } 
    return(
        <article className={`${styles.Planet} ${styles[version]} ${version === "card" ? "Box" : ""}`}>
            <div className={styles.Planet__metadata}>
                <PlanetLottie 
                    planetName={name}
                />
                <dl className="metadata">
                    {
                        version === "description"
                        ? <h1>{name}</h1>
                        : 
                        <div className="metadata__data">
                            <dt>이름</dt> <dd>{name}</dd>
                        </div>
                    }
                    
                    <div className="metadata__data">
                        <dt>지름</dt> <dd>{diameter} earth</dd>
                    </div>
                    <div className="metadata__data">
                        <dt>질량</dt> <dd>{mass} earth</dd>
                    </div>
                    <div className="metadata__data">
                        <dt>소속</dt> <dd>{galaxy}</dd>
                    </div>
                    {/* <div className="metadata__data">
                        <dt>거리</dt> <dd>{distance}</dd>
                    </div> */}
                    <div className="metadata__description">
                        * 단위 earth: 지구의 n배
                    </div>
                </dl>
            </div>
            {
                version === "description" && 
                <dl className={styles.Planet__description}>
                    <p className={styles.slogan}>{slogan}</p>
                    <figcaption>{detail}</figcaption>
                </dl>
            }
        </article>
    );
}
export default Planet;