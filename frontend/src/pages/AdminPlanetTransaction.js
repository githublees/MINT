import styles from '../styles/Transaction.scss';
import { BsFillCaretDownFill } from 'react-icons/bs';
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
import { forwardRef, useState,useEffect,useCallback } from 'react';
import moment from 'moment';
import axios from 'axios';

import { BigNumber, ethers } from 'ethers';
import contract from '../smartcontract/TileFactory.json'


const AdminPlanetTransaction= ( ) => {
    const [startDate, setStartDate] = useState(new Date());
    const [day, setDay] = useState(new Date());
    const [options, setOptions] = useState([]);
    const [selectedCategory, setSelectedCategory] = useState('');
    // let postData = [];
    const [postData, setPostData] = useState([]);
    const abi = contract.abi;
    const contractAddress = process.env.REACT_APP_CONTRACT_ADDRESS;

    const postDate = ()=>{

        const filterdate = postData.filter(
            (item) => item.tradeDate === day
        );
        console.log(day);
        console.log(filterdate);
        setPostData(filterdate);
    }

    const postCategory = (category)=>{

        const filterdate = postData.filter(
            (item) => item.name === category
          );
        console.log(filterdate);
        setPostData(filterdate);

    }
    const CustomInput = forwardRef(({ value, onClick }, ref) => (
        <button className="custom-input" onClick={onClick} ref={ref}>
            Date. {value}
        </button>
    ));
    
    const purchaseCall = useCallback(async () => {
        try {
            const { ethereum } = window;

            if (ethereum) {
                const provider = new ethers.providers.Web3Provider(ethereum);
                const signer = provider.getSigner();
        
                const eventContract = new ethers.Contract(contractAddress, abi, signer);
                //const nftContract = new ethers.Contract(contractAddress, contract.abi, signer);

                const block = await provider.getBlockNumber();
                // console.log(block);

                const transferEvent = await eventContract.queryFilter('nftPurchase', 'latest' - 500, 'latest');
        
                // console.log(transferEvent,"event");

                transferEvent.map(async(item,idx)=>{
                    // postData=[];
                    setPostData([]);
                   
                    const setId = {
                        id: idx
                    };
                    const setBuyerAdr = {
                        buyerAdr: item.args.buyer
                    };

                    // const priceInWei = ethers.utils.parseEther(String(item.args.price))._hex;
                    const priceInWei = item.args.price._hex
                    // console.log(priceInWei,"price");
                    // console.log(item.args.price._hex,"가격");
                    var priceInto;
                    if(priceInWei==="0x2386f26fc10000")
                    {
                        priceInto = 0.01;
                    }
                    else if(priceInWei==="0x013fbe85edc90000")
                    {
                        priceInto = 0.04;
                    }
                    else if(priceInWei==="0x470de4df820000")
                    {
                        priceInto = 0.02;
                    }
                    else if(priceInWei==="0x8e1bc9bf040000")
                    {
                        priceInto = 0.09;
                    }
                    else {
                        priceInto = 0.09
                    }
                    const setPrice = {
                        price: priceInto
                    };
                    const tile = await eventContract.connect(signer).getTileId(Number(item.args.tileId));
                    // console.log(tile,"왜")
                    const pName= tile.planetName;
                    const setName = {
                        name: pName
                    };
                    const time = item.args.purchaseTime;
                    const timeToDate = new Date(time*1000);
                    const timeForm = timeToDate.toUTCString()
                    const tDate=moment(timeForm).format("YYYY-MM-DD");
                    const setTradeDate = {
                        tradeDate: tDate
                    };
                    const object = {
                        ...setId,
                        ...setBuyerAdr,
                        ...setPrice,
                        ...setName,
                        ...setTradeDate
                    };
                    

                    setPostData(prevList=>[...prevList, object]);
                });

            } else {
                console.log("metamast 연결 X");
            }
        } catch (error) {
            console.log(error);
        }
        console.log(postData);
    },[]);

    useEffect(()=>{
        purchaseCall();
        setDay(moment(startDate).format("YYYY-MM-DD"));
        axios
      .get(process.env.REACT_APP_SERVER_URL + '/api/planets', {})
      .then((res) => {
        const category = res.data.planet;
        setOptions((prevState) => ({
          ...prevState,
          category,
        }));
      });
        
    }, []);

    const SelectBox = (props) => {
        // console.log(props.options.category);
        return (
          <select
            className="transaction-filter-name"
            value={selectedCategory}
            onChange={(e) =>{
                    setSelectedCategory(e.target.value);
                    purchaseCall();
                    postCategory(selectedCategory);
                }
            }
          >
            <option className="transaction-filter-name-option">행성이름</option>
            {props.options.category &&
              props.options.category.map((option) => (
                <option 
                  className="transaction-filter-name-option"
                  key={option.pid}
                  value={option.name}
                >
                  {option.name}
                </option>
              ))}
          </select>
        );
      };
    return(
       <div className="transaction" style={styles}>
           <div className='transaction-filter'>
                {/* <span className='transaction-filter-name'>
                    행성이름 &nbsp;  
                    <BsFillCaretDownFill size="1.5em"/>
                </span> */}
                <SelectBox
                    options={options}
                    value={selectedCategory}
                    >
                </SelectBox>
                <span className='transaction-filter-date'>
                    <DatePicker
                        selected={startDate}
                        onChange={(date) => {setStartDate(date);  purchaseCall(); postDate();}}
                        customInput={<CustomInput />}
                        dateFormat="yyyy-MM-dd"
                        />
                </span>
           </div>
           <div className='transaction-board'>
               <table>
                   <thead>
                       <tr className='transaction-board-th'>
                           <th className='transaction-board-head num'>#</th>
                           <th className='transaction-board-head id'>아이디</th>
                           <th className='transaction-board-head money'>금액</th>
                           <th className='transaction-board-head title'>행성명</th>
                           <th className='transaction-board-head date'>거래일자</th>
                       </tr>
                   </thead>
                   <tbody className='transaction-board-tbody'>
                        {postData && postData.map((post, index) => (
                            <tr key={index} className='transaction-board-tr'>
                                <td className='transaction-board-body number'>{post.id}</td>
                                <td className='transaction-board-body'>
                                    <div className='transaction-board-body adr'>{post.buyerAdr}</div>
                                </td>
                                <td className='transaction-board-body ETH'>
                                    <img className="eth" src="../../ethereum.png" alt="ethereum" /><span className="priceText">{post.price} ETH </span>
                                </td>
                                <td className='transaction-board-body planet'>{post.name}</td>
                                <td className='transaction-board-body tradeDate'>{post.tradeDate}</td>

                            </tr>
                        ))}
                   </tbody>
               </table>
           </div>
       </div>
    );
}
export default AdminPlanetTransaction;