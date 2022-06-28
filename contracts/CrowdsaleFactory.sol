// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./interfaces/ICrowdsale.sol";

contract CrowdsaleFactory is Ownable, ReentrancyGuard {
    address public exampleCrowdsale; //not immmutable so we can change realisation of crowdsale

    event CrowdsaleCreated(address creator, address crowdsaleAddress);

    //нельзя задать example через конструктор, т.к. в констукторе краудсейла мы указываем фабрику.
    function setExampleCrowdsale(address _exampleCrowdsale) external {
        require(
            address(_exampleCrowdsale) != address(0),
            "example address can't be 0"
        );
        exampleCrowdsale = _exampleCrowdsale;
    }

    function createCrowdsale(
        IERC20Metadata _saleToken,
        IERC20Metadata _paymentToken,
        IStake _stake,
        uint256 _saleTokenAmount,
        uint256 _dexTokenPercent,
        uint256 _price,
        uint256[5] memory _levelPoolPercent //from platinum to iron
    ) external nonReentrant returns (ICrowdsale newCrowdsale) {
        require(
            address(exampleCrowdsale) != address(0),
            "Example isn't initialized"
        );
        address sender = _msgSender();
        newCrowdsale = ICrowdsale(Clones.clone(exampleCrowdsale));
        newCrowdsale.initialize(
            sender,
            _saleToken,
            _paymentToken,
            _stake,
            _saleTokenAmount,
            _dexTokenPercent,
            _price,
            _levelPoolPercent
        );
        SafeERC20.safeTransferFrom(
            _saleToken,
            sender,
            address(newCrowdsale),
            _saleTokenAmount + (_saleTokenAmount * _dexTokenPercent) / 100
        );
        emit CrowdsaleCreated(sender, address(newCrowdsale));
    }
}
