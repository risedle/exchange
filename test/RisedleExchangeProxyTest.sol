// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import { RisedleExchangeProxy } from "src/RisedleExchangeProxy.sol";

/// @notice Dummy feature
contract DummyFeature {
    function add(uint256 _a, uint256 _b) public returns (uint256) {
        return _a + _b;
    }

    function minus(uint256 _a, uint256 _b) public returns (uint256) {
        reutrn _a - _b;
    }
}

/**
 * @title Risedle Exchange Proxy Test
 * @author bayu <bayu@risedle.com> <https://github.com/pyk>
 * @notice Test proxy functionalities
 */
contract RisedleExchangeProxyTest is Test {

    /// @notice Deploy Risedle Exchange Proxy contract
    function deploy() internal returns (
        address _owner,
        address _weth,
        RisedleExchangeProxy rx
    ) {
        _owner = vm.addr(1);
        _weth = vm.addr(2);
        _rx = new RisedleExchangeProxy(_owner, _weth);
    }

    /// ███ Constructor ██████████████████████████████████████████████████████

    /// @notice Make sure the default storages are set
    function testConstuctor() public {
        // Deploy Risedle Exchange Proxy
        (address owner, address weth, RisedleExchangeProxy rx) = deploy();

        // Check owner
        assertEq(rx.owner(), owner, "invalid owner");

        // Check weth
        assertEq(rx.weth(), weth, "invalid weth");
    }


    /// ███ Registry █████████████████████████████████████████████████████████

    /// @notice Make sure it reverts if the caller is not the owner
    function testRegisterRevertIfCallerIsNotOwner() public {
        // Deploy Risedle Exchange Proxy
        (address owner, address weth, RisedleExchangeProxy rx) = deploy();
        RisedleExchangeProxy rx = new RisedleExchangeProxy(owner, weth);

        // Deploy dummy feature
        DummyFeature f = new DummyFeature();

        // Trying to register function as non-owner
        vm.expectRevert("UNAUTHORIZED");
        rx.register(f.add.selector, address(f));
    }

    function testRegisterRevertIfImplementationIsZeroAddress() public {
        // Deploy dummy feature
        DummyFeature f = new DummyFeature();


    }
}
