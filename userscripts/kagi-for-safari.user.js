// ==UserScript==
// @name        Kagi Search (DuckDuckGo redirect)
// @description Redirects DuckDuckGo searches to Kagi.com. Only relevant for desktop Safari users.
// @version     0.0.1
// @namespace   jimeh.me
// @downloadURL https://github.com/jimeh/dotfiles/blob/main/userscripts/kagi-for-safari.user.js
// @run-at      document-start
// @match       https://duckduckgo.com/*
// ==/UserScript==
(function () {
  if (
    window.location.hostname == "duckduckgo.com" &&
    window.location.pathname == "/"
  ) {
    let q = (new URL(window.location)).searchParams.get("q");
    if (q) {
      window.location.href = "https://kagi.com/search?q=" + q;
    }
  }
})();
