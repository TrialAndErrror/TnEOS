{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Awesome WM configuration
  home.file.".config/awesome" = {
    source = ./config/awesome;
    recursive = true;
  };

  # Neovim configuration
  # CONDITIONAL_NVIM_START
  home.file.".config/nvim" = {
    source = ./config/nvim;
    recursive = true;
  };
  # CONDITIONAL_NVIM_END

  # Picom configuration
  home.file.".config/picom" = {
    source = ./config/picom;
    recursive = true;
  };

  # Rofi configuration
  home.file.".config/rofi" = {
    source = ./config/rofi;
    recursive = true;
  };

  # Alacritty configuration
  home.file.".config/alacritty" = {
    source = ./config/alacritty;
    recursive = true;
  };

  # Additional packages to install via Home Manager
  home.packages = with pkgs; [
    # Add any additional packages here
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}

