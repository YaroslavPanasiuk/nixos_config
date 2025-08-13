{ inputs, config, ... }:
{  
  home.file.".config/anyrun/config.ron".text = ''
    Config(
      x: Fraction(0.5),
      y: Fraction(0.2),
      width: Fraction(0.4),
      height: Absolute(0),
      hide_icons: true,
      ignore_exclusive_zones: false,
      layer: Overlay,
      hide_plugin_info: true,
      close_on_click: true,
      show_results_immediately: false,
      max_entries: Some(1),
      plugins: [ "${config.xdg.configHome}/anyrun/libtranslate_panas.so"],
    )
  '';
}