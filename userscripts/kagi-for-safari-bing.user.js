// ==UserScript==
// @name         Kagi for Safari (Bing redirect)
// @description  Redirects Bing searches to Kagi.com. Only relevant for desktop Safari users.
// @version      0.0.6
// @namespace    jimeh.me
// @downloadURL  https://github.com/jimeh/dotfiles/raw/main/userscripts/kagi-for-safari-bing.user.js
// @updateURL    https://github.com/jimeh/dotfiles/raw/main/userscripts/kagi-for-safari-bing.user.js
// @inject-into  auto
// @run-at       document-start
// @match        https://www.bing.com/search*
// ==/UserScript==
(function () {
  if (
    navigator.vendor.match(/apple/i) && // Only activate in Safari.
    window.location.hostname == "www.bing.com" &&
    window.location.pathname == "/search"
  ) {
    let q = (new URL(window.location)).searchParams.get("q");
    if (q) {
      console.log("Redirecting Bing search to Kagi.com");
      window.location.href = "https://kagi.com/search?q=" + q;
    }
  }
})();
