import { PauseIcon, PlayIcon } from "@heroicons/react/24/outline";

interface NftCardProps {
  nft: any;
  buttonObj?: {
    text: string;
    disabled?: boolean;
    onClaimed?: () => Promise<any>;
  };

  audioObj?: {
    isPlaying?: boolean;
    onAudioToggle?: () => Promise<any>;
  };

  cardClasses?: string;

  nameClasses?: string;

  imgProps?: string;

  bottomMargin?: string;
}

export const NftCard = (props: NftCardProps) => {
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

  if (props.audioObj?.isPlaying !== undefined) {
    audioOutput = (
      <div>
        <button
          type="button"
          onClick={async () => {
            if (props.audioObj?.onAudioToggle) props.audioObj?.onAudioToggle();
          }}
        >
          {props.audioObj?.isPlaying ? (
            <PauseIcon className="h-8 w-8 lg:h-12 lg:w-12" aria-hidden="true" />
          ) : (
            <PlayIcon className="h-8 w-8 lg:h-12 lg:w-12" aria-hidden="true" />
          )}
        </button>
      </div>
    );
  }
  return (
    <div className={props.cardClasses}>
      <p className={props.nameClasses}>{props.nft?.name}</p>
      <img className={props.imgProps} src={props.nft?.image} alt="NFT" />
      {audioOutput}
      {priceOutput}
      {buttonOutput}
      <div className={props.bottomMargin}></div>
    </div>
  );
};
