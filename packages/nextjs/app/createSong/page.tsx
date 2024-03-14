"use client";

import type { NextPage } from "next";
import { zeroAddress } from "viem";
import { useChainId } from "wagmi";
import deployedContracts from "~~/contracts/deployedContracts";
import { useScaffoldContract, useScaffoldContractWrite, useScaffoldEventSubscriber } from "~~/hooks/scaffold-eth";

const CreateSong: NextPage = () => {
  const chainId = useChainId();

  const predefined = useGetDeployments(chainId);

  console.log(predefined.sequencerUptimeFeed);

  const { writeAsync: addSong } = useScaffoldContractWrite({
    contractName: "PLAYLIST",
    functionName: "ADD_SONG",
    args: [zeroAddress],
  });
  const { data: album } = useScaffoldContract({ contractName: "ALBUM" });
  const { writeAsync: createNewInstance } = useScaffoldContractWrite({
    contractName: "SONG_FACTORY",
    functionName: "createNewInstance",
    args: [
      predefined.songOwner,
      "",
      "",
      "",
      predefined.aggregator,
      predefined.sequencerUptimeFeed,
      BigInt(25),
      [album ? album.address : ""],
      BigInt(3600),
    ],
  });

  useScaffoldEventSubscriber({
    contractName: "SONG_FACTORY",
    eventName: "CreatedNewInstance",
    listener: async logs => {
      console.log("ive been reached");
      console.log(logs);

      logs.map(async log => {
        const { newInstance } = log.args;
        console.log(newInstance);
        await addSong({ args: [newInstance] });
      });
    },
  });

  async function onSubmit(event: any) {
    event.preventDefault();
    const target = event.target;
    console.log(target.name.value);
    console.log(target.symbol.value);
    console.log(target.uri.value);

    await createNewInstance({
      args: [
        predefined.songOwner,
        target.name.value,
        target.symbol.value,
        target.uri.value,
        predefined.aggregator,
        predefined.sequencerUptimeFeed,
        BigInt(25),
        [album ? album.address : ""],
        BigInt(3600),
      ],
    });
  }

  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-2">
        <form className="flex flex-col" onSubmit={onSubmit}>
          <p>Name</p>
          <input type="text" name="name" />
          <p>Symbol</p>
          <input type="text" name="symbol" />
          <p>URI</p>
          <input type="text" name="uri" className="w-[600px]" />
          <button type="submit">Submit</button>
        </form>
      </div>
    </>
  );
};

export default CreateSong;

function useGetDeployments(chainId: number) {
  // let predefineParameters: {songOwner: string, albumOwner: string, playlistOwner: string, aggregator: string, sequencerUptimeFeed: string};

  //localhost
  if (chainId == 31337) {
    return {
      songOwner: "0x4161f8A8DfF60aEdB63baFb7d5843b0988393eC9",
      albumOwner: "0x4161f8A8DfF60aEdB63baFb7d5843b0988393eC9",
      playlistOwner: "0x4161f8A8DfF60aEdB63baFb7d5843b0988393eC9",
      aggregator: deployedContracts[31337].MockAggregatorV2V3Interface.address,
      sequencerUptimeFeed: zeroAddress,
    } as {
      songOwner: string | undefined;
      albumOwner: string | undefined;
      playlistOwner: string | undefined;
      aggregator: string | undefined;
      sequencerUptimeFeed: string | undefined;
    };
  }
  //sepolia
  else if (chainId == 11155111) {
    return {
      songOwner: "0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf",
      albumOwner: "0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf",
      playlistOwner: "0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf",
      aggregator: "0x694AA1769357215DE4FAC081bf1f309aDC325306",
      sequencerUptimeFeed: zeroAddress,
    } as {
      songOwner: string | undefined;
      albumOwner: string | undefined;
      playlistOwner: string | undefined;
      aggregator: string | undefined;
      sequencerUptimeFeed: string | undefined;
    };
  }
  //base sepolia
  else if (chainId == 84532) {
    return {
      songOwner: "0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf",
      albumOwner: "0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf",
      playlistOwner: "0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf",
      aggregator: "0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1",
      sequencerUptimeFeed: zeroAddress,
    } as {
      songOwner: string | undefined;
      albumOwner: string | undefined;
      playlistOwner: string | undefined;
      aggregator: string | undefined;
      sequencerUptimeFeed: string | undefined;
    };
  }
  // base mainnet
  else if (chainId == 8453) {
    return {
      songOwner: "0xc689c800a7121b186208ea3b182fAb2671B337E7",
      albumOwner: "0xc689c800a7121b186208ea3b182fAb2671B337E7",
      playlistOwner: "0xc689c800a7121b186208ea3b182fAb2671B337E7",
      aggregator: "0x71041dddad3595F9CEd3DcCFBe3D1F4b0a16Bb70",
      sequencerUptimeFeed: "0xBCF85224fc0756B9Fa45aA7892530B47e10b6433",
    } as {
      songOwner: string | undefined;
      albumOwner: string | undefined;
      playlistOwner: string | undefined;
      aggregator: string | undefined;
      sequencerUptimeFeed: string | undefined;
    };
  } else {
    return {
      songOwner: zeroAddress,
      albumOwner: zeroAddress,
      playlistOwner: zeroAddress,
      aggregator: zeroAddress,
      sequencerUptimeFeed: zeroAddress,
    } as {
      songOwner: string | undefined;
      albumOwner: string | undefined;
      playlistOwner: string | undefined;
      aggregator: string | undefined;
      sequencerUptimeFeed: string | undefined;
    };
  }
}
