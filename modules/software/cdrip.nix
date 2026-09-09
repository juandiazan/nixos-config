{
  config,
  pkgs,
  ...
}: {
  # Workflow:
  #   1. `abcde`            -> rips the CD to FLAC into ~/Music/import/...
  #   2. `beet import ~/Music/import` -> matches the release properly against
  #      MusicBrainz, fetches cover art + lyrics, writes clean tags, and
  #      moves the result into ~/Music/library/...
  home.packages = with pkgs; [
    abcde
    cdparanoia # audio extraction backend abcde rips with
    cddiscid # disc-id lookup abcde uses to identify the CD (provides cd-discid)
    flac
  ];

  # abcde just needs to do a fast, lossless rip + rough tag; beets redoes the
  # tagging/art/lyrics properly on import.
  home.file.".abcde.conf".text = ''
    CDDBMETHOD=musicbrainz

    OUTPUTDIR="$HOME/Music/import"
    OUTPUTTYPE=flac
    FLACOPTS='--best --verify'

    OUTPUTFORMAT='$ARTISTFILE/$ALBUMFILE/$TRACKNUM-$TRACKFILE'
    VAOUTPUTFORMAT='Various Artists/$ALBUMFILE/$TRACKNUM-$ARTISTFILE-$TRACKFILE'

    ACTIONS=cddb,read,encode,tag,move,clean
    PADTRACKS=y
    EJECTCD=y
    MAXPROCS=$(nproc)
  '';

  programs.beets = {
    enable = true;
    settings = {
      directory = "${config.home.homeDirectory}/Music/library";
      library = "${config.home.homeDirectory}/Music/library/musiclibrary.db";

      import = {
        move = true;
        write = true;
        resume = "ask";
      };

      paths = {
        default = "$albumartist/$album%aunique{}/$track $title";
        singleton = "Non-Album/$artist/$title";
        comp = "Compilations/$album%aunique{}/$track $title";
      };

      plugins = ["fetchart" "embedart" "lyrics" "mbsync" "scrub"];

      fetchart = {
        auto = true;
        minwidth = 500;
      };

      embedart = {
        auto = true;
        maxwidth = 1200;
      };

      lyrics.auto = true;
    };
  };
}
