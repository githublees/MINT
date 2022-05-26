import { useEffect, useState } from 'react';
import '../styles/Cadastre.scss';
import axios from 'axios';
import PlanetLottie from '../components/PlanetLottie';
import { useNavigate } from 'react-router-dom';
const AdminPlanetCadastre = () => {
  const [planetList, setPlanetList] = useState();
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
        console.log(planetData);
      });
  }, []);
  return (
    <div className="Cadastre">
      <div className="Cadastre-title">SSAFY PLANET</div>
      <div className="Cadastre-box-margin">
        {planetList !== undefined &&
          planetList.planetData.map((planet, index) => (
            <div className="Cadastre-card-box" key={index} onClick={() => {
                navigate(`/cadastre/${planet.pid}`);
              }}>
              <div className="Cadastre-lottie">
                <PlanetLottie planetName={planet.name} width={180}
                    height={180}/>
              </div>
              <div className="Cadastre-planet-name">{planet.name}</div>
              <div className="Cadastre-planet-galaxy">{planet.galaxy}</div>
            </div>
          ))}
      </div>
    </div>
  );
};
export default AdminPlanetCadastre;
