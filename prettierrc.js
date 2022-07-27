const homedir = require('os').homedir();
const fs = require("fs");

function voltaPrettierSearchDirs(voltaDir) {
  const packagesDir = `${voltaDir}/tools/image/packages`;

  let paths = []
  let parents = [];

  fs.readdirSync(packagesDir).forEach((item) => {
    if (/^prettier-plugin-[^/]+$/.test(item)) {
      paths.push(`${packagesDir}/${item}/lib`);
    }

    if (item == '@prettier') {
      paths = paths.concat(
        findDirs(`${packagesDir}/@prettier`, /^plugin-[^/]+$/, "lib")
      );
    } else if (/^@[^/]+$/.test(item)) {
      parents.push(`${packagesDir}/${item}`);
    }

    return [];
  })

  parents.forEach((parent) => {
    paths = paths.concat(findDirs(parent, /^prettier-plugin-[^/]+$/, "lib"));
  })

  return paths;
}

function findDirs(parent, pattern, suffix) {
  return fs.readdirSync(parent).flatMap((item) => {
    const fp = `${parent}/${item}`;
    if (pattern.test(item) && fs.statSync(fp).isDirectory()) {
      if (suffix) {
        return `${fp}/${suffix}`;
      }
      return fp;
    }

    return [];
  });

}

module.exports = {
  pluginSearchDirs: voltaPrettierSearchDirs(`${homedir}/.volta`),
};
