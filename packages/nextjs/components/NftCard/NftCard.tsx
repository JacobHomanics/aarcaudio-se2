interface NftCardProps {
  nft: any;
  buttonObj?: {
    text: string;
    disabled?: boolean;
    onClaimed?: () => Promise<any>;
  };
}

export const NftCard = (props: NftCardProps) => {
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
        <p className="text-black text-xl text-primary-content">{props.nft.price} ether</p>
      </>
    );
  }

  return (
    <div className="flex flex-col items-center bg-primary m-1 p-4 border-[8px] w-64 border-accent border rounded-full">
      <p className="text-4xl text-center text-primary-content">{props.nft.name}</p>
      <img className="rounded-2xl" src={props?.nft?.image} width={256} height={256} />
      {priceOutput}
      {buttonOutput}
    </div>
  );
};
