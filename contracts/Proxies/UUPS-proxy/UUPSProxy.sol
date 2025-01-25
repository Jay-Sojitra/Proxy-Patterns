// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title UUPS Proxy Contract
/// @notice This is the proxy contract to work with UUPS upgradeable implementations
contract UUPSProxy is ERC1967Proxy {
    constructor(address _implementation, bytes memory _data) ERC1967Proxy(_implementation, _data) payable {}
}

/// @title ImplementationOne
/// @notice First version of the UUPS upgradeable implementation
contract ImplementationOne is UUPSUpgradeable, OwnableUpgradeable {
    /// @dev Disable initializers to prevent reinitialization of the contract
    constructor() {
        _disableInitializers();
    }

    /// @dev Initializer function to replace constructor for upgradeable contracts
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function myNumber() public pure returns (uint256) {
        return 1; 
    }

    /// @dev Authorizes the upgrade, restricted to the owner
    /// @param _newImplementation Address of the new implementation
    function _authorizeUpgrade(address _newImplementation) internal override onlyOwner {
        // Custom logic (if needed) to verify the new implementation address
        require(_newImplementation != address(0), "Invalid implementation address");
    }
}

/// @title ImplementationTwo
/// @notice Second version of the UUPS upgradeable implementation
contract ImplementationTwo is UUPSUpgradeable, OwnableUpgradeable {
    /// @dev Disable initializers to prevent reinitialization of the contract
    constructor() {
        _disableInitializers();
    }

    /// @dev Initializer function to replace constructor for upgradeable contracts
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    /// @notice Returns the number 2 (for demonstration purposes)
    function myNumber() public pure returns (uint256) {
        return 2; 
    }

    /// @dev Authorizes the upgrade, restricted to the owner
    /// @param _newImplementation Address of the new implementation
    function _authorizeUpgrade(address _newImplementation) internal override onlyOwner {
        // Custom logic (if needed) to verify the new implementation address
        require(_newImplementation != address(0), "Invalid implementation address");
    }
}
