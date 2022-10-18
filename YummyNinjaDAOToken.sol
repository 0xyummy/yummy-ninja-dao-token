// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "./ERC20Snapshot.sol";
import "./AccessControl.sol";
import "./Pausable.sol";
import "./draft-ERC20Permit.sol";
import "./ERC20Votes.sol";
import "./ERC20FlashMint.sol";

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
 
 contract YummyNinjaDAOToken is ERC20, ERC20Burnable, ERC20Snapshot, AccessControl, Pausable, ERC20Permit, ERC20Votes, ERC20FlashMint {
    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor()
        ERC20("Yummy Ninja DAO Token", "YNDT")
        ERC20Permit("Yummy Ninja DAO Token")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(SNAPSHOT_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        // 7 000 000 00000 00000 0000 0000
        //21M Maximum (ERC20Capped)
        _mint(msg.sender, 7000000 * 10 ** decimals());
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
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}
