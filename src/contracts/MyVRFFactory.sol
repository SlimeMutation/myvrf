// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./vrf/MyVRFManager.sol";


contract MyVRFFactory {
    event ProxyCreated(address mintProxyAddress);

    function createProxy(address implementation, address dapplinkAddress, address blsRegistry) external returns (address) {
        address mintProxyAddress = Clones.clone(implementation);
        MyVRFManager(mintProxyAddress).initialize(msg.sender, dapplinkAddress, blsRegistry);
        emit ProxyCreated(mintProxyAddress);
        return mintProxyAddress;
    }
}
