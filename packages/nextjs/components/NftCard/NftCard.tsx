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

  smallSize: string;
  largeSize: string;
  isRounded: boolean;

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
          className="m-1 btn btn-neutral btn-md shadow-md dropdown-toggle gap-0 "
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
        <p className="text-black text-center sm:text-lg lg:text-xl text-primary-content">{props.nft.price} ether</p>
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
            <PauseIcon className="sm:h-8 sm:w-8 md:h-8 md:w-8 lg:h-12 lg:w-12" aria-hidden="true" />
          ) : (
            <PlayIcon className="sm:h-8 sm:w-8 md:h-8 md:w-8 lg:h-12 lg:w-12" aria-hidden="true" />
          )}
        </button>
      </div>
    );
  }

  //small 50
  //large 64
  return (
    <div
      className={`flex flex-col items-center justify-center bg-primary m-1 p-4 border-[8px] sm:w-${
        props.smallSize
      } lg:w-${props.largeSize} border-accent border ${props.isRounded ? "rounded-full" : ""}`}
    >
      <p className="sm:text-xl lg:text-4xl text-center p-3 text-center text-primary-content">{props.nft.name}</p>
      <img className="rounded-2xl" src={props?.nft?.image} width={256} height={256} alt="NFT" />

      {audioOutput}

      {priceOutput}
      {buttonOutput}
    </div>
  );
};
