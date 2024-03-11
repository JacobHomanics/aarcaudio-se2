//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SONG} from "../contracts/SONG.sol";
import {PLAYLIST} from "../contracts/PLAYLIST.sol";
import {ALBUM} from "../contracts/ALBUM.sol";

// import {SONG1} from "../contracts/SONGS/AARCADE RUN/SONG1.sol";
// import {SONG2} from "../contracts/SONGS/AARCADE RUN/SONG2.sol";
// import {SONG3} from "../contracts/SONGS/AARCADE RUN/SONG3.sol";
// import {SONG4} from "../contracts/SONGS/AARCADE RUN/SONG4.sol";

import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    address owner;

    address s_artist = 0x62286D694F89a1B12c0214bfcD567bb6c2951491;
    address s_user;

    // struct SongParams {
    //     string name;
    //     string symbol;
    //     uint256 price;
    //     string uri;
    // }

    // SongParams[] songParams = [
    //     SongParams("TEST", "T", 0.001 ether, "ipfs"),
    //     SongParams("TEST", "T", 0.001 ether, "ipfs")
    // ];

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();

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
            "ipfs://bafkreiefug6orin7nzf2s26gnzn63ji4jd6r5ljoklovjd4ahlshzld63q",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );
        console.log("Song1:", address(song1));
        SONG song2 = new SONG(
            s_artist,
            "BAABY",
            "BAABY",
            0.002 ether,
            "ipfs://bafkreiglcjqxy2rhgvn6wppbqmq4kjkazwluz3duqpf2tapdfejjm5nm4i",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            75
        );
        // console.log("Song2:", address(song2));
        SONG song3 = new SONG(
            s_artist,
            "TREES",
            "TREES",
            0.003 ether,
            "ipfs://bafkreidmqjaxso62i6fkmrrldp7mksjfmzugrvsmmktaokbr5t4gahw6pe",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            50
        );
        console.log("Song3:", address(song3));
        SONG song4 = new SONG(
            s_artist,
            "ONCE YOU FIND OUT",
            "OYFO",
            0.004 ether,
            "ipfs://bafkreiefhkpgtfuhvpdxt36uirsoh42znuydcyxiybtcnfqxs2eiwkwr4y",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            125
        );

        SONG song5 = new SONG(
            s_artist,
            "MI AMOR",
            "MA",
            0.005 ether,
            "ipfs://bafkreifafpvrok2ztldajsuvwhdpvyivn3f3pck2fnkiwjwvfbh3nclmou",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            1200
        );

        SONG song6 = new SONG(
            s_artist,
            "SAY SOMETHING",
            "SS",
            0.006 ether,
            "ipfs://bafkreifujkxmbk5v5lndjz3zsogx3k7kpstk6oogkw6lm42bqffjqxs5r4",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            500
        );

        SONG song7 = new SONG(
            s_artist,
            "CLASSY ICY JUNGLE",
            "CIJ",
            0.007 ether,
            "ipfs://bafkreidtt4okddciprjcs3r722ugl22knkj235z4u7lrwtbnr76gpcpjta",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song8 = new SONG(
            s_artist,
            "SPACESHIP SWEETIE",
            "SS",
            0.008 ether,
            "ipfs://bafkreic7qea35u5kgk7basi6sabfyo5anmnoo5opi7juhwxltzpe7abcnm",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            1
        );

        SONG song9 = new SONG(
            s_artist,
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            0.009 ether,
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            100
        );

        SONG song10 = new SONG(
            s_artist,
            "MAYBE WE CAN",
            "MWC",
            0.0010 ether,
            "ipfs://bafkreid7rji3uwxcgrjpna2jvhk4ybxv72nlih4i3wt3k7555fejhrzzje",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            150
        );

        SONG song11 = new SONG(
            s_artist,
            "ARMS",
            "ARMS",
            0.0011 ether,
            "ipfs://bafkreiffwdkyldiymkio2r72y6orn5fabkxcrsvhrzf7d4yxfvx3qthcfq",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song12 = new SONG(
            s_artist,
            "I DID",
            "IDID",
            0.0012 ether,
            "ipfs://bafkreidpbay2q3fo6qbmqhfx7ql6vxk5jauji7boziw6bxfp4utgy4ymdi",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            85
        );

        SONG song13 = new SONG(
            s_artist,
            "NEON PURPLE BLACK & GREEN",
            "NPB&G",
            0.0013 ether,
            "ipfs://bafkreieza2q4fyexvkug3anxgyt75ygevbnsdrr7pryr665mlb6la2mrem",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song14 = new SONG(
            s_artist,
            "BEING WITH SOMEONE THAT DOESN'T LOVE YOU",
            "BWSTDLY",
            0.0014 ether,
            "ipfs://bafkreietfsujias47oenrz7ynpiia2uzs6fuk7fgryuvhmzhej4xfhahpe",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song15 = new SONG(
            s_artist,
            "MILLENNIAL HONEYMOON-QUIET AS THEY WATCH ME",
            "MHQATWM",
            0.0015 ether,
            "ipfs://bafkreih5dguju4nvgcpkpyhirq3vvb6kereupqf5hqlfyniwa4xcztz56m",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song16 = new SONG(
            s_artist,
            "I HOPE YOU SEE THROUGH IT ALL",
            "IHYSTIA",
            0.0016 ether,
            "ipfs://bafkreif6kbxy5snlxn4anenlmh73wwr6zgzwfdiyuuyxwhodc35bddq2tm",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song17 = new SONG(
            s_artist,
            "HOW YOU ACT TOWARDS ME",
            "HYATM",
            0.0017 ether,
            "ipfs://bafkreibvoldeqe2zylojipztwctmo5zedgyftlcdhkdotbsx5wvru7owq4",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song18 = new SONG(
            s_artist,
            "WHATEVER",
            "W",
            0.0018 ether,
            "ipfs://bafkreiazgoo62cakpwgfeg2hvjheosorzcpobkzi2zhobiodvdedpo6o3i",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song19 = new SONG(
            s_artist,
            "OH, UP HERE",
            "O,UH",
            0.0019 ether,
            "ipfs://bafkreidav3alb53fw4cxmfy6zyms7nyzjooszxve6zbiydxa2if2h4mrke",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song20 = new SONG(
            s_artist,
            "ME & YOU!",
            "M&Y!",
            0.0020 ether,
            "ipfs://bafkreidcfsjkqrgmagffir5ubfvtecixmgstzlb5l5ei7szs4wqppqbpuy",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song21 = new SONG(
            s_artist,
            "THERE'S A LEAK IN MY HEAD",
            "TALIMH",
            0.0021 ether,
            "ipfs://bafkreiby27v5gnb5is2iyd6pvut25lmvot4biwajs5qxix5tdi27snyv5e",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song22 = new SONG(
            s_artist,
            "OOPS WE'RE DROWNING LOL",
            "OWDL",
            0.0022 ether,
            "ipfs://bafkreih77kvsjqrdsf2733w3jqykkxi2fjq5bgtbcbicvwrmfilrepx55a",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song23 = new SONG(
            s_artist,
            "RUNAWAY SWIM (WITH ME)",
            "",
            0.0023 ether,
            "ipfs://bafkreiaetzcdzmlpgxbbzwwu2ilxgcbirwzp5mcop5n2d3meomkb2da4oe",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song24 = new SONG(
            s_artist,
            "INSPIRATION ODYSSEY",
            "IO",
            0.0024 ether,
            "ipfs://bafkreicdwgrl2igi4e7tnentl6o5sn23f5p7jszfz2slph4kqvt73w2vlu",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song25 = new SONG(
            s_artist,
            "I MESS EVERYTHING UP",
            "IMEU",
            0.0025 ether,
            "ipfs://bafkreifuy64hjmrw4wcdf6mzuwraqhfme4np52heq4zikigfubhf5e6lqa",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song26 = new SONG(
            s_artist,
            "FOREVER",
            "F",
            0.0026 ether,
            "ipfs://bafkreig3nwkvpopgmpgab2ryzk43etdya4vnd4utmrcwsiz2wr2pibc7fy",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song27 = new SONG(
            s_artist,
            "ARC",
            "A",
            0.0027 ether,
            "ipfs://bafkreib2hjghn766wqdfrji3j2kuzff4nb237yppt7tirqfw6ag5ebjs2m",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        SONG song28 = new SONG(
            s_artist,
            "UNTIL NEXT TIME",
            "UNT",
            0.0028 ether,
            "ipfs://bafkreihasccyhx34e2id3boulzencqi2u2x3lmik6dn2wkcfuuk2zcfbsy",
            0x694AA1769357215DE4FAC081bf1f309aDC325306,
            25
        );

        PLAYLIST playlist = new PLAYLIST(deployerPubKey);

        address[] memory songs = new address[](28);
        songs[0] = address(song1);
        songs[1] = address(song2);
        songs[2] = address(song3);
        songs[3] = address(song4);
        songs[4] = address(song5);
        songs[5] = address(song6);
        songs[6] = address(song7);
        songs[7] = address(song8);
        songs[8] = address(song9);
        songs[9] = address(song10);
        songs[10] = address(song11);
        songs[11] = address(song12);
        songs[12] = address(song13);
        songs[13] = address(song14);
        songs[14] = address(song15);
        songs[15] = address(song16);
        songs[16] = address(song17);
        songs[17] = address(song18);
        songs[18] = address(song19);
        songs[19] = address(song20);
        songs[20] = address(song21);
        songs[21] = address(song22);
        songs[22] = address(song23);
        songs[23] = address(song24);
        songs[24] = address(song25);
        songs[25] = address(song26);
        songs[26] = address(song27);
        songs[27] = address(song28);

        playlist.ADD_SONGS_BATCH(songs);

        // playlist.ADD_SONG(address(song1));
        // playlist.ADD_SONG(address(song2));
        // playlist.ADD_SONG(address(song3));
        // playlist.ADD_SONG(address(song4));
        // playlist.ADD_SONG(address(song5));
        // playlist.ADD_SONG(address(song6));
        // playlist.ADD_SONG(address(song7));
        // playlist.ADD_SONG(address(song8));
        // playlist.ADD_SONG(address(song9));
        // playlist.ADD_SONG(address(song10));
        // playlist.ADD_SONG(address(song11));
        // playlist.ADD_SONG(address(song12));
        // playlist.ADD_SONG(address(song13));
        // playlist.ADD_SONG(address(song14));
        // playlist.ADD_SONG(address(song15));
        // playlist.ADD_SONG(address(song16));
        // playlist.ADD_SONG(address(song17));
        // playlist.ADD_SONG(address(song18));
        // playlist.ADD_SONG(address(song19));
        // playlist.ADD_SONG(address(song20));
        // playlist.ADD_SONG(address(song21));
        // playlist.ADD_SONG(address(song22));
        // playlist.ADD_SONG(address(song23));
        // playlist.ADD_SONG(address(song24));
        // playlist.ADD_SONG(address(song25));
        // playlist.ADD_SONG(address(song26));
        // playlist.ADD_SONG(address(song27));
        // playlist.ADD_SONG(address(song28));
        // playlist.transferOwnership(s_artist);

        address[] memory admins = new address[](1);
        admins[0] = s_artist;

        new ALBUM(
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
