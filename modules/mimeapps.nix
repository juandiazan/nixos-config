{...}: let
  browser = "firefox.desktop";
  image = "org.gnome.Loupe.desktop";
  media = "vlc.desktop";
  editor = "org.gnome.TextEditor.desktop";
  files = "org.gnome.Nautilus.desktop";

  writer = "writer.desktop";
  calc = "calc.desktop";
  impress = "impress.desktop";

  browserTypes = [
    "text/html"
    "application/xhtml+xml"
    "application/pdf"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
    "x-scheme-handler/chrome"
    "x-scheme-handler/mailto"
  ];

  imageTypes = [
    "image/png"
    "image/jpeg"
    "image/gif"
    "image/webp"
    "image/bmp"
    "image/tiff"
    "image/svg+xml"
    "image/avif"
    "image/heic"
    "image/jxl"
    "image/apng"
    "image/qoi"
    "image/jp2"
    "image/vnd.microsoft.icon"
    "image/x-xpixmap"
  ];

  mediaTypes = [
    "video/mp4"
    "video/x-matroska"
    "video/webm"
    "video/quicktime"
    "video/x-msvideo"
    "video/mpeg"
    "video/x-flv"
    "video/3gpp"
    "video/ogg"
    "audio/mpeg"
    "audio/flac"
    "audio/ogg"
    "audio/x-vorbis+ogg"
    "audio/opus"
    "audio/x-wav"
    "audio/mp4"
    "audio/aac"
    "audio/x-m4a"
    "audio/midi"
  ];

  editorTypes = [
    "text/plain"
    "text/english"
    "text/markdown"
    "text/x-makefile"
    "text/x-c"
    "text/x-c++"
    "text/x-chdr"
    "text/x-csrc"
    "text/x-c++hdr"
    "text/x-c++src"
    "text/x-java"
    "text/x-python"
    "text/x-lua"
    "text/x-tex"
    "text/x-tcl"
    "text/x-pascal"
    "text/x-moc"
    "text/x-nix"
    "text/x-yaml"
    "text/x-shellscript"
    "application/x-shellscript"
    "application/json"
    "application/xml"
    "application/toml"
    "text/xml"
  ];

  assign = app: types: builtins.listToAttrs (map (type: {
    name = type;
    value = app;
  }) types);
in {
  xdg.mimeApps = {
    enable = true;

    defaultApplications =
      assign browser browserTypes
      // assign image imageTypes
      // assign media mediaTypes
      // assign editor editorTypes
      // assign files ["inode/directory"]
      // assign writer [
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/msword"
        "application/vnd.oasis.opendocument.text"
        "application/rtf"
      ]
      // assign calc [
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.ms-excel"
        "application/vnd.oasis.opendocument.spreadsheet"
        "text/csv"
      ]
      // assign impress [
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/vnd.ms-powerpoint"
        "application/vnd.oasis.opendocument.presentation"
      ]
      // assign "claude-code-url-handler.desktop" ["x-scheme-handler/claude-cli"];
  };
}
