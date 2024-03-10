import { PauseIcon, PlayIcon } from "@heroicons/react/24/outline";

interface NftCardProps {
  nft: any;

  name?: {
    value?: string;
    classes?: string;
  };

  cardClasses?: string;
  imgProps?: string;

  actionBtn?: {
    text: string;
    disabled?: boolean;
    onAction?: () => Promise<any>;
  };

  audioControls?: {
    isPlaying?: boolean;
    onToggle?: () => Promise<any>;
  };

  bottomMargin?: string;
}

export const NftCard = (props: NftCardProps) => {
  let buttonOutput;

  if (props.actionBtn) {
    buttonOutput = (
      <>
        <button
          disabled={props.actionBtn.disabled}
          className="m-1 btn btn-neutral btn-md shadow-md dropdown-toggle gap-0"
          type="button"
          onClick={async () => {
            if (props?.actionBtn?.onAction) await props.actionBtn.onAction();
          }}
        >
          {props.actionBtn.text}
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

  let audioControlsOutput;

  if (props.audioControls) {
    audioControlsOutput = (
      <div>
        <button
          type="button"
          onClick={async () => {
            if (props.audioControls?.onToggle) props.audioControls?.onToggle();
          }}
        >
          {props.audioControls?.isPlaying ? (
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
      <p className={props.name?.classes}>{props.name?.value}</p>
      <img className={props.imgProps} src={props.nft?.image} alt="NFT" />
      {audioControlsOutput}
      {priceOutput}
      {buttonOutput}
      <div className={props.bottomMargin}></div>
    </div>
  );
};
