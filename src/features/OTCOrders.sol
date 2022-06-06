// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { OtcOrdersFeature } from "base/features/OtcOrdersFeature.sol";
import { IEtherTokenV06 } from "@0x/contracts-erc20/contracts/src/v06/IEtherTokenV06.sol";

/**
 * @title OTCOrders
 * @notice Deploy OTCOrders using foundry
 */
contract OTCOrders is OtcOrdersFeature {
    constructor(address zeroEx, IEtherTokenV06 weth)
        public
        OtcOrdersFeature(zeroEx, weth) {}
}
