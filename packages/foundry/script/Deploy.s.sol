//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SONG} from "../contracts/SONG.sol";
import {PLAYLIST} from "../contracts/PLAYLIST.sol";
import {ALBUM} from "../contracts/ALBUM.sol";
import {MockAggregatorV2V3Interface} from "../contracts/chainlink/mocks/MockAggregatorV2V3Interface.sol";

import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    address owner;

    struct SONG_PARAMS {
        string NAME;
        string SYMBOL;
        string URI;
        uint256 CENTS;
        uint256 GRACE_PERIOD;
    }

    function setUpDeployments()
        private
        returns (
            address songOwner,
            address albumOwner,
            address playlistOwner,
            address aggregator,
            address sequencerUptimeFeed
        )
    {
        uint256 id;
        assembly {
            id := chainid()
        }

        //localhost
        if (id == 31337) {
            songOwner = 0x193aDC5c5eFB2Cf8ddBEA1F23878B46E4Df86d06;
            albumOwner = 0x193aDC5c5eFB2Cf8ddBEA1F23878B46E4Df86d06;
            playlistOwner = 0x193aDC5c5eFB2Cf8ddBEA1F23878B46E4Df86d06;
            aggregator = address(
                new MockAggregatorV2V3Interface(400000000000, 0)
            );
            sequencerUptimeFeed = address(0);
        }
        //sepolia
        else if (id == 11155111) {
            songOwner = 0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf;
            albumOwner = 0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf;
            playlistOwner = 0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf;
            aggregator = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
            sequencerUptimeFeed = address(0);
        }
        //base sepolia
        else if (id == 84532) {
            songOwner = 0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf;
            albumOwner = 0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf;
            playlistOwner = 0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf;

            aggregator = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1;
            sequencerUptimeFeed = address(0);
        }
        // base mainnet
        else if (id == 8453) {
            songOwner = 0xc689c800a7121b186208ea3b182fAb2671B337E7;
            albumOwner = 0xc689c800a7121b186208ea3b182fAb2671B337E7;
            playlistOwner = 0xc689c800a7121b186208ea3b182fAb2671B337E7;
            aggregator = 0x71041dddad3595F9CEd3DcCFBe3D1F4b0a16Bb70;
            sequencerUptimeFeed = 0xBCF85224fc0756B9Fa45aA7892530B47e10b6433;
        }
    }

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        address deployerPubKey = vm.createWallet(deployerPrivateKey).addr;
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
        vm.startBroadcast(deployerPrivateKey);

        PLAYLIST playlist = new PLAYLIST(deployerPubKey);
        vm.roll(block.number + 1);

        (
            address songOwner,
            address albumOwner,
            address playlistOwner,
            address aggregator,
            address sequencerUptimeFeed
        ) = setUpDeployments();

        ALBUM album = new ALBUM(
            address(playlist),
            albumOwner,
            "AARCADE RUN",
            "AAR",
            "ipfs://bafkreienrelxkykta5n5ox77mntpnuqjcgb3ddaizdngvxkp67mfafyxgm",
            "ipfs://bafkreid6latbk2ygomuz5jzdezxoqokdvsxh5puj6k66e3o5zym6acnhh4",
            aggregator,
            sequencerUptimeFeed,
            600
        );
        vm.roll(block.number + 1);

        uint256 CENTS = 25;
        uint256 GRACE_PERIOD = 3600;
        SONG_PARAMS[] memory PARAMS = new SONG_PARAMS[](28);
        PARAMS[0] = SONG_PARAMS(
            "NO",
            "NO",
            "ipfs://bafkreiefug6orin7nzf2s26gnzn63ji4jd6r5ljoklovjd4ahlshzld63q",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[1] = SONG_PARAMS(
            "BAABY",
            "BAABY",
            "ipfs://bafkreiglcjqxy2rhgvn6wppbqmq4kjkazwluz3duqpf2tapdfejjm5nm4i",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[2] = SONG_PARAMS(
            "TREES",
            "TREES",
            "ipfs://bafkreidmqjaxso62i6fkmrrldp7mksjfmzugrvsmmktaokbr5t4gahw6pe",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[3] = SONG_PARAMS(
            "ONCE YOU FIND OUT",
            "OYFO",
            "ipfs://bafkreiefhkpgtfuhvpdxt36uirsoh42znuydcyxiybtcnfqxs2eiwkwr4y",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[4] = SONG_PARAMS(
            "MI AMOR",
            "MA",
            "ipfs://bafkreifafpvrok2ztldajsuvwhdpvyivn3f3pck2fnkiwjwvfbh3nclmou",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[5] = SONG_PARAMS(
            "SAY SOMETHING",
            "SS",
            "ipfs://bafkreifujkxmbk5v5lndjz3zsogx3k7kpstk6oogkw6lm42bqffjqxs5r4",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[6] = SONG_PARAMS(
            "CLASSY ICY JUNGLE",
            "CIJ",
            "ipfs://bafkreidtt4okddciprjcs3r722ugl22knkj235z4u7lrwtbnr76gpcpjta",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[7] = SONG_PARAMS(
            "SPACESHIP SWEETIE",
            "SS",
            "ipfs://bafkreic7qea35u5kgk7basi6sabfyo5anmnoo5opi7juhwxltzpe7abcnm",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[8] = SONG_PARAMS(
            "ALL THE THINGS I NEVER GOT TO BE",
            "ATTINGTB",
            "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[9] = SONG_PARAMS(
            "MAYBE WE CAN",
            "MWC",
            "ipfs://bafkreid7rji3uwxcgrjpna2jvhk4ybxv72nlih4i3wt3k7555fejhrzzje",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[10] = SONG_PARAMS(
            "ARMS",
            "ARMS",
            "ipfs://bafkreiffwdkyldiymkio2r72y6orn5fabkxcrsvhrzf7d4yxfvx3qthcfq",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[11] = SONG_PARAMS(
            "I DID",
            "IDID",
            "ipfs://bafkreidpbay2q3fo6qbmqhfx7ql6vxk5jauji7boziw6bxfp4utgy4ymdi",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[12] = SONG_PARAMS(
            "NEON PURPLE BLACK & GREEN",
            "NPB&G",
            "ipfs://bafkreieza2q4fyexvkug3anxgyt75ygevbnsdrr7pryr665mlb6la2mrem",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[13] = SONG_PARAMS(
            "BEING WITH SOMEONE THAT DOESN'T LOVE YOU",
            "BWSTDLY",
            "ipfs://bafkreietfsujias47oenrz7ynpiia2uzs6fuk7fgryuvhmzhej4xfhahpe",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[14] = SONG_PARAMS(
            "MILLENNIAL HONEYMOON-QUIET AS THEY WATCH ME",
            "MHQATWM",
            "ipfs://bafkreih5dguju4nvgcpkpyhirq3vvb6kereupqf5hqlfyniwa4xcztz56m",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[15] = SONG_PARAMS(
            "I HOPE YOU SEE THROUGH IT ALL",
            "IHYSTIA",
            "ipfs://bafkreif6kbxy5snlxn4anenlmh73wwr6zgzwfdiyuuyxwhodc35bddq2tm",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[16] = SONG_PARAMS(
            "HOW YOU ACT TOWARDS ME",
            "HYATM",
            "ipfs://bafkreibvoldeqe2zylojipztwctmo5zedgyftlcdhkdotbsx5wvru7owq4",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[17] = SONG_PARAMS(
            "WHATEVER",
            "W/E",
            "ipfs://bafkreiazgoo62cakpwgfeg2hvjheosorzcpobkzi2zhobiodvdedpo6o3i",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[18] = SONG_PARAMS(
            "OH, UP HERE",
            "O,UH",
            "ipfs://bafkreidav3alb53fw4cxmfy6zyms7nyzjooszxve6zbiydxa2if2h4mrke",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[19] = SONG_PARAMS(
            "ME & YOU!",
            "M&Y!",
            "ipfs://bafkreidcfsjkqrgmagffir5ubfvtecixmgstzlb5l5ei7szs4wqppqbpuy",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[20] = SONG_PARAMS(
            "THERE'S A LEAK IN MY HEAD",
            "TALIMH",
            "ipfs://bafkreiby27v5gnb5is2iyd6pvut25lmvot4biwajs5qxix5tdi27snyv5e",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[21] = SONG_PARAMS(
            "OOPS WE'RE DROWNING LOL",
            "OWDL",
            "ipfs://bafkreih77kvsjqrdsf2733w3jqykkxi2fjq5bgtbcbicvwrmfilrepx55a",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[22] = SONG_PARAMS(
            "RUNAWAY SWIM (WITH ME)",
            "RW(WM)",
            "ipfs://bafkreiaetzcdzmlpgxbbzwwu2ilxgcbirwzp5mcop5n2d3meomkb2da4oe",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[23] = SONG_PARAMS(
            "INSPIRATION ODYSSEY",
            "IO",
            "ipfs://bafkreicdwgrl2igi4e7tnentl6o5sn23f5p7jszfz2slph4kqvt73w2vlu",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[24] = SONG_PARAMS(
            "I MESS EVERYTHING UP",
            "IMEU",
            "ipfs://bafkreifuy64hjmrw4wcdf6mzuwraqhfme4np52heq4zikigfubhf5e6lqa",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[25] = SONG_PARAMS(
            "FOREVER",
            "F",
            "ipfs://bafkreig3nwkvpopgmpgab2ryzk43etdya4vnd4utmrcwsiz2wr2pibc7fy",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[26] = SONG_PARAMS(
            "ARC",
            "A",
            "ipfs://bafkreib2hjghn766wqdfrji3j2kuzff4nb237yppt7tirqfw6ag5ebjs2m",
            CENTS,
            GRACE_PERIOD
        );

        PARAMS[27] = SONG_PARAMS(
            "UNTIL NEXT TIME",
            "UNT",
            "ipfs://bafkreihasccyhx34e2id3boulzencqi2u2x3lmik6dn2wkcfuuk2zcfbsy",
            CENTS,
            GRACE_PERIOD
        );

        // SONG song1 = new SONG(
        //     s_artist,
        //     "NO",
        //     "NO",
        //     // 0.001 ether,
        //     "ipfs://bafkreiefug6orin7nzf2s26gnzn63ji4jd6r5ljoklovjd4ahlshzld63q",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // console.log("Song1:", address(song1));
        // SONG song2 = new SONG(
        //     s_artist,
        //     "BAABY",
        //     "BAABY",
        //     "ipfs://bafkreiglcjqxy2rhgvn6wppbqmq4kjkazwluz3duqpf2tapdfejjm5nm4i",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // // console.log("Song2:", address(song2));
        // SONG song3 = new SONG(
        //     s_artist,
        //     "TREES",
        //     "TREES",
        //     // 0.003 ether,
        //     "ipfs://bafkreidmqjaxso62i6fkmrrldp7mksjfmzugrvsmmktaokbr5t4gahw6pe",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // console.log("Song3:", address(song3));
        // vm.roll(block.number + 1);

        // SONG song4 = new SONG(
        //     s_artist,
        //     "ONCE YOU FIND OUT",
        //     "OYFO",
        //     // 0.004 ether,
        //     "ipfs://bafkreiefhkpgtfuhvpdxt36uirsoh42znuydcyxiybtcnfqxs2eiwkwr4y",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song5 = new SONG(
        //     s_artist,
        //     "MI AMOR",
        //     "MA",
        //     // 0.005 ether,
        //     "ipfs://bafkreifafpvrok2ztldajsuvwhdpvyivn3f3pck2fnkiwjwvfbh3nclmou",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song6 = new SONG(
        //     s_artist,
        //     "SAY SOMETHING",
        //     "SS",
        //     // 0.006 ether,
        //     "ipfs://bafkreifujkxmbk5v5lndjz3zsogx3k7kpstk6oogkw6lm42bqffjqxs5r4",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song7 = new SONG(
        //     s_artist,
        //     "CLASSY ICY JUNGLE",
        //     "CIJ",
        //     // 0.007 ether,
        //     "ipfs://bafkreidtt4okddciprjcs3r722ugl22knkj235z4u7lrwtbnr76gpcpjta",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song8 = new SONG(
        //     s_artist,
        //     "SPACESHIP SWEETIE",
        //     "SS",
        //     // 0.008 ether,
        //     "ipfs://bafkreic7qea35u5kgk7basi6sabfyo5anmnoo5opi7juhwxltzpe7abcnm",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song9 = new SONG(
        //     s_artist,
        //     "ALL THE THINGS I NEVER GOT TO BE",
        //     "ATTINGTB",
        //     // 0.009 ether,
        //     "ipfs://bafkreibo5mesrzekccvw6chflv4a5oqxnro7uinappv7pijz4y6epq5sa4",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song10 = new SONG(
        //     s_artist,
        //     "MAYBE WE CAN",
        //     "MWC",
        //     // 0.0010 ether,
        //     "ipfs://bafkreid7rji3uwxcgrjpna2jvhk4ybxv72nlih4i3wt3k7555fejhrzzje",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song11 = new SONG(
        //     s_artist,
        //     "ARMS",
        //     "ARMS",
        //     // 0.0011 ether,
        //     "ipfs://bafkreiffwdkyldiymkio2r72y6orn5fabkxcrsvhrzf7d4yxfvx3qthcfq",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song12 = new SONG(
        //     s_artist,
        //     "I DID",
        //     "IDID",
        //     // 0.0012 ether,
        //     "ipfs://bafkreidpbay2q3fo6qbmqhfx7ql6vxk5jauji7boziw6bxfp4utgy4ymdi",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song13 = new SONG(
        //     s_artist,
        //     "NEON PURPLE BLACK & GREEN",
        //     "NPB&G",
        //     // 0.0013 ether,
        //     "ipfs://bafkreieza2q4fyexvkug3anxgyt75ygevbnsdrr7pryr665mlb6la2mrem",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song14 = new SONG(
        //     s_artist,
        //     "BEING WITH SOMEONE THAT DOESN'T LOVE YOU",
        //     "BWSTDLY",
        //     // 0.0014 ether,
        //     "ipfs://bafkreietfsujias47oenrz7ynpiia2uzs6fuk7fgryuvhmzhej4xfhahpe",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song15 = new SONG(
        //     s_artist,
        //     "MILLENNIAL HONEYMOON-QUIET AS THEY WATCH ME",
        //     "MHQATWM",
        //     // 0.0015 ether,
        //     "ipfs://bafkreih5dguju4nvgcpkpyhirq3vvb6kereupqf5hqlfyniwa4xcztz56m",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song16 = new SONG(
        //     s_artist,
        //     "I HOPE YOU SEE THROUGH IT ALL",
        //     "IHYSTIA",
        //     // 0.0016 ether,
        //     "ipfs://bafkreif6kbxy5snlxn4anenlmh73wwr6zgzwfdiyuuyxwhodc35bddq2tm",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song17 = new SONG(
        //     s_artist,
        //     "HOW YOU ACT TOWARDS ME",
        //     "HYATM",
        //     // 0.0017 ether,
        //     "ipfs://bafkreibvoldeqe2zylojipztwctmo5zedgyftlcdhkdotbsx5wvru7owq4",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song18 = new SONG(
        //     s_artist,
        //     "WHATEVER",
        //     "W",
        //     // 0.0018 ether,
        //     "ipfs://bafkreiazgoo62cakpwgfeg2hvjheosorzcpobkzi2zhobiodvdedpo6o3i",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song19 = new SONG(
        //     s_artist,
        //     "OH, UP HERE",
        //     "O,UH",
        //     // 0.0019 ether,
        //     "ipfs://bafkreidav3alb53fw4cxmfy6zyms7nyzjooszxve6zbiydxa2if2h4mrke",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song20 = new SONG(
        //     s_artist,
        //     "ME & YOU!",
        //     "M&Y!",
        //     // 0.0020 ether,
        //     "ipfs://bafkreidcfsjkqrgmagffir5ubfvtecixmgstzlb5l5ei7szs4wqppqbpuy",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song21 = new SONG(
        //     s_artist,
        //     "THERE'S A LEAK IN MY HEAD",
        //     "TALIMH",
        //     // 0.0021 ether,
        //     "ipfs://bafkreiby27v5gnb5is2iyd6pvut25lmvot4biwajs5qxix5tdi27snyv5e",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song22 = new SONG(
        //     s_artist,
        //     "OOPS WE'RE DROWNING LOL",
        //     "OWDL",
        //     // 0.0022 ether,
        //     "ipfs://bafkreih77kvsjqrdsf2733w3jqykkxi2fjq5bgtbcbicvwrmfilrepx55a",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song23 = new SONG(
        //     s_artist,
        //     "RUNAWAY SWIM (WITH ME)",
        //     "RW(WM)",
        //     // 0.0023 ether,
        //     "ipfs://bafkreiaetzcdzmlpgxbbzwwu2ilxgcbirwzp5mcop5n2d3meomkb2da4oe",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song24 = new SONG(
        //     s_artist,
        //     "INSPIRATION ODYSSEY",
        //     "IO",
        //     // 0.0024 ether,
        //     "ipfs://bafkreicdwgrl2igi4e7tnentl6o5sn23f5p7jszfz2slph4kqvt73w2vlu",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song25 = new SONG(
        //     s_artist,
        //     "I MESS EVERYTHING UP",
        //     "IMEU",
        //     // 0.0025 ether,
        //     "ipfs://bafkreifuy64hjmrw4wcdf6mzuwraqhfme4np52heq4zikigfubhf5e6lqa",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song26 = new SONG(
        //     s_artist,
        //     "FOREVER",
        //     "F",
        //     // 0.0026 ether,
        //     "ipfs://bafkreig3nwkvpopgmpgab2ryzk43etdya4vnd4utmrcwsiz2wr2pibc7fy",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song27 = new SONG(
        //     s_artist,
        //     "ARC",
        //     "A",
        //     // 0.0027 ether,
        //     "ipfs://bafkreib2hjghn766wqdfrji3j2kuzff4nb237yppt7tirqfw6ag5ebjs2m",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        // SONG song28 = new SONG(
        //     s_artist,
        //     "UNTIL NEXT TIME",
        //     "UNT",
        //     // 0.0028 ether,
        //     "ipfs://bafkreihasccyhx34e2id3boulzencqi2u2x3lmik6dn2wkcfuuk2zcfbsy",
        //     aggregator,
        //     sequencerUptimeFeed,
        //     25,
        //     songAdmins
        // );
        // vm.roll(block.number + 1);

        address[] memory songAdmins = new address[](1);
        songAdmins[0] = address(album);

        address[] memory SONGS = new address[](28);

        for (uint256 i = 0; i < PARAMS.length; i++) {
            SONGS[i] = address(
                new SONG(
                    songOwner,
                    PARAMS[i].NAME,
                    PARAMS[i].SYMBOL,
                    PARAMS[i].URI,
                    aggregator,
                    sequencerUptimeFeed,
                    PARAMS[i].CENTS,
                    songAdmins,
                    PARAMS[i].GRACE_PERIOD
                )
            );

            vm.roll(block.number + 1);
        }

        // address[] memory songs = new address[](28);
        // songs[0] = address(song1);
        // songs[1] = address(song2);
        // songs[2] = address(song3);
        // songs[3] = address(song4);
        // songs[4] = address(song5);
        // songs[5] = address(song6);
        // songs[6] = address(song7);
        // songs[7] = address(song8);
        // songs[8] = address(song9);
        // songs[9] = address(song10);
        // songs[10] = address(song11);
        // songs[11] = address(song12);
        // songs[12] = address(song13);
        // songs[13] = address(song14);
        // songs[14] = address(song15);
        // songs[15] = address(song16);
        // songs[16] = address(song17);
        // songs[17] = address(song18);
        // songs[18] = address(song19);
        // songs[19] = address(song20);
        // songs[20] = address(song21);
        // songs[21] = address(song22);
        // songs[22] = address(song23);
        // songs[23] = address(song24);
        // songs[24] = address(song25);
        // songs[25] = address(song26);
        // songs[26] = address(song27);
        // songs[27] = address(song28);

        playlist.ADD_SONGS_BATCH(SONGS);
        vm.roll(block.number + 1);

        playlist.transferOwnership(playlistOwner);

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
