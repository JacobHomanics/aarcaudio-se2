// import { useState } from "react";
import { PauseIcon, PlayIcon } from "@heroicons/react/24/outline";

interface NftCardProps {
  nft: any;
  buttonObj?: {
    text: string;
    disabled?: boolean;
    onClaimed?: () => Promise<any>;
  };

  onAudioToggle?: () => Promise<any>;

  // onAudioToggle?: () => Promise<any>;
  isPlaying?: boolean;

  // onAudioToggle?: () => Promise<any>;
  // onPlay?: () => Promise<any>;
  // onPause?: () => Promise<any>;
  // onActiveSongSet?: () => Promise<any>;
  // onSongState?: any;
}

export const NftCard = (props: NftCardProps) => {
  // const [play, setPlay] = useState(false);
  // const oceanRef = useRef<HTMLAudioElement>(null);

  // useEffect(() => {
  //   setPlay(props.onSongState);
  // }, [props.onSongState]);

  // function toggleAudio() {
  //   if (play) {
  //     if (props.onPause) props.onPause();
  //     // oceanRef.current?.pause();
  //     // setPlay(false);
  //   } else {
  //     if (props.onPlay) props.onPlay();

  //     // oceanRef.current?.play();
  //     // setPlay(true);
  //   }
  // }

  let buttonOutput;

  if (props.buttonObj) {
    buttonOutput = (
      <>
        <button
          disabled={props.buttonObj.disabled}
          className="m-1 btn btn-neutral btn-sm shadow-md dropdown-toggle gap-0 !h-auto"
          type="button"
          onClick={async () => {
            if (props?.buttonObj?.onClaimed) await props.buttonObj.onClaimed();
          }}
        >
          {props.buttonObj.text}
        </button>
      </>
    );
  }

  let priceOutput;
  if (props.nft?.price) {
    priceOutput = (
      <>
        <p className="text-black text-center text-xl text-primary-content">{props.nft.price} ether</p>
      </>
    );
  }

  let audioOutput;

  // function handleEnded() {
  //   setPlay(false);
  // }

  if (props.nft["audio_url"]) {
    // console.log(props.nft["audio_url"]);

    audioOutput = (
      <div>
        {/* <audio ref={oceanRef} src={props.nft["audio_url"]} onEnded={handleEnded} /> */}
        {/* <button type="button" onClick={toggleAudio}> */}
        <button
          type="button"
          onClick={async () => {
            if (props.onAudioToggle) props.onAudioToggle();

            // toggleAudio();
            // if (props.onAudioToggle) await props.onAudioToggle();
          }}
        >
          {props.isPlaying ? (
            <PauseIcon className="h-12 w-12" aria-hidden="true" />
          ) : (
            <PlayIcon className="h-12 w-12" aria-hidden="true" />
          )}
        </button>
      </div>
    );
  }

  return (
    <div className="flex flex-col items-center justify-center bg-primary m-1 p-4 border-[8px] sm:w-64 lg:w-64 border-accent border rounded-full">
      <p className="text-4xl text-center text-primary-content">{props.nft.name}</p>
      <img className="rounded-2xl" src={props?.nft?.image} width={256} height={256} alt="NFT" />

      {audioOutput}

      {priceOutput}
      {buttonOutput}
    </div>
  );
};
