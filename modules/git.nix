{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Juan Diaz";
        email = "juanignaciodiazpuig998@gmail.com";
      };
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };
}
