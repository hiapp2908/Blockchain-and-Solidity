// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";


interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}


contract FundMe {
	
	address public owner;
	address[] public funders;
	mapping(address => uint256) public addressToAmountFunded;
	
	constructor() public{
		owner = msg.sender;
	}
	
	function fund() public payable {
		// $50 fees
		uint256 minimumUSD = 50*10**18;
		
		require (getConversionRate(msg.value) >= minimumUSD,"More ETH Required");
	
	
		addressToAmountFunded[msg.sender] += msg.value;
		funders.push(msg.sender);
		
		//
	}
	
	function getVersion() public view returns (uint256){
		// Getting version of the price feed for Rinkeby Testnet. 
		AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
		return priceFeed.version();
	}
	
	// Get the current price of ETH in USD
	function getPrice() public view returns (uint256) {
		AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
		(,int256 answer,,,) = priceFeed.latestRoundData();
		return uint256(answer * 10000000000);
	}
	
	function getConversionRate(uint256 ethAmount) public view returns (uint256) {
		uint256 ethPrice = getPrice();
		uint256 ethAmountInUSD = (ethPrice * ethAmount)/ 1000000000000000000;
		return ethAmountInUSD;
	}
	
	modifier onlyOwner {
		require(msg.sender == owner);
	}
	
	
	function withdraw() payable onlyOwner public {
			
		msg.sender.transfer(address(this).balance);
		for (uint256 funderIndex=0; funderIndex<funders.length; funderIndex++){
			address funder = funders[funderIndex];
			addressToAmountFunded[funder] = 0; 
		}
		
		funders = new address[](0);
	} 
		
}
