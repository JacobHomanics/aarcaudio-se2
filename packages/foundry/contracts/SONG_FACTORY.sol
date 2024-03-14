// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

import {SONG} from "./SONG.sol";

contract SONG_FACTORY is AccessControl {
    bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");

    address public implementation;

    uint256 public contractInstanceCount;
    mapping(uint256 => SONG) public instances;

    event CreatedNewInstance(address);

    constructor(
        address[] memory _admins,
        address[] memory _controllers,
        address _implementation
    ) {
        for (uint256 i = 0; i < _admins.length; i++) {
            _grantRole(DEFAULT_ADMIN_ROLE, _admins[i]);
        }

        for (uint256 i = 0; i < _controllers.length; i++) {
            _grantRole(DEPLOYER_ROLE, _controllers[i]);
        }

        if (_implementation != address(0)) {
            implementation = _implementation;
        }
    }

    function createNewInstance(
        address OWNER,
        string memory NAME,
        string memory SYMBOL,
        string memory URI,
        address DATA_FEED,
        address SEQUENCER_UPTIME_FEED,
        uint256 CENTS,
        address[] memory ADMINS,
        uint256 GRACE_PERIOD_TIME
    ) external onlyRole(DEPLOYER_ROLE) returns (address instanceAddress) {
        address clone = Clones.clone(address(implementation));

        SONG instance = SONG(clone);

        instance.initialize(
            OWNER,
            NAME,
            SYMBOL,
            URI,
            DATA_FEED,
            SEQUENCER_UPTIME_FEED,
            CENTS,
            ADMINS,
            GRACE_PERIOD_TIME
        );

        instances[contractInstanceCount] = instance;
        contractInstanceCount++;

        emit CreatedNewInstance(address(instance));

        instanceAddress = address(instance);
    }
}
