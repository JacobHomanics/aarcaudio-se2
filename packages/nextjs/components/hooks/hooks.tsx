// import { useState, useCallback, useEffect } from "react";
// export function useTokenURIs(nftContract: any | undefined, tokenIds: bigint[] | undefined) {
//     const [data, setData] = useState<any[]>([]);
// }
// export function useReadTokenURIs(nftContract: any | undefined, tokenIds: bigint[] | undefined) {
//     const [data, setData] = useState<any[]>([]);
//     const refetch = useCallback(async () => {
//       if (!tokenIds) return;
//       const arr: any[] = [];
//       for (let i = 0; i < tokenIds.length; i++) {
//         let dataURI = await nftContract?.read.tokenURI([tokenIds[i]]);
//         dataURI = dataURI.replace("ipfs://", "https://nftstorage.link/ipfs/");
//         const q = await fetch(dataURI);
//         const json = await q.json();
//         json["id"] = tokenIds[i];
//         arr.push(json);
//       }
//       setData([...arr]);
//       // eslint-disable-next-line react-hooks/exhaustive-deps
//     }, [nftContract?.address, tokenIds]);
//     useEffect(() => {
//       refetch();
//     }, [refetch]);
//     return { data, refetch };
//   }
// import { useEffect, useMemo, useState } from "react";
// export const useAudio = (url: any) => {
//   const audio = useMemo(() => new Audio(url), []);
//   const [playing, setPlaying] = useState(false);
//   const toggle = () => setPlaying(!playing);
//   useEffect(() => {
//     playing ? audio.play() : audio.pause();
//   }, [playing]);
//   useEffect(() => {
//     audio.addEventListener("ended", () => setPlaying(false));
//     return () => {
//       audio.removeEventListener("ended", () => setPlaying(false));
//     };
//   }, []);
//   return [playing, toggle];
// };
// export default useAudio;
import { useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export const useSongData = (contractName: "SONG1" | "SONG2" | "SONG3" | "SONG4", mintAddress: string | undefined) => {
  const { data: price } = useScaffoldContractRead({ contractName, functionName: "getPrice" });

  const { data: uri } = useScaffoldContractRead({ contractName, functionName: "getURI" });

  const { writeAsync: mint } = useScaffoldContractWrite({
    contractName,
    functionName: "MINT",
    args: [mintAddress],
    value: price,
  });

  const songData = { price, uri, mint };

  return { songData };
};
