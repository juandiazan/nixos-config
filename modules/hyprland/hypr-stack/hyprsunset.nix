{
  config,
  pkgs,
  ...
}: {
  services.hyprsunset = {
    enable = true;
    settings = {
      profile = [
        {
          time = "7:30";
          identity = true;
        }
        {
          time = "20:00";
          temperature = 4000;
          gamma = "0.8";
        }
      ];
    };
  };
}
