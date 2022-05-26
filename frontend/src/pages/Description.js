import styles from '../styles/Description.module.scss';
import { Animator, ScrollContainer, ScrollPage, batch, Fade, FadeIn, Move, MoveIn, MoveOut, Sticky, StickyIn, ZoomIn } from "react-scroll-motion";

import Lottie from 'react-lottie';
import Mint_Lodo from '../lottie/Mint_Logo_Long_Font.json';

const Description= ( ) => {
    // const ZoomInScrollOut = batch(StickyIn(), FadeIn(), ZoomIn());
    const FadeUpCenter = batch(Fade(), MoveIn(0, 50), Sticky(), MoveOut(0, -50));
    const FadeUpTitle2 = batch(Fade(), MoveIn(0, 70), Sticky(50, 22), MoveOut(0, -70));
    const FadeUpTitle = batch(Fade(), MoveIn(0, 70), Sticky(50, 25), MoveOut(0, -70));
    const FadeUp = batch(Fade(), MoveIn(0, 50), Sticky(50, 50), MoveOut(0, -50));
    const FadeUpText = batch(Fade(), MoveIn(0, 100), Sticky(50, 80), MoveOut(0, -100));
    const FadeUpQuoteImg = batch(Fade(), MoveIn(0, 50), Sticky(36, 50), MoveOut(0, -50));
    const FadeUpQuoteText = batch(Fade(), MoveIn(0, 100), Sticky(71, 50), MoveOut(0, -100));
    // const FadeUp = batch(FadeIn(), Sticky(), MoveOut(0, -200));
    const FadeTitle = batch(Fade(), Sticky());

    const lottieOptions = {
        animationData: Mint_Lodo,
        loop: true,
        autoplay: true,
        rendererSettings: {
          className: 'add-class', // svg에 적용
          preserveAspectRatio: 'xMidYMid slice',
        },
      };

    return(
        <main className={styles.Description}>
            <header>
                <h1 className={styles.mint}> MINT </h1>
                <div className={styles.header__subWrapper}>
                    <p className={`${styles.header__sub} ${styles.header__meaning}`}>
                        <strong>M</strong>inistry of <strong>IN</strong>terstellar <strong>T</strong>rade
                    </p>
                    <p className={`${styles.header__sub} ${styles.header__slogan}`}>
                        Buy and own a planet where future humans can settle!
                    </p>
                </div>
            </header>
            <article className={styles.article}>
                <ScrollContainer>
                    <ScrollPage page={0}>
                        <Animator animation={FadeUpCenter}>
                            <div className={styles.page}>
                                <h2>
                                    Why, <span className={`${styles.mint} ${styles.mint__h2}`}>MINT</span> ?
                                </h2>
                            </div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={1}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={2}>
                        <Animator animation={FadeUpQuoteImg}>
                            <div className={`${styles.img} ${styles['img-hawking']}`}></div>
                        </Animator>
                        <Animator animation={FadeUpQuoteText}>
                            <blockquote>
                                <p className={styles.quoteContent}>
                                    <div>
                                        "인류 멸망을 원치 않는다면
                                    </div>
                                    <div>
                                        향후 <strong>200년</strong> 안에
                                    </div>
                                    <div>
                                        지구를 떠나야 한다."
                                    </div>
                                </p>
                                <p className={styles.quoteFrom}>
                                - 천재 과학자 스티븐 호킹의 유언
                                </p>
                            </blockquote>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={3}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={4}>
                        <Animator animation={FadeUpQuoteImg}>
                            <div className={`${styles.img} ${styles['img-musk']}`}></div>
                        </Animator>
                        <Animator animation={FadeUpQuoteText}>
                            <blockquote>
                                <p className={styles.quoteContent}> 
                                <div>
                                    "언젠가 찾아올 
                                </div>
                                <div>
                                    인류 최후의 날의 대안은
                                </div>
                                <div>
                                    <strong>우주 문명</strong>을 건설하고 
                                </div>
                                <div>
                                    인류가 <strong>다행성 거주 종</strong>이 
                                </div>
                                    되는 것"
                                <div>

                                </div>
                                </p>
                                <p className={styles.quoteFrom}>
                                    <div>
                                        - 일론 머스크
                                    </div>
                                    <div>
                                        &nbsp;&nbsp;&nbsp;/ 민간 우주 탐사 기업 스페이스 X의 CEO
                                    </div>
                                </p>
                            </blockquote>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={5}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={6}>
                        <Animator animation={FadeUpTitle}>
                            <h3>인류의 멸종</h3>
                        </Animator>
                        <Animator animation={FadeUp}>
                            <div className={`${styles.img} ${styles['img-collision']}`}></div>
                        </Animator>
                        <Animator animation={FadeUpText}>
                            <p className={styles.descContent}>
                            &nbsp;&nbsp;스티븐 호킹은 인류가 외계 행성에 영구 거주할 수 있도록 지금 준비에 나서야 한다고 말해왔습니다. 
                            인류란 존재는 머지않아 멸종에 가까운 대재앙의 희생물이 될 것으로 판단했기 때문입니다. 
                            대표적 예가 소행성의 충돌 같은 것이지만, 호킹 박사는 이 외에도 
                            인공지능(AI)과 
                            기후변화,
                            핵전쟁, 
                            변종 바이러스, 
                            인구폭발 
                            등도 잠재적 위협이 될 것으로 봤습니다.
                            </p>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={7}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={8}>
                        <Animator animation={FadeUpTitle}>
                            <h3>새로운 거주지 탐사</h3>
                        </Animator>
                        <Animator animation={FadeUp}>
                            <div className={`${styles.img} ${styles['img-starshot']}`}></div>
                        </Animator>
                        <Animator animation={FadeUpText}>
                            <p className={styles.descContent}>
                            &nbsp;&nbsp;2016년 4월, 호킹은 일명 '브레이크스루 스타샷 (Breakthrough starshot)' 프로젝트를 발표했습니다.
                            지구와 가까운 항성계인 프록시마 계와 프록시마 B를 탐사하기 위해 초소형 우주선을 띄우는 것이 이 프로젝트의 목적입니다.
                            복사압을 이용하여 광속의 15%~20%의 속도로 2~30년만에 프록시마에 도달하여 4년에 걸친 탐사를 통해 프록시마의 환경, 생명체 거주 가능성, 대기 등을 확인하려는 계획을 가지고 있습니다.
                            이 프로젝트는 NASA에서 진행되어 2036년 발사된다는 구체적인 계획까지 완성된 상태입니다.
                            </p>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={9}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={10}>
                        <Animator animation={FadeUpTitle2}>
                            <h3>다행성 종족</h3>
                            <div className={styles.subtitle}>
                                multi-planetary species
                            </div>
                        </Animator>
                        <Animator animation={FadeUp}>
                            <div className={`${styles.img} ${styles['img-multiplanet']}`}></div>
                        </Animator>
                        <Animator animation={FadeUpText}>
                            <p className={styles.descContent}>
                            &nbsp;&nbsp;최초로 민간 유인 우주 왕복선 발사에 성공한 우주 탐사 기업 스페이스 X의 CEO 일론 머스크는 '다행성종족'(multi-planetary species)이라는 개념을 제시했습니다.
                            다행성 종족이란 여러 행성에 거주하는 생명체를 일컫습니다. 
                            머스크는 미래와 인류의 지속가능성에 대해 고민하며 인간이 궁극적으로 다른 행성으로 이주할 수 있는 다행성 종족이 돼야 한다고 강조해왔습니다. 
                            그는 실제로 2030년 경 화성 유인 탐사를 목표로 로켓 개발과 우주 탐사에 박차를 가하고 있습니다.
                            </p>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={11}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={12}>
                        <Animator animation={FadeUpTitle2}>
                            <h3>51개의 유사 지구</h3>
                            <div className={styles.subtitle}>
                                Goldilocks Planet
                            </div>
                        </Animator>
                        <Animator animation={FadeUp}>
                            <div className={`${styles.img} ${styles['img-Goldilocks']}`}></div>
                        </Animator>
                        <Animator animation={FadeUpText}>
                            <p className={styles.descContent}>
                            &nbsp;&nbsp;미국 항공우주국 NASA는 2022년 3월 22일자로 태양계 너머에서 확인된 외계 행성만 5000개를 넘어섰다고 밝혔습니다.
                            그 중 인간이 살아갈 수 있는 환경을 지닌 제 2의 지구가 되어줄 '유사 지구' 후보로 거론되고 있는 외계 행성 역시 현재까지 51개나 되며, 매일 새롭게 발견되고 있습니다.
                            </p>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={13}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={14}>
                        <Animator animation={FadeUp}>
                        <div className={`${styles.img} ${styles['img-move']}`}></div>
                        </Animator>
                        <Animator animation={FadeUpText}>
                            <p className={styles.descContent}>
                                <div>
                                    &nbsp;&nbsp;이처럼 지구는 더이상 유일한 거주지로서의 안정성을 보장해주지 못하고, 
                                    인류는 타행성으로의 이주를 바라보고 있습니다.
                                </div>
                                <div>
                                    빠르게 발달하고 있는 우주 기술이 그리 멀지 않은 시점에 제 2의 지구로의 이주를 가능하게 할 것으로 기대됩니다.
                                </div>
                            </p>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={15}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={16}>
                        <Animator animation={FadeTitle}>
                            <div className={styles.page}>
                                <h2>
                                    우주 부동산 거래 플랫폼, <span className={`${styles.mint} ${styles.mint__h2}`}>MINT</span>
                                </h2>
                            </div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={17}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={18}>
                        <Animator animation={FadeUpTitle}>
                            <h3>우주 부동산 NFT 구매</h3>
                        </Animator>
                        <Animator animation={FadeUp}>
                            <Lottie
                                className="logo_lottie"
                                options={lottieOptions}
                                isStopped={false}
                                isPaused={false}
                                isClickToPauseDisabled={false}
                                style={{ width: '300px', height: '300px' }} // svg의 부모 div에 적용
                                eventListeners={[
                                {
                                    eventName: 'complete',
                                    callback: () => console.log('the animation completed'),
                                },
                                ]}
                            />
                        </Animator>
                        <Animator animation={FadeUpText}>
                            <p className={styles.descContent}>
                            &nbsp;&nbsp;우주 부동산 거래 플랫폼 MINT는 이러한 미래 인류의 행성 이주에 대비해 여러 유사 지구의 가상 부동산 거래를 중개합니다.
                            당신은 MINT를 통해 향후 거주하게 될 행성의 토지를 선점할 수 있습니다. 
                            거래는 이더리움(ethereum) 기반의 NFT를 이용해 영구히 기록됩니다. 당신은 해당 토지에 대한 전적인 소유권을 가지게 되며, 해당 사실을 공적으로 인정받을 수 있습니다.
                            </p>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={19}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={20}>
                        <Animator animation={FadeUpCenter}>
                            <div className={`${styles.page} ${styles.ending}`}>
                                <p>
                                    <div>
                                        <img src='../../ethereum.png' alt='ethereum' className={styles.ethereum} />
                                    </div>
                                    <div>
                                        MINT에서 마음에 드는 토지를 구매하고
                                    </div>
                                    <div>
                                        각종 건물 및 시설의 건축 계획을 미리 세워보세요!
                                    </div>
                                </p>
                            </div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={21}>
                        <Animator animation={FadeUp}>
                            <div className={styles.empty}></div>
                        </Animator>
                    </ScrollPage>

                    <ScrollPage page={22}>
                        <Animator animation={FadeUp}>
                            <div className={styles.citesWrapper}>
                                <div className={styles.cites}>
                                    <p>자료 출처</p>
                                    <cite>
                                        <a href='https:ko.wikipedia.org/wiki/%EC%8A%A4%ED%83%80%EC%83%B7' target="_blank" rel="noopener noreferrer nofollow">
                                            https:ko.wikipedia.org/wiki/%EC%8A%A4%ED%83%80%EC%83%B7
                                        </a>
                                    </cite>
                                    <cite>
                                        <a href='https:youtu.be/IXJnJl_I1XI' target="_blank" rel="noopener noreferrer nofollow">
                                            https:youtu.be/IXJnJl_I1XI
                                        </a>
                                    </cite>
                                    <cite>
                                        <a href='https:www.joongang.co.kr/article/22456045#home' target="_blank" rel="noopener noreferrer nofollow">
                                            https:www.joongang.co.kr/article/22456045#home
                                        </a>
                                    </cite>
                                    <cite>
                                        <a href='https:www.sedaily.com/NewsVIew/263K08FUSB' target="_blank" rel="noopener noreferrer nofollow">
                                            hhttps:www.sedaily.com/NewsVIew/263K08FUSB
                                        </a>
                                    </cite>
                                    <cite>
                                        <a href='https:www.hani.co.kr/arti/science/science_general/783860.html' target="_blank" rel="noopener noreferrer nofollow">
                                            https:www.hani.co.kr/arti/science/science_general/783860.html
                                        </a>
                                    </cite>
                                </div>
                            </div>
                        </Animator>
                    </ScrollPage>
        
                </ScrollContainer>
            </article>
        </main>
    );
}
export default Description;