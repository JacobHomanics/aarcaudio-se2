// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/AggregatorV2V3Interface.sol";
import "forge-std/Test.sol";

contract MockAggregatorV2V3Interface {
    int256 s_answer;
    uint256 s_startedAt;

    constructor(int256 answer, uint256 startedAt) {
        s_answer = answer;
        s_startedAt = startedAt;
    }

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (1, s_answer, s_startedAt, 5678, 12);
    }

    function setAnswer(int256 answer) external {
        s_answer = answer;
    }

    function setStartedAt(uint256 startedAt) external {
        s_startedAt = startedAt;
    }
}
