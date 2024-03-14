"use client";

import { useEffect, useRef, useState } from "react";
import "@madzadev/audio-player/dist/index.css";
import type { NextPage } from "next";
import { useFetch } from "usehooks-ts";
import { formatEther } from "viem";
// import { createPublicClient, http } from "viem";
// import { mainnet } from "viem/chains";
import { useAccount, usePublicClient, useWalletClient } from "wagmi";
import { generateAlbumNft } from "~~/components/Helper";
import { LinksCard } from "~~/components/LinksCard";
// import { useNetwork } from "wagmi";
import { NftCard } from "~~/components/NftCard/NftCard";
// import { useMe } from "~~/components/hooks/hooks";
import { abi } from "~~/contracts/songAbi";
import { useScaffoldContract, useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

const isCached = false;

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount({
    onConnect: () => {
      if (!connectedAddress) refreshData();
    },
  });

  const { data: album1GoodURI } = useScaffoldContractRead({ contractName: "ALBUM", functionName: "GET_GOOD_URI" });
  const { data: album1BadURI } = useScaffoldContractRead({ contractName: "ALBUM", functionName: "GET_BAD_URI" });
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
    functionName: "GET_HAS_REDEEMED",
    args: [connectedAddress],
  });

  const { data: album } = useScaffoldContract({
    contractName: "ALBUM",
  });

  const { data: totalPrice } = useScaffoldContractRead({
    contractName: "ALBUM",
    functionName: "GET_TOTAL_PRICE_OF_SONGS",
  });

  const { data: album_cents } = useScaffoldContractRead({
    contractName: "ALBUM",
    functionName: "GET_CENTS",
  });

  const { data: totalPriceUnowned, refetch: getTotalPriceUnowned } = useScaffoldContractRead({
    contractName: "ALBUM",
    functionName: "GET_UNOWNED_TOTAL_PRICE",
    args: [connectedAddress],
  });

  const albumNft = generateAlbumNft(
    isCached,
    hasRedeemed,
    ownsCollection,
    album,
    album1GoodMetadata,
    album1BadMetadata,
    album_cents,
  );

  const { writeAsync: claimAlbum } = useScaffoldContractWrite({
    contractName: "ALBUM",
    functionName: "CLAIM",
    args: [connectedAddress],
  });

  // const { writeAsync: withdrawFromAlbum } = useScaffoldContractWrite({
  //   contractName: "ALBUM",
  //   functionName: "WITHDRAW",
  //   args: [connectedAddress],
  // });

  const { data: mintPriceAllCents, refetch: refetchTotalMintPriceOnCents } = useScaffoldContractRead({
    contractName: "ALBUM",
    functionName: "GET_PRICE_BASED_ON_CENTS",
  });

  const { writeAsync: mintAll } = useScaffoldContractWrite({
    contractName: "ALBUM",
    functionName: "MINT_ALL",
    args: [connectedAddress],
    value: mintPriceAllCents,
  });

  const { writeAsync: mintAllUnowned } = useScaffoldContractWrite({
    contractName: "ALBUM",
    functionName: "MINT_ONLY_UNOWNED",
    args: [connectedAddress],
    value: totalPriceUnowned,
  });

  const publicClient = usePublicClient();
  const { data: walletClient } = useWalletClient();
  const { data: allSongs } = useScaffoldContractRead({ contractName: "PLAYLIST", functionName: "GET_ALL_SONGS" });

  const [allSongDatas, setAllSongDatas] = useState<any[]>();

  const [isPlayings, setIsPlayings] = useState<{ id: number; value: boolean }[]>([]);

  async function yeah() {
    console.log("heree1");

    if (!allSongs) return;

    console.log("heree2");

    const songDatas = [];
    const audioComps = [];

    for (let i = 0; i < allSongs?.length; i++) {
      const audioComp = { id: i, value: false };
      audioComps.push(audioComp);

      const price = await publicClient.readContract({
        address: allSongs[i],
        abi,
        functionName: "GET_PRICE",
      });

      const mintPriceBasedOnCents = await publicClient.readContract({
        address: allSongs[i],
        abi,
        functionName: "GET_PRICE_BASED_ON_CENTS",
      });

      console.log("heree3");
      let balanceOf;
      if (connectedAddress) {
        balanceOf = await publicClient.readContract({
          address: allSongs[i],
          abi,
          functionName: "balanceOf",
          args: [connectedAddress],
        });
      }

      const data: any = {};

      if (isCached) {
        const result = await fetch(`/AARCADE RUN/${i + 1}.json`, {
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
          },
        });

        const resultJson = await result.json();
        data.name = resultJson.name;
        data.image = `/aarcaudio/images/glitch-art-studio ${i + 1}.gif`;
        data.cents = 25;
        data.audio = `/aarcaudio/songs/${i + 1}.mp3`;
      } else {
        const cents = await publicClient.readContract({
          address: allSongs[i],
          abi,
          functionName: "GET_CENTS",
        });

        const uri = await publicClient.readContract({
          address: allSongs[i],
          abi,
          functionName: "GET_URI",
        });
        const uriCorrected = (uri as string).replace("ipfs://", "https://ipfs.io/ipfs/");
        const response = await fetch(uriCorrected);
        const tokenData = await response.json();
        tokenData["audio_url_corrected"] = tokenData["audio_url"]?.replace("ipfs://", "https://ipfs.io/ipfs/");

        data.name = tokenData.name;
        data.image = tokenData.image?.replace("ipfs://", "https://ipfs.io/ipfs/");
        data.cents = (cents as bigint).toString();
        data.audio = tokenData["audio_url"].replace("ipfs://", "https://ipfs.io/ipfs/");
      }

      const songData = {
        address: allSongs[i],
        price,
        balanceOf,
        mintPriceBasedOnCents,
        name: data.name,
        image: data.image,
        cents: data.cents,
        audio: data.audio,
      };

      songDatas.push(songData);
    }

    setAllSongDatas([...songDatas]);
    setIsPlayings([...audioComps]);
  }

  useEffect(() => {
    yeah();
  }, [allSongs, publicClient.account, walletClient?.account.address, totalPriceUnowned]);

  const builtNfts: any[] = [];

  if (allSongDatas) {
    for (let i = 0; i < allSongDatas.length; i++) {
      let theMint: any;

      if (connectedAddress && walletClient?.account.address) {
        theMint = async () => {
          const { request } = await publicClient.simulateContract({
            account: connectedAddress,
            address: allSongDatas[i].address,
            abi,
            functionName: "MINT",
            args: [connectedAddress],
            value: allSongDatas[i].mintPriceBasedOnCents as bigint,
          });

          await walletClient.writeContract(request);
        };
      }

      const nft = {
        address: allSongDatas[i].address,
        name: allSongDatas[i].name,
        image: allSongDatas[i].image,
        price: formatEther(allSongDatas[i].price || BigInt(0)),
        mintPriceBasedOnCents: allSongDatas[i].mintPriceBasedOnCents.toString(),
        cents: allSongDatas[i].cents.toString(),
        balanceOf: allSongDatas[i].balanceOf,

        actionBtn: theMint
          ? {
              text: "Buy",
              onAction: async () => {
                await theMint();
                await refreshData();
              },
            }
          : {
              text: "Buy",
              disabled: true,
            },

        audioControls: {
          isPlaying: isPlayings[i].value,
          onToggle: () => {
            handleMe(isPlayings[i].id, isPlayings, allSongDatas[i].audio);
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

  function truncate(str: string, maxDecimalDigits: number) {
    if (str.includes(".")) {
      const parts = str.split(".");
      return parts[0] + "." + parts[1].slice(0, maxDecimalDigits);
    }
    return str;
  }

  const allNftsCards = builtNfts.map((anNft, index) => (
    <NftCard
      key={index}
      contractAddress={{
        value: anNft.address,
        classes: "text-blue-600 dark:text-blue-500 hover:underline text-xs m-1",
      }}
      name={{
        value: anNft.name,
        classes:
          "m-1 mt-[60px] lg:mt-[120px] text-[11px] lg:text-[18px] line-clamp-1  text-center text-primary-content",
      }}
      image={{
        value: anNft.image,
        alt: "NFT 1",
        classes: "p-1 lg:p-1 w-24 h-24 lg:w-52 lg:h-52 rounded-2xl lg:rounded-[56px]",
      }}
      price={{
        value: truncate(anNft.price, 7),
        classes: "text-black p-1 m-1 text-center text-xs lg:text-xs  text-primary-content mt-0 pt-0 mb-4",
      }}
      // priceUsd={{
      //   value: anNft.mintPriceBasedOnCents,
      //   classes: "text-black p-1 m-1 text-center text-sm lg:text-sm text-primary-content",
      // }}
      priceCents={{
        value:
          anNft.cents >= 100
            ? (anNft.cents / 100).toLocaleString("en-US", { style: "currency", currency: "USD" })
            : `${anNft.cents}¢`,
        classes: "text-black p-1 m-1 text-center text-lg lg:text-xl text-primary-content mb-0 pb-0",
      }}
      balanceOf={{
        value: anNft.balanceOf > 0 ? "OWNED" : undefined,
        classes: "text-black p-1 m-1 text-center text-lg lg:text-xl text-primary-content",
      }}
      actionBtn={anNft.actionBtn}
      audioControls={anNft.audioControls}
      bottomMargin="mt-[60px] lg:mt-[120px]"
      cardClasses="flex flex-col items-center justify-center bg-primary m-1 border-[3px] lg:border-[8px] sm:w-50 lg:w-64 border-accent border rounded-full"
    />
  ));

  const space = <div key={29}></div>;

  allNftsCards.splice(27, 0, space);

  async function refreshData() {
    await refetchCheckIfOwnsCollection();
    await getTotalPriceUnowned();
    await refetchHasRedeemed();
    await refetchTotalMintPriceOnCents();
  }

  // let totalPriceCents = 0;

  // for (let i = 0; i < builtNfts.length; i++) {
  //   totalPriceCents += Number(builtNfts[i].cents);
  // }

  // const dollars = (totalPriceCents / 100).toLocaleString("en-US", { style: "currency", currency: "USD" });
  const dollars = (Number(albumNft.albumCents) / 100).toLocaleString("en-US", { style: "currency", currency: "USD" });

  let totalPriceCents2 = 0;

  for (let i = 0; i < builtNfts.length; i++) {
    if (builtNfts[i].balanceOf <= 0) totalPriceCents2 += Number(builtNfts[i].cents);
  }

  const dollars2 = (totalPriceCents2 / 100).toLocaleString("en-US", { style: "currency", currency: "USD" });

  return (
    <>
      <LinksCard />
      <audio
        ref={oceanRef}
        src={selectedSong}
        onEnded={() => {
          handleEnded(isPlayings);
        }}
      />

      <div className="flex items-center flex-col flex-grow pt-2">
        {connectedAddress === undefined ? (
          <p className="text-primary-content text-sm text-center">PLEASE CONNECT A WEB3 WALLET TO BUY SONGS/ALBUM.</p>
        ) : (
          <></>
        )}

        <p className="text-primary-content text-2xl text-center">
          BUY ALL THE SONGS IN THE COLLECTION TO CLAIM THE ALBUM.
        </p>

        <NftCard
          contractAddress={{
            value: albumNft?.contractAddress,
            classes: "font-medium text-blue-600 dark:text-blue-500 hover:underline text-xs m-1",
          }}
          name={{
            value: albumNft.name,
            classes: "m-1 text-xl lg:text-4xl line-clamp-1  text-center text-primary-content",
          }}
          image={{
            value: albumNft.image,
            alt: "Album NFT",
            classes: "p-1 lg:p-1 w-36 h-36 lg:w-52 lg:h-52",
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

        {connectedAddress ? <></> : <></>}

        <button
          disabled={connectedAddress === undefined}
          className="m-1 btn btn-neutral shadow-md dropdown-toggle gap-0"
          onClick={async () => {
            await mintAll();
            await refreshData();
          }}
        >
          {`Buy Album \n (${dollars}) (${truncate(formatEther(totalPrice || BigInt(0)), 4)} ether) `}
        </button>

        {connectedAddress ? (
          <>
            <button
              disabled={connectedAddress === undefined}
              className="m-1 btn btn-neutral shadow-md dropdown-toggle gap-0"
              onClick={async () => {
                await mintAllUnowned();
                await refreshData();
              }}
            >
              {`Buy Remaining (${dollars2}) (${truncate(formatEther(totalPriceUnowned || BigInt(0)), 5)} ether)`}
            </button>
          </>
        ) : (
          <></>
        )}

        {allNftsCards.length > 1 ? (
          <div className="grid grid-cols-3 bg-slate m-1 p-1">{allNftsCards}</div>
        ) : (
          <p className="text-primary-content text-2xl text-center">Loading...</p>
        )}
      </div>
    </>
  );
};

export default Home;
