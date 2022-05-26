import SideNav, {
  Toggle,
  Nav,
  NavItem,
  NavIcon,
  NavText,
} from '@trendmicro/react-sidenav';
import '../../styles/Sidebar.scss';
import '@trendmicro/react-sidenav/dist/react-sidenav.css';
import { FaHome } from 'react-icons/fa';
import { MdOutlineDescription } from 'react-icons/md';
import { VscDebugDisconnect } from 'react-icons/vsc';
import { useNavigate, useLocation } from 'react-router-dom';
import { useState } from 'react';


const Sidebar = () => {
  const { pathname } = useLocation();
  const navigate = useNavigate();
  const [expand,setExpand] = useState(false);

  const toggle = ()=>{
    setExpand(!expand)
  }
  return (
    <div className="sidebar-skeleton">
    <SideNav
      className="sidebar"
      expanded={expand}
      onSelect={(selected) => {
        const to = '/' + selected;
        if (pathname !== to) {
          navigate(to);
          setExpand(false);

          localStorage.setItem('path',pathname);
        }
        else{
          localStorage.setItem('path','/' + selected);
        }
      }}

    >
      <Toggle onClick={toggle}/>
      <Nav defaultSelected={pathname.substring(1)}>
        <NavItem eventKey="home">
          <NavIcon className="sidebar-icon">
            <FaHome size="1.8em" />
          </NavIcon>
          <NavText>Home</NavText>
        </NavItem>
        <NavItem eventKey="description">
          <NavIcon className="sidebar-icon">
            <MdOutlineDescription size="2em" />
          </NavIcon>
          <NavText>Description</NavText>
        </NavItem>
      </Nav>
      <Nav className="sidebar-wallet">
        <NavItem eventKey="login">
          <NavIcon className="sidebar-icon">
            <VscDebugDisconnect size="2em" color="rgb(255,255,255)" />
          </NavIcon>
          <NavText>Connect Wallet</NavText>
        </NavItem>
      </Nav>
    </SideNav>
    </div>
  );
};
export default Sidebar;
