// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { FullMigration } from "base/migrations/FullMigration.sol";

/**
 * @title Risedle Exchange Bootstrapper
 * @author bayu <bayu@risedle.com> <https://github.com/pyk>
 * @notice Risedle Exchange Bootstrapper bootstrap the initial features on the
 *         main proxy Risedle Exchange.
 */
contract RisedleExchangeBootstrapper is FullMigration {
    constructor(address payable caller)
        public
        FullMigration(caller) {}
}
