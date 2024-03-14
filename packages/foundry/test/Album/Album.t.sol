// contract AlbumTest {
//     function createSong() public returns (address song) {
//         song = address(
//             new SONG(
//                 s_songOwner,
//                 "Token",
//                 "T",
//                 "ipfs://Token",
//                 address(0),
//                 address(0),
//                 25,
//                 songAdmins,
//                 3600
//             )
//         );
//     }

//     function createSongs(
//         uint256 numToCreate
//     ) public returns (address[] memory) {
//         address[] memory songs = new address[](numToCreate);

//         for (uint256 i = 0; i < songs.length; i++) {
//             songs[i] = address(
//                 new SONG(
//                     s_songOwner,
//                     string.concat("Token-", i.toString()),
//                     string.concat("T-", i.toString()),
//                     string.concat("ipfs://", i.toString()),
//                     address(0),
//                     address(0),
//                     25,
//                     songAdmins,
//                     3600
//                 )
//             );
//         }

//         return songs;
//     }
// }