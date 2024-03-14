// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";

// import {SONG} from "../contracts/SONG.sol";
// import {PLAYLIST} from "../contracts/PLAYLIST.sol";
// import {ALBUM} from "../contracts/ALBUM.sol";
// import {MockAggregatorV2V3Interface} from "../contracts/chainlink/mocks/MockAggregatorV2V3Interface.sol";
// import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

// // import {ALBUM_REDEMPTION} from "../contracts/ALBUM_REDEMPTION.sol";

// contract YourContractTest is Test {
//     using Strings for uint256;

//     address s_artist;
//     address s_user;

//     PLAYLIST s_playlist;
//     ALBUM s_album;

//     MockAggregatorV2V3Interface s_dataAggregator;
//     MockAggregatorV2V3Interface s_uptimeSequencer;

//     address[] songAdmins;

//     function setUp() public {
//         s_artist = vm.addr(1);
//         s_user = vm.addr(2);

//         console.log("Artist: ", address(s_artist));
//         console.log("User: ", address(s_user));

//         s_dataAggregator = new MockAggregatorV2V3Interface(4000, 1);
//         console.log("Mock Data Aggregator", address(s_dataAggregator));

//         s_uptimeSequencer = new MockAggregatorV2V3Interface(4000, 1234);
//         console.log("Mock Uptime Feed Sequencer", address(s_uptimeSequencer));

//         s_playlist = new PLAYLIST(s_artist);
//         console.log("Playlist: ", address(s_playlist));

//         address[] memory albumAdmins = new address[](1);
//         albumAdmins[0] = s_artist;

//         s_album = new ALBUM(
//             address(s_playlist),
//             s_artist,
//             albumAdmins,
//             "Album 1",
//             "A1",
//             "a_goodUri",
//             "a_badUri",
//             address(s_dataAggregator),
//             address(s_uptimeSequencer),
//             6000
//         );

//         console.log("Album: ", address(s_album));

//         songAdmins.push(address(s_album));

//         // vm.startPrank(s_artist);
//         // s_playlist.ADD_SONG(address(song1));
//         // s_playlist.ADD_SONG(address(song2));
//         // s_playlist.ADD_SONG(address(song3));
//         // s_playlist.ADD_SONG(address(song4));
//         // vm.stopPrank();

//         // address[] memory songs = s_playlist.GET_ALL_SONGS();
//         // for (uint256 i = 0; i < songs.length; i++) {
//         //     console.log(songs[i]);
//         // }

//         // console.log(s_album.CHECK_IF_OWNS_COLLECTION(s_user));

//         // vm.deal(s_user, 0.4 ether);

//         // vm.startPrank(s_user);
//         // song1.MINT{value: 0.1 ether}(s_user);
//         // song2.MINT{value: 0.1 ether}(s_user);
//         // song3.MINT{value: 0.1 ether}(s_user);
//         // song4.MINT{value: 0.1 ether}(s_user);
//         // vm.stopPrank();

//         // console.log(s_album.CHECK_IF_OWNS_COLLECTION(s_user));

//         // s_album.CLAIM(s_user);
//         // console.log(s_album.balanceOf(s_user));

//         // console.log(s_album.ownerOf(0));

//         // vm.startPrank(s_user);
//         // song2.transferFrom(s_user, s_artist, 0);
//         // vm.stopPrank();

//         // console.log(s_album.balanceOf(s_user));

//         // console.log(s_album.ownerOf(0));

//         // console.log(s_playlist.GET_SONG_BY_INDEX(4));
//         // console.log(s_playlist.GET_SONG_BY_INDEX(1));
//         // console.log(s_playlist.GET_SONG_BY_INDEX(3));
//         // console.log(s_playlist.GET_SONG_BY_INDEX(2));
//     }

//     // function testAddSong() public {
//     //     // SONG song = testCreateSong(0);

//     //     // SONG[] memory songs = vm.startPrank(s_artist);
//     //     // s_playlist.ADD_SONG(address(song1));
//     //     // s_playlist.ADD_SONG(address(song2));
//     //     // s_playlist.ADD_SONG(address(song3));
//     //     // s_playlist.ADD_SONG(address(song4));
//     //     // vm.stopPrank();
//     // }

//     function testAddSong() public {
//         vm.startPrank(s_artist);
//         s_playlist.ADD_SONG(
//             address(
//                 new SONG(
//                     s_artist,
//                     "Token",
//                     "T",
//                     "ipfs://Token",
//                     address(s_dataAggregator),
//                     address(s_uptimeSequencer),
//                     25,
//                     songAdmins
//                 )
//             )
//         );

//         vm.stopPrank();
//     }

//     function testRevertAddSong(address badActor) public {
//         vm.assume(badActor != s_artist);

//         SONG song = new SONG(
//             s_artist,
//             "Token",
//             "T",
//             "ipfs://Token",
//             address(s_dataAggregator),
//             address(s_uptimeSequencer),
//             25,
//             songAdmins
//         );

//         vm.startPrank(badActor);
//         vm.expectRevert();
//         s_playlist.ADD_SONG(address(song));
//         vm.stopPrank();
//     }

//     function testAddSongsBatch(uint256 amount) public {
//         vm.assume(amount < 100);

//         address[] memory songs = createSongs(amount);

//         vm.startPrank(s_artist);
//         s_playlist.ADD_SONGS_BATCH(songs);
//         vm.stopPrank();
//     }

//     function testRevertAddSongsBatch(uint256 amount, address badActor) public {
//         vm.assume(amount < 100);
//         vm.assume(badActor != s_artist);
//         address[] memory songs = createSongs(amount);
//         vm.startPrank(badActor);
//         vm.expectRevert();
//         s_playlist.ADD_SONGS_BATCH(songs);
//         vm.stopPrank();
//     }

//     // function testCreateSongs() public {
//     // SONG[] memory songs = createSongs(4);
//     // for (uint256 i = 0; i < songs.length; i++) {
//     //     assertEq(songs[i].owner(), s_artist);
//     //     assertEq(songs[i].name(), string.concat("Token-", i.toString()));
//     //     assertEq(songs[i].symbol(), string.concat("T-", i.toString()));
//     //     assertEq(
//     //         songs[i].GET_URI(),
//     //         string.concat("ipfs://", i.toString())
//     //     );
//     //     assertEq(songs[i].GET_DATA_FEED(), address(s_dataAggregator));
//     //     assertEq(
//     //         songs[i].GET_SEQUENCER_UPTIME_FEED(),
//     //         address(s_uptimeSequencer)
//     //     );
//     //     assertEq(songs[i].GET_CENTS(), 25);
//     //     for (uint256 j = 0; j < songAdmins.length; j++) {
//     //         assertEq(
//     //             songs[i].hasRole(
//     //                 songs[i].DEFAULT_ADMIN_ROLE(),
//     //                 songAdmins[j]
//     //             ),
//     //             true
//     //         );
//     //     }
//     // }
//     // }

//     function createSongs(
//         uint256 numToCreate
//     ) public returns (address[] memory) {
//         address[] memory songs = new address[](numToCreate);

//         for (uint256 i = 0; i < songs.length; i++) {
//             songs[i] = address(
//                 new SONG(
//                     s_artist,
//                     string.concat("Token-", i.toString()),
//                     string.concat("T-", i.toString()),
//                     string.concat("ipfs://", i.toString()),
//                     address(s_dataAggregator),
//                     address(s_uptimeSequencer),
//                     25,
//                     songAdmins
//                 )
//             );
//         }

//         return songs;
//     }

//     function generateRandomNumber(uint256 seed) public view returns (uint256) {
//         uint256 blockNumber = block.number;
//         bytes32 blockHash = blockhash(blockNumber);
//         return (uint256(blockHash) % seed);
//     }

//     // function testPriceFeed() public {
//     //     int i = song1.GET_CHAINLINK_DATA_FEED_LATEST_ANSWER();

//     //     console.logInt(i);

//     //     uint cents = 25;
//     //     // uint currentFiatPrice = 77697017 * 1e10;
//     //     uint currentFiatPrice = 40000000 * 1e10;
//     //     // uint currentFiatPrice = uint256(i) * 1e10;
//     //     uint fiatPrice = cents * 1e16;

//     //     uint ethValue = (fiatPrice * 1e18) / currentFiatPrice;

//     //     console.log(ethValue);
//     // }
// }
