export function generateAlbumNft(
  isCached: boolean,
  hasRedeemed: boolean | undefined,
  ownsCollection: boolean | undefined,
  album: any | undefined,
  goodMetadata: any | undefined,
  badMetadata: any | undefined,
  albumCents: any | undefined,
) {
  if (isCached) {
  }

  let albumNft;

  if (hasRedeemed) {
    if (ownsCollection) {
      albumNft = getAlbumGoodData(isCached, album, goodMetadata, albumCents);
    } else {
      albumNft = getAlbumBadData(isCached, album, badMetadata, albumCents);
    }
  } else {
    albumNft = getAlbumBadData(isCached, album, badMetadata, albumCents);
  }

  return albumNft;
}

function getAlbumGoodData(isCached: boolean, album: any, metadata: any, albumCents: any) {
  let albumNft;

  if (isCached) {
    albumNft = {
      name: "ARCADE RUN",
      image: "/aarcaudio/images/album.gif",
      contractAddress: album?.address,
      albumCents: 600,
    };
  } else {
    albumNft = {
      name: metadata?.name,
      image: metadata?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
      contractAddress: album?.address,
      albumCents,
    };
  }

  return albumNft;
}

function getAlbumBadData(isCached: boolean, album: any, metadata: any, albumCents: any) {
  let albumNft;

  if (isCached) {
    albumNft = {
      name: "ARCADE RUN",
      image: "/aarcaudio/images/album-bad.gif",
      contractAddress: album?.address,
      albumCents: 600,
    };
  } else {
    albumNft = {
      name: metadata?.name,
      image: metadata?.image?.replace("ipfs://", "https://ipfs.io/ipfs/"),
      contractAddress: album?.address,
      albumCents,
    };
  }

  return albumNft;
}
