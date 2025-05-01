// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin-upgrades/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin-upgrades/contracts/access/OwnableUpgradeable.sol";

import "./MyVRFStorage.sol";
import "../../interface/IMyVRFManager.sol";

contract MyVRFManager is Initializable, OwnableUpgradeable, IMyVRFManager, MyVRFStorage {
    event RequestSent(uint256 requestId, uint256 _numWords, address current);

    event FillRandomWords(uint256 requestId, uint256[] randomWords);
    
    modifier onlyDapplink() {
        require(msg.sender == dapplinkAddress, "Only Dapplink can call this function");
        _;
    }

    constructor() {
        _disableInitializers();
    }

    function initialize(address _owner, address _dapplinkAddress, address _blsRegistry) public initializer {
        __Ownable_init(_owner);
        dapplinkAddress = _dapplinkAddress;
        blsRegistry = IBLSApkRegistry(_blsRegistry);
    }

    function requestRandomWords(uint256 _requestId, uint256 _numwords) external override onlyOwner {
        requestMapping[_requestId] = RequestStatus({
            randomWords: new uint256[](0),
            fulfilled: false
        });

        requestIds.push(_requestId);
        lastRequestId = _requestId;
        emit RequestSent(_requestId, _numwords, address(this));        
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords, bytes32 msgHash, uint256 referencedBlockNumber, IBLSApkRegistry.VrfNoSignerAndSignature memory params) external override onlyDapplink {
        blsRegistry.checkSignature(msgHash, referencedBlockNumber, params);
        
        requestMapping[_requestId] = RequestStatus({
            randomWords: _randomWords,
            fulfilled: true
        });
        emit FillRandomWords(_requestId, _randomWords);
    }

    function getRequestStatus(uint256 _requestId) external view override returns (bool fulfilled, uint256[] memory randomWords) {
        return (requestMapping[_requestId].fulfilled, requestMapping[_requestId].randomWords);
    }

    function setDapplink(address _dapplinkAddress) external override onlyOwner {
        dapplinkAddress = _dapplinkAddress;
    }
}