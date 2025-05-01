// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin-upgrades/contracts/proxy/utils/Initializable.sol";

import "../../interface/IBLSApkRegistry.sol";
import "../../libraries/BN254.sol";

abstract contract BLSApkRegistryStorage is IBLSApkRegistry, Initializable {

    // Constants
    bytes32 internal constant ZERO_PK_HASH = hex"ad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5";
    bytes32 public constant PUBKEY_REGISTRATION_TYPEHASH = keccak256("BN254PubkeyRegistration(address operator)");

    address public whitelistManager;
    address public vrfManagerAddress;

    // State variables
    mapping(address => bytes32) public operatorToPubkeyHash;
    mapping(bytes32 => address) public pubkeyHashToOperator;
    mapping(address => BN254.G1Point) public operatorToPubkey;

    BN254.G1Point public currentApk;
    ApkUpdate[] public apkHistory;

    mapping(address => bool) public blsRegisterWhitelist;

}