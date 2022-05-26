import axios from "axios";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import PlanetMap from "../components/PlanetMap";
import PlanetLottie from '../components/PlanetLottie';
import CircularProgressBar from "../components/CircularProgressbar";
import '../styles/CadastreDetail.scss';


const AdminPlanetCadastreDetail= ( ) => {

    // const soldTiles = [
    //     "KepC-A-001",
    //     "KepC-A-003",
    //     "KepC-B-001",
    //     "KepC-C-001",
    //     "KepC-D-002",
    //     "KepC-E-002",
    //     "KepC-E-003",
    // ]
    const { planetId } = useParams();
    const [myPlanet, setMyPlanet] = useState([]);
    const [myTiles, setMyTiles] = useState([]);
    const [soldTiles, setSoldTiles] = useState([]);
    const [myDistance, setMyDistance] = useState("");
    const [tileTotal, setTileTotal] = useState(0);
    const [soldTotal, setSoldTotal] = useState(0);
    const percentage = (( soldTotal / tileTotal) * 100).toFixed(0);
    useEffect(() => {
      axios.all([
        axios.get(`${process.env.REACT_APP_SERVER_URL}/api/planet/${planetId}`),
        axios.get(`${process.env.REACT_APP_SERVER_URL}/api/all/${planetId}`),
        axios.get(`${process.env.REACT_APP_SERVER_URL}/api/remain/${planetId}`),
    ])
      .then(
          axios.spread((planetRes, tileRes, soldRes) => {
            // console.log(planetRes.data);
            const planetData = planetRes.data;
            planetData.version = "description";
            setMyPlanet(planetData);
            setMyDistance( distance.get(planetRes.name))

            console.log("tiles:", tileRes.data.tiles)
            const tileData = tileRes.data.tiles;
            setMyTiles(tileData);
            setTileTotal(tileData.length);
            
            // console.log(soldRes.data.tiles,"팔린땅");
            const soldData=soldRes.data.tiles;
            // console.log(soldData);
            const newArr = soldData.map(function(item){return item.tid});
              console.log(newArr);
            // const newARrr=soldData.Map((sold)=>(sold.tid))
            setSoldTiles(newArr);
            setSoldTotal(soldData.length);
            // const remainData = 
          })
      )
      .catch((err) => {
        console.log(err);
      });
      // console.log(soldTiles);
  }, []);
  const distance = new Map([
    ['Teegarden_b', "지구로부터 약 758,893AU (약 12광년)"],
    ['Kepler_1649c', "지구로부터 약 1.897e+7AU (약 300광년)"],
    ['Ross_128b', "지구로부터 약 695,652AU (약 11광년)"],
    ['Kepler_22b', "지구로부터 약 3.794e+7AU (약 600광년)"],
    ['Proxima_B', "지구로부터 약 265,613AU (약 4.2광년)"],
  ]);

    return(
       <div className="CadastreDetail">
           <div className="CadastreDetail-name"><b>{myPlanet.name}</b> 토지현황</div>
           <div className="CadastreDetail-box">
                <div className="CadastreDetail-lottie"><PlanetLottie planetName={myPlanet.name}/></div>
                <div className="CadastreDetail-area">
                    <span className="CadastreDetail-data">
                        <div className="CadastreDetail-title">질량</div>
                        <div className="CadastreDetail-content">{myPlanet.mass}x 5.9742 x 1024kg</div>
                    </span>
                    <span className="CadastreDetail-data">
                        <div className="CadastreDetail-title">지름</div>
                        <div className="CadastreDetail-content">{myPlanet.diameter}x 12,742km</div>
                    </span>
                    <span className="CadastreDetail-data">
                        <div className="CadastreDetail-title">소속</div>
                        <div className="CadastreDetail-content">{myPlanet.galaxy}</div>
                    </span>
                    
                    <img src={'../../cadastre.svg'} alt={'../../cadastre.svg'} className="CadastreDetail-img"/>
                    <div className="CadastreDetail-distance">{myDistance}</div>
                    <div className="CadastreDetail-au">*1AU = 약 1억 5천만 km(태양과 지구 간의 거리)</div>
                </div>
                <div className='v-line'></div>
                <div className="CadastreDetail-percent">
                    <div className="CadastreDetail-landdiv">땅구매 비율</div>
                    <div className="CadastreDetail-circular"><CircularProgressBar percentage={percentage}/></div>
                </div>
                
           </div>
           <PlanetMap
                version={"admin"}
                planetName={myPlanet.name}
                tiles={myTiles}
                soldTiles={soldTiles} />
       </div>
    );
}
export default AdminPlanetCadastreDetail;