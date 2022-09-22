// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./token/ERC20/ERC20Upgradeable.sol";

import "./token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "./token/ERC20/extensions/ERC20SnapshotUpgradeable.sol";
import "./token/ERC20/extensions/ERC20CappedUpgradeable.sol";
import "./token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "./token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "./token/ERC20/extensions/ERC20FlashMintUpgradeable.sol";

import "./access/AccessControlUpgradeable.sol";
import "./security/PausableUpgradeable.sol";
import "./proxy/utils/Initializable.sol";

// Yummy Ninja DAO Token ($YNDT) Source Code

/**
 * @title Yummy Ninja DAO Token ($YNDT) ERC20 token
 *
 * @notice Yummy Ninja DAO Token ($YNDT) is a core ERC20 token powering the Yummy Ninja DAO.
 *      It serves as an YummyNinja DAO Token, is tradable on exchanges,
 *      it powers up the governance protocol (Yummy Ninja DAO) and participates in Yield Farming.
 *
 * @dev Token Summary:
 *      - Symbol: YNDT
 *      - Name: Yummy Ninja DAO Token
 *      - Decimals: 18
 *      - Initial token supply: 7,000,000 YNDT
 *      - Maximum final token supply: 21,000,000 YNDT
 *          - Up to 14,000,000 YNDT may get minted in years period via yield farming / POS
 *      - Mintable: total supply may increase
 *      - Burnable: total supply may decrease
 *
 * @dev - When mint and burn?
 *          - Whenever an Yummy Ninja DAO NFT-F (Manager) is minted, decrease the total supply of $YNDT by one
 *          - Whenever an Yummy Ninja DAO NFT-F (Manager) is burned, increase the total supply of $YNDT by one
 *
 * @dev - What is NFT-F
 *          - NFT-F, Non-Fungible Token - Franchise, is a new application model of NFT. 
 *          - To put it simply, NFT-F is ERC721's NFT bound to a real economic entity.
 *          - When the physical economy corresponding to NFT-F generates real income, the corresponding funds will be transferred to the NFT-F holder's wallet address of NFT-F in real-time in the form of crypto stable coin.
 *          - This is also the first NFT application that completely breaks the barrier between online and offline, with the support of the real economy. This will be a new application across the ages.
 *
 * @author Chuci Qin
 * @author Email qin@yummy.ninja
 */

contract YummyNinjaDAOToken is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20SnapshotUpgradeable, AccessControlUpgradeable, PausableUpgradeable, ERC20PermitUpgradeable, ERC20VotesUpgradeable, ERC20FlashMintUpgradeable {
    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC20_init("Yummy Ninja DAO Token", "YNDT");
        __ERC20Burnable_init();
        __ERC20Snapshot_init();
        __AccessControl_init();
        __Pausable_init();
        __ERC20Permit_init("Yummy Ninja DAO Token");
        __ERC20Votes_init();
        __ERC20FlashMint_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(SNAPSHOT_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        // 7 000 000 00000 00000 0000 0000
        //21M Maximum (ERC20Capped)
        _mint(msg.sender, 7000000000000000000000000);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function snapshot() public onlyRole(SNAPSHOT_ROLE) {
        _snapshot();
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override(ERC20Upgradeable, ERC20SnapshotUpgradeable)
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._burn(account, amount);
    }
}
