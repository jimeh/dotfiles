module.exports = {
  config: {
    // default font size in pixels for all tabs
    fontSize: 12,

    // font family with optional fallbacks
    fontFamily:
      '"Menlo for Powerline", Menlo, "DejaVu Sans Mono", "Lucida Console", monospace',

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: "rgba(255,255,255,0.8)",

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: "BLOCK",

    // color of the text
    foregroundColor: "#fff",

    // terminal background color
    backgroundColor: "#000",

    // border color (window, tabs)
    borderColor: "#333",

    // custom css to embed in the main window
    css: "",

    // custom css to embed in the terminal window
    termCSS: "",

    // set to `true` if you're using a Linux set up
    // that doesn't shows native menus
    // default: `false` on Linux, `true` on Windows (ignored on macOS)
    showHamburgerMenu: "",

    // set to `false` if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` on windows and Linux (ignored on macOS)
    showWindowControls: "",

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: "5px 5px",

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: "#000000",
      red: "#e13e2f",
      green: "#74c246",
      yellow: "#c6a838",
      blue: "#2e64a2",
      magenta: "#a9479c",
      cyan: "#49bace",
      white: "#cccccc",
      lightblack: "#676a66",
      lightred: "#ff0000",
      lightgreen: "#7ad94b",
      lightyellow: "#fcf055",
      lightblue: "#4893d8",
      lightmagenta: "#a95ea5",
      lightcyan: "#52d0e7",
      lightwhite: "#f5f5f5"
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    shell: "",

    // for setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used
    shellArgs: ["--login"],

    // for environment variables
    env: {},

    // set to false for no bell
    bell: "SOUND",

    // if true, selected text will automatically be copied to the clipboard
    copyOnSelect: false,

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    modifierKeys: {
      altIsMeta: true
    },

    visor: {
      hotkey: "CommandOrControl+Shift+Z",
      position: "full"
    }
    // for advanced config flags please refer to https://hyper.is/#cfg
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: ["hyper-font-smoothing", "hyperterm-visor"],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: []
};
