// ==UserScript==
// @name         Kagi Tweaks
// @description  Custom tweaks for kagi.com
// @version      0.0.1
// @namespace    jimeh.me
// @downloadURL  https://github.com/jimeh/dotfiles/raw/main/userscripts/kagi-tweaks.user.js
// @updateURL    https://github.com/jimeh/dotfiles/raw/main/userscripts/kagi-tweaks.user.js
// @inject-into  content
// @run-at       document-end
// @match        *://kagi.com/*
// @match        *://*.kagi.com/*
// ==/UserScript==
(function () {
  const css = `
@media (prefers-color-scheme: dark) {
  :root {
    --header-border: rgba(255, 255, 255, 0.2);
  }
}
  `;

  let styleElm = document.createElement('style');
  if (styleElm.styleSheet) {
    styleElm.styleSheet.cssText = css; // Support for IE
  } else {
    styleElm.appendChild(document.createTextNode(css));
  }
  document.getElementsByTagName("head")[0].appendChild(styleElm);
})();
