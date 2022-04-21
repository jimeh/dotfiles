// ==UserScript==
// @name         Kagi for Safari (DuckDuckGo redirect)
// @description  Redirects DuckDuckGo searches to Kagi.com. Only relevant for desktop Safari users.
// @version      0.0.5
// @namespace    jimeh.me
// @downloadURL  https://github.com/jimeh/dotfiles/raw/main/userscripts/kagi-for-safari.user.js
// @updateURL    https://github.com/jimeh/dotfiles/raw/main/userscripts/kagi-for-safari.user.js
// @inject-into  auto
// @run-at       document-start
// @match        https://duckduckgo.com/*
// ==/UserScript==
(function () {
  if (
    navigator.vendor.match(/apple/i) && // Only activate in Safari.
    window.location.hostname == "duckduckgo.com" &&
    window.location.pathname == "/"
  ) {
    let q = (new URL(window.location)).searchParams.get("q");
    if (q) {
      console.log("Redirecting DuckDuckGo search to Kagi.com");
      window.location.href = "https://kagi.com/search?q=" + q;
    }
  }
})();
