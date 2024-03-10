"use client";

import { useEffect, useRef, useState } from "react";
import "@madzadev/audio-player/dist/index.css";
import type { NextPage } from "next";
import { useFetch } from "usehooks-ts";
import { formatEther } from "viem";
// import { createPublicClient, http } from "viem";
// import { mainnet } from "viem/chains";
import { useAccount, usePublicClient, useWalletClient } from "wagmi";
// import { useNetwork } from "wagmi";
import { NftCard } from "~~/components/NftCard/NftCard";
// import { useMe } from "~~/components/hooks/hooks";
import { abi } from "~~/contracts/songAbi";
import { useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();

  const { data: album1GoodURI } = useScaffoldContractRead({ contractName: "ALBUM", functionName: "getGoodURI" });
  const { data: album1BadURI } = useScaffoldContractRead({ contractName: "ALBUM", functionName: "getBadURI" });
  const album1GoodURICorrected = album1GoodURI?.replace("ipfs://", "https://ipfs.io/ipfs/");
  const album1BadURICorrected = album1BadURI?.replace("ipfs://", "https://ipfs.io/ipfs/");

  const { data: album1GoodMetadata } = useFetch<any>(album1GoodURICorrected);
  const { data: album1BadMetadata } = useFetch<any>(album1BadURICorrected);

  const { data: ownsCollection, refetch: refetchCheckIfOwnsCollection } = useScaffoldContractRead({
    contractName: "ALBUM",
    functionName: "CHECK_IF_OWNS_COLLECTION",
    args: [connectedAddress],
  });

  const { data: hasRedeemed, refetch: refetchHasRedeemed } = useScaffoldContractRead({
    contractName: "ALBUM",
    functionName: "getHasRedeemed",
    args: [connectedAddress],
  });

  const { data: totalPrice } = useScaffoldContractRead({
    contractName: "ALBUM",
    functionName: "getTotalPrice",
  });

  const { data: totalPriceUnowned, refetch: getTotalPriceUnowned } = useScaffoldContractRead({
    contractName: "ALBUM",
    functionName: "getUnownedTotalPrice",
    args: [connectedAddress],
  });

  let albumNft;

  if (hasRedeemed) {
    if (ownsCollection) {
      albumNft = {
        name: album1GoodMetadata?.name,
        image: album1GoodMetadata?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
      };
    } else {
      albumNft = {
        name: album1BadMetadata?.name,
        image: album1BadMetadata?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
      };
    }
  } else {
    albumNft = {
      name: album1BadMetadata?.name,
      image: album1BadMetadata?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
    };
  }

  const { writeAsync: claimAlbum } = useScaffoldContractWrite({
    contractName: "ALBUM",
    functionName: "claim",
    args: [connectedAddress],
  });

  const { writeAsync: mintAll } = useScaffoldContractWrite({
    contractName: "ALBUM",
    functionName: "MINT_ALL",
    args: [connectedAddress],
    value: totalPrice,
  });

  const { writeAsync: mintAllUnowned } = useScaffoldContractWrite({
    contractName: "ALBUM",
    functionName: "MINT_ONLY_UNOWNED",
    args: [connectedAddress],
    value: totalPriceUnowned,
  });

  const publicClient = usePublicClient();
  const { data: walletClient } = useWalletClient();
  const { data: allSongs } = useScaffoldContractRead({ contractName: "PLAYLIST", functionName: "getAllSongs" });

  const [allSongDatas, setAllSongDatas] = useState<any[]>();

  const [isPlayings, setIsPlayings] = useState<{ id: number; value: boolean }[]>([]);

  useEffect(() => {
    async function yeah() {
      if (!allSongs) return;

      const songDatas = [];
      const audioComps = [];

      for (let i = 0; i < allSongs?.length; i++) {
        if (allSongs[i] === "0x0000000000000000000000000000000000000000") continue;

        const audioComp = { id: i, value: false };
        audioComps.push(audioComp);

        const price = await publicClient.readContract({
          address: allSongs[i],
          abi,
          functionName: "getPrice",
        });

        const uri = await publicClient.readContract({
          address: allSongs[i],
          abi,
          functionName: "getURI",
        });

        let theMint;

        if (connectedAddress) {
          const { request } = await publicClient.simulateContract({
            account: connectedAddress,
            address: allSongs[i],
            abi,
            functionName: "MINT",
            args: [connectedAddress],
            value: price as bigint,
          });

          if (walletClient) {
            theMint = () => {
              walletClient.writeContract(request);
            };
          }
        }

        const uriCorrected = (uri as string).replace("ipfs://", "https://ipfs.io/ipfs/");

        const response = await fetch(uriCorrected);

        const tokenData = await response.json();

        tokenData["audio_url_corrected"] = tokenData["audio_url"]?.replace("ipfs://", "https://ipfs.io/ipfs/");

        const songData = { price, uri, uriCorrected, tokenData, theMint /*mint*/ };

        songDatas.push(songData);
      }

      setAllSongDatas([...songDatas]);
      setIsPlayings([...audioComps]);
    }

    yeah();
  }, [allSongs, publicClient.account, walletClient?.account]);

  const builtNfts: any[] = [];

  if (allSongDatas) {
    for (let i = 0; i < allSongDatas.length; i++) {
      const nft = {
        name: allSongDatas[i].tokenData?.name,
        image: allSongDatas[i].tokenData?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
        price: formatEther(allSongDatas[i].price || BigInt(0)),
        actionBtn: allSongDatas[i].theMint
          ? {
              text: "Buy",
              onAction: async () => {
                await allSongDatas[i].theMint();
                await refreshData();
              },
            }
          : undefined,

        audioControls: {
          isPlaying: isPlayings[i].value,
          onToggle: () => {
            handleMe(
              isPlayings[i].id,
              isPlayings,
              allSongDatas[i].tokenData["audio_url"].replace("ipfs://", "https://ipfs.io/ipfs/"),
            );
          },
        },
      };

      builtNfts.push(nft);
    }
  }

  const [play, setPlay] = useState(false);
  const [selectedSong, setSelectedSong] = useState<string>();
  const oceanRef = useRef<HTMLAudioElement>(null);

  useEffect(() => {
    if (play) {
      oceanRef.current?.play();
    }
  }, [selectedSong, play, oceanRef]);

  function handleMe(idToSetTrue: number, allSets: { id: number; value: boolean }[], url: string) {
    for (let i = 0; i < allSets.length; i++) {
      if (idToSetTrue === allSets[i].id) {
        if (!allSets[i].value) {
          allSets[i].value = true;
          setSelectedSong(url);
          setPlay(true);
        } else {
          allSets[i].value = false;
          setPlay(false);
          oceanRef.current?.pause();
        }
      } else {
        allSets[i].value = false;
      }
    }

    setIsPlayings([...allSets]);
  }

  function handleEnded(allSets: { id: number; value: boolean }[]) {
    setPlay(false);

    for (let i = 0; i < allSets.length; i++) {
      allSets[i].value = false;
    }

    setIsPlayings([...allSets]);
  }

  const allNftsCards = builtNfts.map((anNft, index) => (
    <NftCard
      key={index}
      name={{
        value: anNft.name,
        classes: "m-1 mt-[60px] lg:mt-[120px] text-xl lg:text-4xl line-clamp-1  text-center text-primary-content",
      }}
      image={{
        value: anNft.image,
        alt: "NFT 1",
        classes: "p-1 lg:p-8 w-24 h-24 lg:w-64 lg:h-64 rounded-2xl lg:rounded-[56px]",
      }}
      price={{
        value: anNft.price,
        classes: "text-black p-1 m-1 text-center text-lg lg:text-xl text-primary-content",
      }}
      actionBtn={anNft.actionBtn}
      audioControls={anNft.audioControls}
      bottomMargin="mt-[60px] lg:mt-[120px]"
      cardClasses="flex flex-col items-center justify-center bg-primary m-1 border-[3px] lg:border-[8px] sm:w-50 lg:w-64 border-accent border rounded-full"
    />
  ));

  async function refreshData() {
    await refetchCheckIfOwnsCollection();
    await getTotalPriceUnowned();
    await refetchHasRedeemed();
  }

  return (
    <>
      <audio
        ref={oceanRef}
        src={selectedSong}
        onEnded={() => {
          handleEnded(isPlayings);
        }}
      />

      <div className="flex items-center flex-col flex-grow pt-10">
        <p className="text-primary-content text-2xl text-center">
          BUY ALL THE SONGS IN THE COLLECTION TO CLAIM THE ALBUM COVER.
        </p>

        <NftCard
          name={{
            value: albumNft.name,
            classes: "m-1 text-xl lg:text-4xl line-clamp-1  text-center text-primary-content",
          }}
          image={{
            value: albumNft.image,
            alt: "Album NFT",
            classes: "p-1 lg:p-8 w-36 h-36 lg:w-64 lg:h-64",
          }}
          actionBtn={{
            text: !hasRedeemed ? "Claim" : "Claimed!",
            onAction: async () => {
              await claimAlbum();
              await refreshData();
            },
            disabled: !hasRedeemed ? !ownsCollection : true,
          }}
          cardClasses="flex flex-col items-center justify-center bg-primary m-1 border-[3px] lg:border-[8px] sm:w-96 lg:w-96 border-accent border"
        />

        {connectedAddress ? (
          <button
            className="m-1 btn btn-neutral shadow-md dropdown-toggle gap-0"
            onClick={async () => {
              await mintAll();
              await refreshData();
            }}
          >
            {`Buy Album (${formatEther(totalPrice || BigInt(0))} ether)`}
          </button>
        ) : (
          <></>
        )}

        {connectedAddress ? (
          <button
            className="m-1 btn btn-neutral shadow-md dropdown-toggle gap-0"
            onClick={async () => {
              await mintAllUnowned();
              await refreshData();
            }}
          >
            {`Buy Album - Remaining (${formatEther(totalPriceUnowned || BigInt(0))} ether)`}
          </button>
        ) : (
          <></>
        )}

        {allNftsCards.length > 0 ? (
          <div className="grid grid-cols-3 items-center bg-slate m-1 p-1">{allNftsCards}</div>
        ) : (
          <p className="text-primary-content text-2xl text-center">Loading...</p>
        )}
      </div>
    </>
  );
};

export default Home;
