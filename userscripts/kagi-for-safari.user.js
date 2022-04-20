// ==UserScript==
// @name        Kagi Search (Yahoo redirect)
// @description Redirects Yahoo searches to Kagi.com. Only relevant for desktop Safari users.
// @version     0.0.3
// @namespace   jimeh.me
// @downloadURL https://github.com/jimeh/dotfiles/blob/main/userscripts/kagi-for-safari.user.js
// @run-at      document-start
// @match       https://yahoo.com/search*
// @match       https://search.yahoo.com/search*
// @match       https://*.search.yahoo.com/search*
// ==/UserScript==
(function () {
  if (
    navigator.vendor.match(/apple/i) && // Only activate in Safari.
    window.location.hostname.slice(-16) == "search.yahoo.com" &&
    window.location.pathname == "/search"
  ) {
    let q = (new URL(window.location)).searchParams.get("p");
    if (q) {
      console.log("Redirecting Yahoo search to Kagi.com");
      window.location.href = "https://kagi.com/search?q=" + q;
    }
  }
})();
