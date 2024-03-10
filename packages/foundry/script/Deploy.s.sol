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

        SONG song1 = new SONG(
            s_artist,
            "NO",
            "NO",
            0.001 ether,
            "ipfs://bafkreiefug6orin7nzf2s26gnzn63ji4jd6r5ljoklovjd4ahlshzld63q"
        );
        console.log("Song1:", address(song1));
        SONG song2 = new SONG(
            s_artist,
            "BAABY",
            "BAABY",
            0.002 ether,
            "ipfs://bafkreiglcjqxy2rhgvn6wppbqmq4kjkazwluz3duqpf2tapdfejjm5nm4i"
        );
        console.log("Song2:", address(song2));
        SONG song3 = new SONG(
            s_artist,
            "TREES",
            "TREES",
            0.003 ether,
            "ipfs://bafkreidmqjaxso62i6fkmrrldp7mksjfmzugrvsmmktaokbr5t4gahw6pe"
        );
        console.log("Song3:", address(song3));
        SONG song4 = new SONG(
            s_artist,
            "ONCE YOU FIND OUT",
            "OYFO",
            0.004 ether,
            "ipfs://bafkreiefhkpgtfuhvpdxt36uirsoh42znuydcyxiybtcnfqxs2eiwkwr4y"
        );

        SONG song5 = new SONG(
            s_artist,
            "MI AMOR",
            "MA",
            0.005 ether,
            "ipfs://bafkreifafpvrok2ztldajsuvwhdpvyivn3f3pck2fnkiwjwvfbh3nclmou"
        );

        SONG song6 = new SONG(
            s_artist,
            "SAY SOMETHING",
            "SS",
            0.006 ether,
            "ipfs://bafkreifujkxmbk5v5lndjz3zsogx3k7kpstk6oogkw6lm42bqffjqxs5r4"
        );

        SONG song7 = new SONG(
            s_artist,
            "CLASSY ICY JUNGLE",
            "CIJ",
            0.007 ether,
            "ipfs://bafkreidtt4okddciprjcs3r722ugl22knkj235z4u7lrwtbnr76gpcpjta"
        );

        SONG song8 = new SONG(
            s_artist,
            "SPACESHIP SWEETIE",
            "SS",
            0.008 ether,
            "ipfs://bafkreic7qea35u5kgk7basi6sabfyo5anmnoo5opi7juhwxltzpe7abcnm"
        );

        SONG song9 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.009 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song10 = new SONG(
            s_artist,
            "MAYBE WE CAN",
            "MWC",
            0.0010 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song11 = new SONG(
            s_artist,
            "ARMS",
            "ARMS",
            0.0011 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song12 = new SONG(
            s_artist,
            "I DID",
            "IDID",
            0.0012 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song13 = new SONG(
            s_artist,
            "NEON PURPLE BLACK & GREEN",
            "NPB&G",
            0.0013 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song14 = new SONG(
            s_artist,
            "BEING WITH SOMEONE THAT DOESN'T LOVE YOU",
            "BWSTDLY",
            0.0014 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song15 = new SONG(
            s_artist,
            "MILLENNIAL HONEYMOON-QUIET AS THEY WATCH ME",
            "MHQATWM",
            0.0015 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song16 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0016 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song17 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0017 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song18 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0018 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song19 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0019 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song20 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0020 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song21 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0021 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song22 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0022 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song23 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0023 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song24 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0024 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song25 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0025 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song26 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0026 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song27 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0027 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );

        SONG song28 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.0028 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4"
        );
        PLAYLIST playlist = new PLAYLIST(deployerPubKey);

        playlist.ADD_SONG(address(song1));
        playlist.ADD_SONG(address(song2));
        playlist.ADD_SONG(address(song3));
        playlist.ADD_SONG(address(song4));
        playlist.ADD_SONG(address(song5));
        playlist.ADD_SONG(address(song6));
        playlist.ADD_SONG(address(song7));
        playlist.ADD_SONG(address(song8));
        playlist.ADD_SONG(address(song9));
        playlist.transferOwnership(s_artist);

        address[] memory admins = new address[](1);
        admins[0] = s_artist;

        ALBUM album = new ALBUM(
            address(playlist),
            s_artist,
            admins,
            "AARCADE RUN",
            "AAR",
            "ipfs://bafkreienrelxkykta5n5ox77mntpnuqjcgb3ddaizdngvxkp67mfafyxgm",
            "ipfs://bafkreid6latbk2ygomuz5jzdezxoqokdvsxh5puj6k66e3o5zym6acnhh4"
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
