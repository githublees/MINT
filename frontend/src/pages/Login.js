import React, { useState } from 'react';
import Lottie from 'react-lottie';
import Mint_Lodo from '../lottie/Mint_Logo_Long_Font.json';
import styles from '../styles/Login.scss';
import Metamask from '../components/login/Metamask';
const lottieOptions = {
  animationData: Mint_Lodo,
  loop: true,
  autoplay: true,
  rendererSettings: {
    className: 'add-class', // svg에 적용
    preserveAspectRatio: 'xMidYMid slice',
  },
};
const Login = () => {
  const [isStopped, SetIsStopped] = useState(false);
  const [isPaused, SetIsPaused] = useState(true);
  return (
    <div className="login" style={styles}>
      <div className="left_area">
        <div>
          <Lottie
            className="logo_lottie"
            options={lottieOptions}
            isStopped={isStopped}
            isPaused={isPaused}
            isClickToPauseDisabled={false}
            style={{ width: '550px', height: '550px' }} // svg의 부모 div에 적용
            eventListeners={[
              {
                eventName: 'complete',
                callback: () => console.log('the animation completed'),
              },
            ]}
          />
        </div>
      </div>
      <div className="right_login">
          <Metamask/>
      </div>
    </div>
  );
};
export default Login;
