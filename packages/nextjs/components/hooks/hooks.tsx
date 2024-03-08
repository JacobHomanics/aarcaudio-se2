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
