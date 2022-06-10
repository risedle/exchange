// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import { Owned } from "solmate/auth/owned.sol";
import { WETH } from "solmate/tokens/WETH.sol";

/**
 * @title Risedle Exchange Proxy
 * @author bayu <bayu@risedle.com> <https://github.com/pyk>
 *
 * Risedle Exchange Proxy settles the trade order on-chain.
 *
 * ┌────────┐   ┌───────────────────┐   ┌───────────────────┐   ┌─────┐
 * │ sender ├──►│   bytes[] data    ├──►│  Risedle Exchange ├──►│ DEX │
 * └────────┘   ├───────────────────┤   ├───────────────────┤   └──┬──┘
 *      ▲       │ wrap()            │   │ settle(data)      │      │
 *      │       │ swapViaUniswapV2()│   └───────────────────┘      │
 *      │       │ swapViaCurve()    │                              │
 *      │       └───────────────────┘                              │
 *      │                                                          │
 *      └──────────────────────────────────────────────────────────┘
 *
 * This contract will have different set of features on every chain.
 * For example on ethereum mainnet there is no margin trading features.
 *
 * The complete set of features for each chain is available in `chains/`
 * directory.
 *
 * The owner of this contract can upgrade the feature via `register` function.
 */
contract RisedleExchangeProxy is Owned {

    /// ███ Storages █████████████████████████████████████████████████████████

    /// @notice Map feature function selector to its implementation
    mapping(bytes4 => address) public registry;

    /// @notice WETH address
    WETH public immutable weth;


    /// ███ Events ███████████████████████████████████████████████████████████

    /// @notice Event emitted when proxy function registered
    event ProxyFunctionUpdated(bytes4 selector, address prev, address now);


    /// ███ Errors ███████████████████████████████████████████████████████████

    /// @notice Error raised if function implementation is invalid
    error InvalidImplementation();

    /// @notice Error raised if batch input is invalid
    error InvalidRegisterInputs();

    /// @notice Error raised if function is not implemented
    error FunctionNotImplemented();


    /// ███ Constructor ██████████████████████████████████████████████████████

    constructor(address _owner, WETH _weth) Owned(_owner) {
        weth = _weth;
    }


    /// ███ Registry █████████████████████████████████████████████████████████

    /// @notice Register or replace a function
    /// @param _selector The function selector
    /// @param _impl The implementation address
    function register(bytes4 _selector, address _impl) public onlyOwner {
        if (_impl == address(0)) revert InvalidImplementation();
        address prev = registry[_selector];
        registry[_selector] = _impl;
        emit ProxyFunctionUpdated(_selector, prev, _impl);
    }


    /// @notice Batch register a functions
    /// @param _selectors The array of function selectors
    /// @param _impls The array of implementation address
    function register(
        bytes4[] calldata _selectors,
        address[] calldata _impls
    ) external {
        if (_selectors.length != _impls.length) revert InvalidRegisterInputs();
        for (uint256 i = 0; i < _selectors.length; i++) {
            register(_selectors[i], _impls[i]);
        }
    }


    /// ███ Proxy ████████████████████████████████████████████████████████████

    /// @notice Forward call to the implementation contract
    fallback() external payable {
        bytes4 selector = msg.sig;
        address impl = registry[selector];
        if (impl == address(0)) revert FunctionNotImplemented();
        (bool success, bytes memory data) = impl.delegatecall(msg.data);
        if (!success) {
            assembly { revert(add(data, 32), mload(data)) }
        }
        assembly { return(add(data, 32), mload(data)) }
    }

}

