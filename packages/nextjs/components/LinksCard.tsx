export const LinksCard = () => {
  return (
    <div className="w-full">
      <ul className="menu menu-horizontal w-full">
        <div className="flex justify-center items-center gap-2 text-sm w-full">
          <div className="text-center text-accent">
            <a href="https://linktr.ee/aarcaudio" target="_blank" rel="noreferrer" className="link">
              LINKTREE
            </a>
          </div>
          <span className="text-accent">·</span>
          <div className="text-center text-accent">
            <a href="https://warpcast.com/~/channel/messyart" target="_blank" rel="noreferrer" className="link">
              WARPCAST
            </a>
          </div>
          <span className="text-accent">·</span>
          <div className="text-center text-accent">
            <a href="https://t.me/digitalshirtlounge" target="_blank" rel="noreferrer" className="link">
              TELEGRAM
            </a>
          </div>
          <span className="text-accent">·</span>
          <div className="text-center text-accent">
            <a href="https://discord.gg/4pSGDFYS" target="_blank" rel="noreferrer" className="link">
              DISCORD
            </a>
          </div>
        </div>
        <div className="flex justify-center items-center gap-2 text-sm w-full">
          <div className="text-center text-accent">
            <a href="https://www.instagram.com/aarcaudio/" target="_blank" rel="noreferrer" className="link">
              INSTAGRAM
            </a>
          </div>

          <span className="text-accent">·</span>
          <div className="text-center text-accent">
            <a
              href="https://www.tiktok.com/@aarcaudio?_t=8kcyUyDbGsk&_r=1"
              target="_blank"
              rel="noreferrer"
              className="link"
            >
              TIKTOK
            </a>
          </div>
        </div>
      </ul>
    </div>
  );
};
