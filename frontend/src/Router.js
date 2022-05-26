import App from './App';
import Home from './pages/Home';
import Description from './pages/Description';
import Login from './pages/Login';
import MyPage from './pages/MyPage';
import MyPlanet from './pages/MyPlanet';
import PlanetDetail from './pages/PlanetDetail';
import PlanetPurchase from './pages/PlanetPurchase';
import AdminPlanetTransaction from './pages/AdminPlanetTransaction'
import AdminPlanetCadastre from './pages/AdminPlanetCadastre';
import AdminPlanetCadastreDetail from './pages/AdminPlanetCadastreDetail';
import { BrowserRouter, Routes, Route } from "react-router-dom";

const AppRouter= ( ) => {
    return(
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<App />}>  
                    <Route path="home" element={<Home />}/>
                    <Route path="description" element={<Description />}/>
                    <Route path="login" element={<Login />}/>
                    <Route path="mypage" element={<MyPage />}/>
                    <Route path="mypage/:planetName" element={<MyPlanet />}/>
                    <Route path="planet/:planetId" element={<PlanetDetail />} /> 
                    <Route path="planet/purchase" element={<PlanetPurchase />} /> 
                    <Route path="transaction" element={<AdminPlanetTransaction />} /> 
                    <Route path="cadastre" element={<AdminPlanetCadastre />} /> 
                    <Route path="cadastre/:planetId" element={<AdminPlanetCadastreDetail />} /> 
                </Route>
            </Routes>
        </BrowserRouter>
    );
}
export default AppRouter;