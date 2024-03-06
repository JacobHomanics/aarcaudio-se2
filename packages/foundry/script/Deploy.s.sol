// //SPDX-License-Identifier: MIT
// pragma solidity ^0.8.19;

// import "../contracts/YourContract.sol";
// import "./DeployHelpers.s.sol";

// contract DeployScript is ScaffoldETHDeploy {
//     error InvalidPrivateKey(string);

//     address owner;

//     function run() external {
//         uint256 deployerPrivateKey = setupLocalhostEnv();
//         if (deployerPrivateKey == 0) {
//             revert InvalidPrivateKey(
//                 "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
//             );
//         }
//         vm.startBroadcast(deployerPrivateKey);

//         TOKEN_INFORMATION[] memory TOKEN_INFORMATIONS = new TOKEN_INFORMATION[](
//             2
//         );
//         TOKEN_INFORMATIONS[0].URI = "";
//         TOKEN_INFORMATIONS[0].PRICE = 1 ether;

//         // AARCAUDIO_VOLUME_1 yourContract = new AARCAUDIO_VOLUME_1();
//         // console.logString(
//         //     string.concat(
//         //         "YourContract deployed at: ",
//         //         vm.toString(address(yourContract))
//         //     )
//         // );
//         vm.stopBroadcast();

//         /**
//          * This function generates the file containing the contracts Abi definitions.
//          * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
//          * This function should be called last.
//          */
//         exportDeployments();
//     }

//     function test() public {}
// }
