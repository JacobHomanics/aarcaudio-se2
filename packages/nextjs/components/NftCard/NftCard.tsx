import { useChainId } from "wagmi";
import { PauseIcon, PlayIcon } from "@heroicons/react/24/outline";

interface NftCardProps {
  cardClasses?: string;

  name?: {
    value?: string;
    classes?: string;
  };

  image?: {
    value?: string;
    alt?: string;
    classes?: string;
  };

  contractAddress?: {
    value?: string;
    classes?: string;
  };

  price?: {
    value?: string;
    classes?: string;
  };

  priceUsd?: {
    value?: string;
    classes?: string;
  };

  priceCents?: {
    value?: string;
    classes?: string;
  };

  balanceOf?: {
    value?: string;
    classes?: string;
  };
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
  const chainId = useChainId();

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

  let contractAddressOutput;

  if (props.contractAddress) {
    let urlLink;
    if (chainId === 84532) {
      urlLink = "https://sepolia.basescan.org/address/" + props.contractAddress?.value;
    } else if (chainId === 8453) {
      urlLink = "https://basescan.org/address/" + props.contractAddress?.value;
    }

    const truncatedAddress = props.contractAddress.value?.slice(0, 6) + "..." + props.contractAddress?.value?.slice(-4);

    contractAddressOutput = (
      <a href={urlLink} target="_blank">
        <p className={props.contractAddress.classes}>{`${truncatedAddress}`} </p>
      </a>
    );
  }
  let priceOutput;
  if (props.price) {
    priceOutput = <p className={props.price.classes}>{`${props.price.value} ether`} </p>;
  }

  let priceUsdOutput;
  if (props.priceUsd) {
    priceUsdOutput = <p className={props.priceUsd.classes}>{props.priceUsd.value} wei</p>;
  }

  let priceCentsOutput;
  if (props.priceCents) {
    priceCentsOutput = <p className={props.priceCents.classes}>{props.priceCents.value}</p>;
  }

  let balanceOfOutput;

  if (props.balanceOf) {
    balanceOfOutput = <p className={props.balanceOf.classes}>{props.balanceOf.value}</p>;
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

  //mt-[60px] lg:mt-[120px]
  return (
    <div className={props.cardClasses}>
      <p className={props.name?.classes}>{props.name?.value}</p>

      {/* eslint-disable @next/next/no-img-element */}
      <img className={props.image?.classes} src={props.image?.value} alt={props.image?.alt} />
      {contractAddressOutput}
      {audioControlsOutput}
      {balanceOfOutput}
      {priceCentsOutput}
      {priceOutput}

      {priceUsdOutput}
      {buttonOutput}
      <div className={props.bottomMargin}></div>
    </div>
  );
};
