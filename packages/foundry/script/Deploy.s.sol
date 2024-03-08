//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SONG} from "../contracts/SONG.sol";
import {PLAYLIST} from "../contracts/PLAYLIST.sol";
import {ALBUM} from "../contracts/ALBUM.sol";

import {SONG1} from "../contracts/SONGS/AARCADE RUN/SONG1.sol";
import {SONG2} from "../contracts/SONGS/AARCADE RUN/SONG2.sol";
import {SONG3} from "../contracts/SONGS/AARCADE RUN/SONG3.sol";
import {SONG4} from "../contracts/SONGS/AARCADE RUN/SONG4.sol";

import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    address owner;

    address s_artist = 0x62286D694F89a1B12c0214bfcD567bb6c2951491;
    address s_user;

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();

        // s_artist = vm.addr(1);
        s_user = vm.addr(2);
        address deployerPubKey = vm.createWallet(deployerPrivateKey).addr;

        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
        vm.startBroadcast(deployerPrivateKey);

        SONG1 song1 = new SONG1(
            s_artist,
            "NO",
            "NO",
            0.001 ether,
            "ipfs://bafkreihib5py6fn6uvbvlknnce7msb3lbc4v22wefeovi5a4cgjm7kbnnu"
        );
        console.log("Song1:", address(song1));
        SONG2 song2 = new SONG2(
            s_artist,
            "BAABY",
            "BAABY",
            0.002 ether,
            "ipfs://bafkreidrrk7k3cbawbub5paqydwxl5z4dryu2k5y77ltl6wznd5mnff2ne"
        );
        console.log("Song2:", address(song2));
        SONG3 song3 = new SONG3(
            s_artist,
            "TREES",
            "TREES",
            0.003 ether,
            "ipfs://bafkreidqqojqqi2y4uyr7v72nhii2we72q2unzsszoztb33hdcilszarf4"
        );
        console.log("Song3:", address(song3));
        SONG4 song4 = new SONG4(
            s_artist,
            "ONCE YOU FIND OUT",
            "OYFO",
            0.004 ether,
            "ipfs://bafkreigknn45ifoyd6n2rywtcekvm4xbjmn57tncazy63rqhwbwovjpzzu"
        );

        PLAYLIST playlist = new PLAYLIST(deployerPubKey);

        playlist.ADD_SONG(address(song1));
        playlist.ADD_SONG(address(song2));
        playlist.ADD_SONG(address(song3));
        playlist.ADD_SONG(address(song4));
        playlist.transferOwnership(s_artist);

        address[] memory admins = new address[](1);
        admins[0] = s_artist;

        ALBUM album = new ALBUM(
            address(playlist),
            s_artist,
            admins,
            "AARCADE RUN",
            "AAR",
            "ipfs://bafkreienrelxkykta5n5ox77mntpnuqjcgb3ddaizdngvxkp67mfafyxgm"
        );

        // AARCAUDIO_VOLUME_1 yourContract = new AARCAUDIO_VOLUME_1();
        // console.logString(
        //     string.concat(
        //         "YourContract deployed at: ",
        //         vm.toString(address(yourContract))
        //     )
        // );
        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }

    function test() public {}
}
