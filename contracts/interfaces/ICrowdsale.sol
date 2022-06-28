// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "./IStake.sol";

interface ICrowdsale {
    event crowdsaleStarted();
    event crowdsaleFinished();
    event tokenPurchased(address buyer, uint256 amount);
    event tokenClaimed(address user, uint256 amount);
    event ownerClaimed(uint256 saleTokenAmount, uint256 paymentTokenAmount);

    function initialize(
        address _owner,
        IERC20Metadata _saleToken,
        IERC20Metadata _paymentToken,
        IStake _stake,
        uint256 _saleTokenAmount,
        uint256 _dexTokenPercent,
        uint256 _price,
        uint256[5] memory _levelPoolPercent
    ) external;

    function startCrowdsale() external;

    function finishCrowdsale() external;

    function buy(uint256 _amount) external;

    function claim() external;

    function claimForOwner() external;
}
