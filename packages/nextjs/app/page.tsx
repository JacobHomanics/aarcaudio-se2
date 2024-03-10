"use client";

import { useEffect, useState } from "react";
import "@madzadev/audio-player/dist/index.css";
import type { NextPage } from "next";
import { useFetch } from "usehooks-ts";
import { formatEther } from "viem";
import { useAccount } from "wagmi";
import { NftCard } from "~~/components/NftCard/NftCard";
import { useMe, useSongData } from "~~/components/hooks/hooks";
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

  const { songData: song1Data } = useSongData("SONG1", connectedAddress);
  const { songData: song2Data } = useSongData("SONG2", connectedAddress);
  const { songData: song3Data } = useSongData("SONG3", connectedAddress);
  const { songData: song4Data } = useSongData("SONG4", connectedAddress);

  const [nft1isPlaying, setNft1IsPlaying] = useState(false);
  const [nft2isPlaying, setNft2IsPlaying] = useState(false);
  const [nft3isPlaying, setNft3IsPlaying] = useState(false);
  const [nft4isPlaying, setNft4IsPlaying] = useState(false);

  // async function handleAudio1Toggle1() {
  //   setNft1IsPlaying(!nft1isPlaying);

  //   if (!nft1isPlaying) {
  //     setSelectedSong(song1Data.tokenData["audio_url"].replace("ipfs://", "https://ipfs.io/ipfs/"));
  //     setPlay(true);
  //     setNft2IsPlaying(false);
  //     setNft3IsPlaying(false);
  //     setNft4IsPlaying(false);
  //   } else {
  //     oceanRef.current?.pause();
  //     setPlay(false);
  //   }
  // }

  // async function handleAudio1Toggle2() {
  //   setNft2IsPlaying(!nft2isPlaying);

  //   if (!nft2isPlaying) {
  //     setSelectedSong(song2Data.tokenData["audio_url"].replace("ipfs://", "https://ipfs.io/ipfs/"));
  //     setPlay(true);

  //     setNft1IsPlaying(false);
  //     setNft3IsPlaying(false);
  //     setNft4IsPlaying(false);
  //   } else {
  //     oceanRef.current?.pause();
  //     setPlay(false);
  //   }
  // }

  // async function handleAudio1Toggle3() {
  //   setNft3IsPlaying(!nft3isPlaying);

  //   if (!nft3isPlaying) {
  //     setSelectedSong(song3Data.tokenData["audio_url"].replace("ipfs://", "https://ipfs.io/ipfs/"));
  //     setPlay(true);

  //     setNft1IsPlaying(false);
  //     setNft2IsPlaying(false);
  //     setNft4IsPlaying(false);
  //   } else {
  //     oceanRef.current?.pause();
  //     setPlay(false);
  //   }
  // }

  // async function handleAudio1Toggle4() {
  //   setNft4IsPlaying(!nft4isPlaying);

  //   if (!nft4isPlaying) {
  //     setSelectedSong(song4Data.tokenData["audio_url"].replace("ipfs://", "https://ipfs.io/ipfs/"));
  //     setPlay(true);

  //     setNft1IsPlaying(false);
  //     setNft2IsPlaying(false);
  //     setNft3IsPlaying(false);
  //   } else {
  //     oceanRef.current?.pause();
  //     setPlay(false);
  //   }
  // }

  const { oceanRef, selectedSong, handleEnded, handleAudio } = useMe();

  // const [nft, setNft] = useState<any>(undefined);
  // const [nft2, setNft2] = useState<any>();
  // const [nft3, setNft3] = useState<any>();
  // const [nft4, setNft4] = useState<any>();

  useEffect(() => {
    if (!song1Data || !song2Data || !song3Data || !song4Data) return;

    if (!song1Data.tokenData || !song2Data.tokenData || !song3Data.tokenData || !song4Data.tokenData) return;

    console.log(nft1isPlaying);

    const nftUno = {
      name: song1Data.tokenData?.name,
      image: song1Data.tokenData?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
      price: formatEther(song1Data.price || BigInt(0)),
      onAction: async () => {
        await song1Data.mint();
        await refreshData();
      },
      audioControls: {
        isPlaying: nft1isPlaying,
        onToggle: () => {
          handleAudio(nft1isPlaying, setNft1IsPlaying, song1Data.tokenData["audio_url"], [
            setNft2IsPlaying,
            setNft3IsPlaying,
            setNft4IsPlaying,
          ]);
        },
      },
    };

    const nftDos = {
      name: song2Data.tokenData?.name,
      image: song2Data.tokenData?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
      price: formatEther(song2Data.price || BigInt(0)),
      onAction: async () => {
        await song2Data.mint();
        await refreshData();
      },
      audioControls: {
        isPlaying: nft2isPlaying,
        onToggle: () => {
          handleAudio(nft2isPlaying, setNft2IsPlaying, song2Data.tokenData["audio_url"], [
            setNft1IsPlaying,
            setNft3IsPlaying,
            setNft4IsPlaying,
          ]);
        },
      },
    };

    const nftTres = {
      name: song3Data.tokenData?.name,
      image: song3Data.tokenData?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
      price: formatEther(song3Data.price || BigInt(0)),
      onAction: async () => {
        await song3Data.mint();
        await refreshData();
      },
      audioControls: {
        isPlaying: nft3isPlaying,
        onToggle: () => {
          handleAudio(nft3isPlaying, setNft3IsPlaying, song3Data.tokenData["audio_url"], [
            setNft2IsPlaying,
            setNft1IsPlaying,
            setNft4IsPlaying,
          ]);
        },
      },
    };

    const nftQuatro = {
      name: song4Data.tokenData?.name,
      image: song4Data.tokenData?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
      price: formatEther(song4Data.price || BigInt(0)),
      onAction: async () => {
        await song4Data.mint();
        await refreshData();
      },
      audioControls: {
        isPlaying: nft4isPlaying,
        onToggle: () => {
          handleAudio(nft4isPlaying, setNft4IsPlaying, song4Data.tokenData["audio_url"], [
            setNft2IsPlaying,
            setNft3IsPlaying,
            setNft1IsPlaying,
          ]);
        },
      },
    };

    // setNft(nftUno);

    const theNfts: any[] = [];
    theNfts.push(nftUno);
    theNfts.push(nftDos);
    theNfts.push(nftTres);
    theNfts.push(nftQuatro);

    // allNfts.push(nft2);
    // allNfts.push(nft3);
    // allNfts.push(nft4);

    setAllNfts([...theNfts]);
  }, [
    song1Data.tokenData,
    song2Data.tokenData,
    song3Data.tokenData,
    song4Data.tokenData,
    nft1isPlaying,
    nft2isPlaying,
    nft3isPlaying,
    nft4isPlaying,
  ]);

  // useEffect(() => {
  //   // const theNfts: any[] = [];
  //   // theNfts.push(nft);
  //   // console.log(nft);
  //   // // allNfts.push(nft2);
  //   // // allNfts.push(nft3);
  //   // // allNfts.push(nft4);
  //   // setAllNfts([...theNfts]);
  // }, [nft]);

  // const nft = {
  //   name: song1Data.tokenData?.name,
  //   image: song1Data.tokenData?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
  //   price: formatEther(song1Data.price || BigInt(0)),
  //   onAction: async () => {
  //     await song1Data.mint();
  //     await refreshData();
  //   },
  //   audioControls: {
  //     isPlaying: nft1isPlaying,
  //     onToggle: handleAudio(nft1isPlaying, setNft1IsPlaying, song1Data.tokenData["audio_url"], [
  //       setNft2IsPlaying,
  //       setNft3IsPlaying,
  //       setNft4IsPlaying,
  //     ]),
  //   },
  // };

  // const nft2 = {
  //   name: song2Data.tokenData?.name,
  //   image: song2Data.tokenData?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
  //   price: formatEther(song2Data.price || BigInt(0)),
  //   onAction: async () => {
  //     await song2Data.mint();
  //     await refreshData();
  //   },
  //   audioControls: {
  //     isPlaying: nft2isPlaying,
  //     onToggle: handleAudio(nft2isPlaying, setNft2IsPlaying, song2Data.tokenData["audio_url"], [
  //       setNft1IsPlaying,
  //       setNft3IsPlaying,
  //       setNft4IsPlaying,
  //     ]),
  //   },
  // };

  // const nft3 = {
  //   name: song3Data.tokenData?.name,
  //   image: song3Data.tokenData?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
  //   price: formatEther(song3Data.price || BigInt(0)),
  //   onAction: async () => {
  //     await song3Data.mint();
  //     await refreshData();
  //   },
  //   audioControls: {
  //     isPlaying: nft3isPlaying,
  //     onToggle: handleAudio(nft3isPlaying, setNft3IsPlaying, song3Data.tokenData["audio_url"], [
  //       setNft2IsPlaying,
  //       setNft1IsPlaying,
  //       setNft4IsPlaying,
  //     ]),
  //   },
  // };

  // const nft4 = {
  //   name: song4Data.tokenData?.name,
  //   image: song4Data.tokenData?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
  //   price: formatEther(song4Data.price || BigInt(0)),
  //   onAction: async () => {
  //     await song4Data.mint();
  //     await refreshData();
  //   },
  //   audioControls: {
  //     isPlaying: nft4isPlaying,
  //     onToggle: handleAudio(nft4isPlaying, setNft4IsPlaying, song4Data.tokenData["audio_url"], [
  //       setNft2IsPlaying,
  //       setNft3IsPlaying,
  //       setNft1IsPlaying,
  //     ]),
  //   },
  // };

  const [allNfts, setAllNfts] = useState<any[]>([]);

  const allNftsCards = allNfts.map((anNft, index) => (
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
      actionBtn={{
        text: "Buy",
        onAction: anNft.onAction,
      }}
      audioControls={anNft.audioControls}
      bottomMargin="mt-[60px] lg:mt-[120px]"
      cardClasses="flex flex-col items-center justify-center bg-primary m-1 border-[3px] lg:border-[8px] sm:w-50 lg:w-64 border-accent border rounded-full"
    />
  ));

  // const [selectedSong, setSelectedSong] = useState<string>();

  // const [play, setPlay] = useState(false);
  // const oceanRef = useRef<HTMLAudioElement>(null);

  // function handleEnded() {
  //   setPlay(false);
  //   setNft1IsPlaying(false);
  //   setNft2IsPlaying(false);
  //   setNft3IsPlaying(false);
  //   setNft4IsPlaying(false);
  // }

  // useEffect(() => {
  //   if (play) {
  //     oceanRef.current?.play();
  //   }
  // }, [selectedSong, play]);

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
          handleEnded;
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
        <button
          className="m-1 btn btn-neutral shadow-md dropdown-toggle gap-0"
          onClick={async () => {
            await mintAll();
            await refreshData();
          }}
        >
          {`Buy Album (${formatEther(totalPrice || BigInt(0))} ether)`}
        </button>

        <button
          className="m-1 btn btn-neutral shadow-md dropdown-toggle gap-0"
          onClick={async () => {
            await mintAllUnowned();
            await refreshData();
          }}
        >
          {`Buy Album - Remaining (${formatEther(totalPriceUnowned || BigInt(0))} ether)`}
        </button>

        <div className="grid grid-cols-3 items-center bg-slate m-1 p-1">{allNftsCards}</div>
      </div>
    </>
  );
};

export default Home;
