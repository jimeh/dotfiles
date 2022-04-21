// ==UserScript==
// @name         GitHub Dark Tweaks
// @description  Custom tweaks for GitHub Dark (https://github.com/StylishThemes/GitHub-Dark)
// @version      1.0.4
// @namespace    jimeh.me
// @downloadURL  https://github.com/jimeh/dotfiles/raw/main/userscripts/github-dark-tweaks.user.js
// @updateURL    https://github.com/jimeh/dotfiles/raw/main/userscripts/github-dark-tweaks.user.js
// @inject-into  content
// @run-at       document-end
// @match        *://*githubusercontent.com/*
// @match        *://*githubstatus.com/*
// @match        *://github.com/*
// ==/UserScript==
(function () {
  if (
    window.location.hostname == "githubusercontent.com" ||
    window.location.hostname == "githubstatus.com" ||
    window.location.href.match("^https?://((education|graphql|guides|raw|resources|status|developer|support|vscode-auth)\\.)?github\\.com/((?!(sponsors)).)*$")
  ) {
    const css = `
/*
  GitHub Diff Tweaks

  Make red/green diff background colors more subtle, with configuration
  options to fully customize them.
*/
.blob-num-deletion {
  color: #f85149 !important;
  background-color: rgba(218, 54, 51, 0.05) !important;
}

.blob-code-deletion {
  background-color: rgba(218, 54, 51, 0.15) !important;
}

.blob-code-deletion .x {
  color: #eee !important;
  background-color: rgba(218, 54, 51, 0.45) !important;
}

.blob-num-addition {
  color: #3fb950 !important;
  background-color: rgba(35, 134, 54, 0.05) !important;
}

.blob-code-addition {
  background-color: rgba(35, 134, 54, 0.15) !important;
}

.blob-code-addition .x {
  color: #eee !important;
  background-color: rgba(35, 134, 54, 0.6) !important;
}

.diff-table > tbody > tr[data-hunk]:hover > td::after,
.highlight > tbody > tr:hover > td::after {
  background: rgba(255, 255, 255, 0.04) !important;
}

.diff-table > tbody > tr[data-hunk]:hover > td.selected-line::after,
.highlight > tbody > tr:hover > td.blob-code-inner.highlighted::after {
  background: rgba(255, 255, 255, 0.08) !important;
}

/*
  GitHub Search Tweaks

  Make keyword highlight background a bit more obvious.
*/
.blob-code .hx_keyword-hl {
  background-color: rgba(107, 82, 23, 0.4) !important;
}
  `;

    let styleElm = document.createElement('style');
    if (styleElm.styleSheet) {
      styleElm.styleSheet.cssText = css; // Support for IE
    } else {
      styleElm.appendChild(document.createTextNode(css));
    }
    document.getElementsByTagName("head")[0].appendChild(styleElm);
  }
})();
