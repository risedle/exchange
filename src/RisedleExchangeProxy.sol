// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @title Risedle Exchange Proxy
 * @author bayu <bayu@risedle.com> <https://github.com/pyk>
 *
 * Risedle Exchange Proxy settles the trade order onchain.
 *
 * ┌────────┐   ┌───────────────────┐   ┌───────────────────┐   ┌─────┐
 * │ sender ├──►│   bytes[] data    ├──►│  Risedle Exchange ├──►│ DEX │
 * └────────┘   ├───────────────────┤   ├───────────────────┤   └──┬──┘
 *      ▲       │ wrap()            │   │ settle(data)      │      │
 *      │       │ swapViaUniswapV2()│   └───────────────────┘      │
 *      │       │ swapViaCurve()    │                              │
 *      │       │ checkSlippage()   │                              │
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
contract RisedleExchangeProxy {

    constructor(address owner) {
        _transferOwnership(owner);
    }
}

