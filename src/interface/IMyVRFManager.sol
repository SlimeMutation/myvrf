// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./IBLSApkRegistry.sol";

interface IMyVRFManager {
    function requestRandomWords(uint256 _requestId, uint256 _numwords) external;
    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords, bytes32 msgHash, uint256 referencedBlockNumber, IBLSApkRegistry.VrfNoSignerAndSignature memory params) external;
    function getRequestStatus(uint256 _requestId) external view returns (bool fulfilled, uint256[] memory randomWords);
    function setDapplink(address _dapplinkAddress) external;
}