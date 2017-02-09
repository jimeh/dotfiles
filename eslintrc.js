module.exports = {
  'extends': 'semistandard',
  'installedESLint': true,
  'plugins': [
    'standard'
  ],
  'rules': {
    'semi': [2, 'always'],
    'no-extra-semi': 2,
    'semi-spacing': [2, { 'before': false, 'after': true }]
  }
};
