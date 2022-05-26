import Lottie from 'react-lottie';

import Kepler_1649c from '../lottie/Planet_Kepler_1649C.json';
import Kepler_22b from '../lottie/Planet_Kepler_22B.json';
import Proxima_B from '../lottie/Planet_Proxima-b.json';
import Ross_128b from '../lottie/Planet_Ross_128B.json';
import Teegarden_b from '../lottie/Planet_Teegarden_B.json';

const planetData = {
    "Teegarden_b": Teegarden_b,
    "Ross_128b": Ross_128b,
    "Kepler_1649c": Kepler_1649c,
    "Kepler_22b": Kepler_22b,
    "Proxima_B": Proxima_B,
}
    

const PlanetLottie = ({ planetName, isStopped = false, isPaused = false, width = 150, height = 150 }) => {

    return (
        <Lottie
            options={{
                animationData: planetData[planetName],
                loop: true,
                autoplay: true,
                rendererSettings: {
                className: 'add-class', // svg에 적용
                preserveAspectRatio: 'xMidYMid slice',
                },
            }}
            isStopped={isStopped}
            isPaused={isPaused}
            style={{ width: `${width}px`, height: `${height}px` }} // svg의 부모 div에 적용
            eventListeners={[
                {
                eventName: 'complete',
                callback: () => console.log('the animation completed'),
                },
            ]}
        />
        
    )
}

export default PlanetLottie;