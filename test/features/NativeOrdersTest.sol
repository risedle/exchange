// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.0;

import "forge-std/Test.sol";

import { RisedleExchangeBootstrapper } from "src/RisedleExchangeBootstrapper.sol";
import { RisedleExchange } from "src/RisedleExchange.sol";
import { NativeOrders } from "src/features/NativeOrders.sol";

contract NativeOrdersTest is Test {

    /// ███ constructor ██████████████████████████████████████████████████████

    /// @notice Make sure it can be deployed
    function testConstructor() public {
        // Create new Risedle Exchange
        address payable initializer = payable(address(this));
        RisedleExchangeBootstrapper b = new RisedleExchangeBootstrapper(
            initializer
        );
        RisedleExchange rx = new RisedleExchange(address(b));

        // Deploy the NativeOrders
        NativeOrders no = new NativeOrders(address(rx));

        // Check values
        assertEq(no.FEATURE_NAME(), "LimitOrders");
        assertEq(no.FEATURE_VERSION(), 18446744090889420800);
    }
}
