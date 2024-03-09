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

  imgProps?: string;

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
          className="m-1 btn btn-neutral btn-md shadow-md dropdown-toggle gap-0"
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
        <p className="text-black p-1 m-1 text-center text-lg lg:text-xl text-primary-content">
          {props.nft.price} ether
        </p>
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
            <PauseIcon className="h-8 w-8 lg:h-12 lg:w-12" aria-hidden="true" />
          ) : (
            <PlayIcon className="h-8 w-8 lg:h-12 lg:w-12" aria-hidden="true" />
          )}
        </button>
      </div>
    );
  }

  //small 50
  //large 64
  return (
    <div
      className={`flex flex-col items-center justify-center bg-primary m-1 border-[3px] lg:border-[8px] sm:w-${
        props.smallSize
      } lg:w-${props.largeSize} border-accent border ${props.isRounded ? "rounded-full" : ""}`}
    >
      <p className="text-xl m-1 mt-[60px] lg:mt-[120px] lg:text-4xl line-clamp-1  text-center text-primary-content">
        {props.nft.name}
      </p>

      <img className={`w-24 h-24 lg:w-64 lg:h-64 p-1 lg:p-8 ${props.imgProps}`} src={props?.nft?.image} alt="NFT" />

      {audioOutput}

      {priceOutput}
      {buttonOutput}
      <div className="mt-[60px] lg:mt-[120px]"></div>
    </div>
  );
};
