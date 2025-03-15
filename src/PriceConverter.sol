// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7; // this is the solidity version

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getPrice (AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // this gets the real price of ethereum in USD without decimals like 328700000000
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // its also return other things like version, decimals etc but we dont need that so we leave those field blank
        return uint256(price * 1e10);
        // we need 18 0's so we multiply it with 10^10
        // 328700000000 * 10000000000 = 3287000000000000000000
    }

    function getConversionRate (uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        // eth price = 3287000000000000000
        uint256 ethInUsd = (ethPrice * ethAmount) / 1e18;
        // ethInUsd = (3287000000000000000 * 1000000000000000000) / 1e18 because it would give answer with 38 0's but we need 18 0's only
        return ethInUsd;
    }

    function getVersion (AggregatorV3Interface priceFeed) public view returns (uint256) {
        return priceFeed.version();
    }
}