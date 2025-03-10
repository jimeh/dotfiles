// ==UserScript==
// @name         One Dark GitHub Syntax Highlight
// @description  Apply One Dark theme to syntax highlighting on GitHub
// @version      1.0.0
// @namespace    jimeh.me
// @downloadURL  https://github.com/jimeh/dotfiles/raw/main/userscripts/one-dark-github-syntax-highlight.user.js
// @updateURL    https://github.com/jimeh/dotfiles/raw/main/userscripts/one-dark-github-syntax-highlight.user.js
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
/* borrowed from https://github.com/StylishThemes/GitHub-Dark/blob/master/src/themes/github/one-dark.css */

/*! GitHub: One Dark */
/* adapted from: https://github.com/atom/one-dark-syntax & https://github.com/Aerobird98/codemirror-one-dark-theme */
/* by https://github.com/sparcut */
:root {
  --ghd-code-background: hsl(0, 0%, 8%);
  --ghd-code-color: hsl(220, 14%, 71%);
}
/* comment, punctuation.definition.comment, string.comment */
.pl-c,
.pl-c span {
  color: hsl(220, 10%, 40%) !important;
  font-style: italic !important;
}
/* constant, entity.name.constant, variable.other.constant, variable.language,
   support, meta.property-name, support.constant, support.variable,
   meta.module-reference, markup.raw, meta.diff.header */
.pl-c1 {
  color: hsl(29, 54%, 61%) !important;
}
/* string.regexp constant.character.escape */
.pl-sr .pl-cce {
  color: hsl(187, 47%, 55%) !important;
  font-weight: normal !important;
}
.pl-cn {
  color: hsl(29, 54%, 61%) !important;
}
.pl-e {
  /* entity */
  color: hsl(29, 54%, 61%) !important;
}
.pl-ef {
  /* entity.function */
  color: hsl(207, 82%, 66%) !important;
}
.pl-en {
  /* entity.name */
  color: hsl(29, 54%, 61%) !important;
}
.pl-enc {
  /* entity.name.class */
  color: hsl(39, 67%, 69%) !important;
}
.pl-enf {
  /* entity.name.function */
  color: hsl(207, 82%, 66%) !important;
}
.pl-enm {
  /* entity.name.method-name */
  color: hsl(220, 14%, 71%) !important;
}
.pl-ens {
  /* entity.name.section */
  color: hsl(5, 48%, 51%) !important;
}
.pl-ent {
  /* entity.name.tag */
  color: hsl(355, 65%, 65%) !important;
}
.pl-entc {
  /* entity.name.type.class */
  color: hsl(39, 67%, 69%) !important;
}
.pl-enti {
  /* entity.name.type.instance */
  color: hsl(187, 47%, 55%) !important;
}
.pl-entm {
  /* entity.name.type.module */
  color: hsl(355, 65%, 65%) !important;
}
.pl-eoa {
  /* entity.other.attribute-name */
  color: hsl(29, 54%, 61%) !important;
}
.pl-eoac {
  /* entity.other.attribute-name.class */
  color: hsl(29, 54%, 61%) !important;
}
.pl-eoac .pl-pde {
  /* punctuation.definition.entity */
  color: hsl(29, 54%, 61%) !important;
}
.pl-eoai {
  /* entity.other.attribute-name.id */
  color: hsl(207, 82%, 66%) !important;
}
.pl-eoi {
  /* entity.other.inherited-class */
  color: hsl(95, 38%, 62%) !important;
}
.pl-k {
  /* keyword, storage, storage.type */
  color: hsl(286, 60%, 67%) !important;
}
.pl-ko {
  /* keyword.operator */
  color: hsl(220, 14%, 71%) !important;
}
.pl-kolp {
  /* keyword.operator.logical.python */
  color: hsl(286, 60%, 67%) !important;
}
.pl-kos {
  /* keyword.other.special-method */
  color: hsl(207, 82%, 66%) !important;
}
.pl-kou {
  /* keyword.other.unit */
  color: hsl(29, 54%, 61%) !important;
}
.pl-mai .pl-sf {
  /* support.function */
  color: hsl(187, 47%, 55%) !important;
}
.pl-mb {
  /* markup.bold */
  color: hsl(29, 54%, 61%) !important;
  font-weight: bold !important;
}
.pl-mc {
  /* markup.changed, punctuation.definition.changed */
  color: hsl(286, 60%, 67%) !important;
}
.pl-mh {
  /* markup.heading */
  color: hsl(355, 65%, 65%) !important;
}
/* markup.heading punctuation.definition.heading */
.pl-mh .pl-pdh {
  color: hsl(207, 82%, 66%) !important;
}
.pl-mi {
  /* markup.italic */
  color: hsl(286, 60%, 67%) !important;
  font-style: italic !important;
}
.pl-ml {
  /* markup.list */
  color: hsl(187, 47%, 55%) !important;
}
.pl-mm {
  /* meta.module-reference */
  color: hsl(29, 54%, 61%) !important;
}
.pl-mp {
  /* meta.property-name */
  color: hsl(220, 9%, 55%) !important;
}
.pl-mp1 .pl-sf {
  /* meta.property-value support.function */
  color: hsl(220, 14%, 71%) !important;
}
.pl-mq {
  /* markup.quote */
  color: hsl(29, 54%, 61%) !important;
}
.pl-mr {
  /* meta.require */
  color: hsl(207, 82%, 66%) !important;
}
.pl-ms {
  /* meta.separator */
  color: hsl(220, 14%, 71%) !important;
}
/* punctuation.definition.bold */
.pl-pdb {
  color: hsl(39, 67%, 69%) !important;
  font-weight: bold !important;
}
/* punctuation.definition.comment */
.pl-pdc {
  color: hsl(220, 10%, 40%) !important;
  font-style: italic !important;
}
.pl-pdc1 {
  /* punctuation.definition.constant */
  color: hsl(220, 14%, 71%) !important;
}
.pl-pde {
  /* punctuation.definition.entity */
  color: hsl(286, 60%, 67%) !important;
}
/* punctuation.definition.italic */
.pl-pdi {
  color: hsl(286, 60%, 67%) !important;
  font-style: italic !important;
}
/* punctuation.definition.string, source.regexp, string.regexp.character-class */
.pl-pds {
  color: hsl(95, 38%, 62%) !important;
}
.pl-pdv {
  /* punctuation.definition.variable */
  color: hsl(355, 65%, 65%) !important;
}
/* string punctuation.section.embedded source */
.pl-pse .pl-s1 {
  color: hsl(95, 38%, 62%) !important;
}
.pl-pse .pl-s2 {
  /* punctuation.section.embedded source */
  color: hsl(39, 67%, 69%) !important;
}
.pl-s {
  /* string */
  color: hsl(95, 38%, 62%) !important;
}
.pl-s1 {
  /* string */
  color: hsl(95, 38%, 62%) !important;
}
.pl-s2 {
  /* source */
  color: hsl(39, 67%, 69%) !important;
}
.pl-mp .pl-s3 {
  /* support */
  color: hsl(29, 54%, 61%) !important;
}
.pl-s3 {
  /* support */
  color: hsl(29, 54%, 61%) !important;
}
.pl-sc {
  /* support.class */
  color: hsl(39, 67%, 69%) !important;
}
.pl-scp {
  /* support.constant.property-value */
  color: hsl(220, 14%, 71%) !important;
}
.pl-sf {
  /* support.function */
  color: hsl(187, 47%, 55%) !important;
}
.pl-smc {
  /* storage.modifier.c */
  color: hsl(220, 14%, 71%) !important;
}
/* variable.parameter.function, storage.modifier.package,
storage.modifier.import, storage.type.java, variable.other */
.pl-smi {
  color: hsl(355, 65%, 65%) !important;
}
.pl-smp {
  /* storage.modifier.package */
  color: hsl(39, 67%, 69%) !important;
}
.pl-sok {
  /* support.other.keyword */
  color: hsl(29, 54%, 61%) !important;
}
.pl-sol {
  /* string.other.link */
  color: hsl(355, 65%, 65%) !important;
}
.pl-som {
  /* support.other.module */
  color: hsl(220, 14%, 71%) !important;
}
.pl-sr {
  /* string.regexp */
  color: hsl(187, 47%, 55%) !important;
}
/* string.regexp string.regexp.arbitrary-repitition */
.pl-sr .pl-sra {
  color: hsl(187, 47%, 55%) !important;
}
.pl-src {
  /* string.regexp.character-class */
  color: hsl(187, 47%, 55%) !important;
}
.pl-sr .pl-sre {
  /* string.regexp source.ruby.embedded */
  color: hsl(39, 67%, 69%) !important;
}
.pl-st {
  /* support.type */
  color: hsl(187, 47%, 55%) !important;
}
.pl-stj {
  /* storage.type.java */
  color: hsl(39, 67%, 69%) !important;
}
.pl-stp {
  /* support.type.property-name */
  color: hsl(220, 9%, 55%) !important;
}
.pl-sv {
  /* support.variable */
  color: hsl(29, 54%, 61%) !important;
}
.pl-v {
  /* variable */
  color: hsl(39, 67%, 69%) !important;
}
.pl-vi {
  /* variable.interpolation */
  color: hsl(5, 48%, 51%) !important;
}
.pl-vo {
  /* variable.other */
  color: hsl(187, 47%, 55%) !important;
}
.pl-vpf {
  /* variable.parameter.function */
  color: hsl(220, 14%, 71%) !important;
}
/* markup.inserted, meta.diff.header.to-file, punctuation.definition.inserted */
.pl-mi1 {
  color: hsl(95, 38%, 62%) !important;
  background: #020 !important;
}
/* meta.diff.header.to-file */
.pl-mdht {
  color: hsl(95, 38%, 62%) !important;
  background: #020 !important;
}
/* markup.deleted, meta.diff.header.from-file, punctuation.definition.deleted */
.pl-md {
  color: hsl(355, 65%, 65%) !important;
  background: #200 !important;
}
/* meta.diff.header.from-file */
.pl-mdhf {
  color: hsl(355, 65%, 65%) !important;
  background: #200 !important;
}
/* meta.diff.range */
.pl-mdr {
  color: hsl(220, 14%, 71%) !important;
  font-weight: normal !important;
}
.pl-mdh {
  /* meta.diff.header */
  color: hsl(355, 65%, 65%) !important;
  font-weight: normal !important;
}
.pl-mdi {
  /* meta.diff.index */
  color: hsl(355, 65%, 65%) !important;
  font-weight: normal !important;
}
/* constant.other.reference.link, string.other.link */
.pl-corl {
  color: hsl(355, 65%, 65%) !important;
  text-decoration: underline !important;
}
.pl-ib {
  /* invalid.broken */
  background-color: hsl(355, 65%, 65%) !important;
}
/* invalid.broken, invalid.deprecated, invalid.unimplemented, message.error,
   brackethighlighter.unmatched, sublimelinter.mark.error */
.pl-bu,
.pl-ii {
  /* invalid.illegal */
  background-color: hsl(0, 70%, 60%) !important;
}
.pl-mo {
  /* meta.output */
  color: hsl(220, 14%, 71%) !important;
}
.pl-mri {
  /* markup.raw.inline */
  color: hsl(95, 38%, 62%) !important;
}
.pl-ms1 {
  /* meta.separator */
  color: hsl(220, 14%, 71%) !important;
  background-color: #373b41 !important;
}
.pl-va {
  /* variable.assignment */
  color: hsl(220, 14%, 71%) !important;
}
.pl-vpu {
  /* variable.parameter.url */
  color: hsl(220, 14%, 71%) !important;
}
.pl-entl {
  /* entity.name.tag.label */
  color: hsl(355, 65%, 65%) !important;
}
.pl-token.active,
.pl-token:hover {
  background: hsl(207, 82%, 66%) !important;
  color: hsl(0, 0%, 8%) !important;
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
