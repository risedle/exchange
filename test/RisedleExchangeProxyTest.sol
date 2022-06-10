// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import { WETH } from "solmate/tokens/WETH.sol";

import { RisedleExchangeProxy } from "src/RisedleExchangeProxy.sol";

/// @notice Dummy feature
contract DummyFeature {
    function add(uint256 _a, uint256 _b) public returns (uint256) {
        return _a + _b;
    }

    function sub(uint256 _a, uint256 _b) public returns (uint256) {
        return _a - _b;
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
        WETH _weth,
        RisedleExchangeProxy _rx
    ) {
        _owner = vm.addr(1);
        _weth = WETH(payable(vm.addr(2)));
        _rx = new RisedleExchangeProxy(_owner, _weth);
    }

    /// ███ Constructor ██████████████████████████████████████████████████████

    /// @notice Make sure the default storages are set
    function testConstuctor() public {
        // Deploy Risedle Exchange Proxy
        (address owner, WETH weth, RisedleExchangeProxy rx) = deploy();

        // Check owner
        assertEq(rx.owner(), owner, "invalid owner");

        // Check weth
        assertEq(address(rx.weth()), address(weth), "invalid weth");
    }


    /// ███ Registry █████████████████████████████████████████████████████████

    /// @notice Make sure it reverts if the caller is not the owner
    function testRegisterRevertIfCallerIsNotOwner() public {
        // Deploy Risedle Exchange Proxy
        (, , RisedleExchangeProxy rx) = deploy();

        // Deploy dummy feature
        DummyFeature f = new DummyFeature();

        // Trying to register function as non-owner
        vm.expectRevert("UNAUTHORIZED");
        rx.register(f.add.selector, address(f));
    }

    /// @notice Make sure it reverts if implementation address is zero
    function testRegisterRevertIfImplementationIsZeroAddress() public {
        // Deploy Risedle Exchange Proxy
        (address owner, , RisedleExchangeProxy rx) = deploy();

        // Deploy dummy feature
        DummyFeature f = new DummyFeature();

        // Trying to register zero address as implementation
        hoax(owner, 1 ether);
        vm.expectRevert(
            abi.encodeWithSelector(
                RisedleExchangeProxy.InvalidImplementation.selector
            )
        );
        rx.register(f.add.selector, address(0));
    }

    /// @notice Make sure can call implementation
    function testRegisterFunction() public {
        // Deploy Risedle Exchange Proxy
        (address owner, , RisedleExchangeProxy rx) = deploy();

        // Deploy dummy feature
        DummyFeature f = new DummyFeature();

        // Trying to register zero address as implementation
        hoax(owner, 1 ether);
        rx.register(f.add.selector, address(f));

        // Call the function as proxy
        uint256 r = DummyFeature(address(rx)).add(1, 1);
        assertEq(r, 2);
    }

    /// @notice Make sure it reverts if the caller is not the owner
    function testRegisterBatchRevertIfCallerIsNotOwner() public {
        // Deploy Risedle Exchange Proxy
        (, , RisedleExchangeProxy rx) = deploy();

        // Deploy dummy feature
        DummyFeature f = new DummyFeature();

        // Inputs
        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = f.add.selector;
        selectors[1] = f.sub.selector;
        address[] memory implementations = new address[](2);
        implementations[0] = address(f);
        implementations[1] = address(f);

        // Trying to register function as non-owner
        vm.expectRevert("UNAUTHORIZED");
        rx.register(selectors, implementations);
    }

    /// @notice Make sure it reverts if implementation is zero address
    function testRegisterBatchRevertIfImplementationIsZeroAddress() public {
        // Deploy Risedle Exchange Proxy
        (address owner, , RisedleExchangeProxy rx) = deploy();

        // Deploy dummy feature
        DummyFeature f = new DummyFeature();

        // Inputs
        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = f.add.selector;
        selectors[1] = f.sub.selector;
        address[] memory implementations = new address[](2);
        implementations[0] = address(0);
        implementations[1] = address(0);

        // Trying to register function as non-owner
        hoax(owner, 1 ether);
        vm.expectRevert(
            abi.encodeWithSelector(
                RisedleExchangeProxy.InvalidImplementation.selector
            )
        );
        rx.register(selectors, implementations);
    }

    /// @notice Make sure can call implementation
    function testRegisterBatchFunctions() public {
        // Deploy Risedle Exchange Proxy
        (address owner, , RisedleExchangeProxy rx) = deploy();

        // Deploy dummy feature
        DummyFeature f = new DummyFeature();

        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = f.add.selector;
        selectors[1] = f.sub.selector;
        address[] memory implementations = new address[](2);
        implementations[0] = address(f);
        implementations[1] = address(f);

        // Trying to register zero address as implementation
        hoax(owner, 1 ether);
        rx.register(selectors, implementations);

        // Call the function as proxy
        uint256 a = DummyFeature(address(rx)).add(1, 1);
        assertEq(a, 2);

        uint256 s = DummyFeature(address(rx)).sub(2, 1);
        assertEq(s, 1);
    }
}
