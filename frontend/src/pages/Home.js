import styles from '../styles/Home.scss';
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Carousel } from 'react-bootstrap';
import axios from 'axios';
import ReactTooltip from 'react-tooltip';
import PlanetLottie from "../components/PlanetLottie";

const Home = () => {
  const [planetList, setPlanetList] = useState();
  const [isStopped, SetIsStopped] = useState(false);
  const [isPaused, SetIsPaused] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_SERVER_URL + '/api/planets', {})
      .then((res) => {
        const planetData = res.data.planet;
        setPlanetList((prevState) => ({
          ...prevState,
          planetData,
        }));
        // console.log(planetData);
      });
  }, []);

  return (
    <div className="main" style={styles}>
      {/* <div> */}
      <div>
        <Carousel>
          {planetList !== undefined &&
            planetList.planetData.map((planet, index) => (
              <Carousel.Item key={index}>
                <div className="planet-name">{planet.name}</div>
                <div
                  onClick={() => {
                    navigate(`/planet/${planet.pid}`);
                  }}
                  data-tip={planet.content}
                  data-for={planet.name}
                  className="lottie-div"
                >
                  <PlanetLottie 
                    planetName={planet.name}
                    isStopped={isStopped}
                    isPaused={isPaused}
                    width={500}
                    height={500}
                  />

                  <ReactTooltip
                    id={planet.name}
                    type="dark"
                    place="right"
                    effect="solid"
                    insecure={true}
                    multiline={true}
                    className="tooltip"
                  ></ReactTooltip>
                </div>
              </Carousel.Item>
            ))}
        </Carousel>
      </div>
    </div>
  );
};
export default Home;
