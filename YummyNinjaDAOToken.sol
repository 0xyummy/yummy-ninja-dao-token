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
// @Auther Chuci Qin 
// @Email qin@yummy.ninja
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
