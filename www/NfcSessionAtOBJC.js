var exec = require('cordova/exec');

module.exports.beginScan = function (arg0, success, error) {
    exec(success, error, 'NfcSessionAtOBJC', 'beginScan', [arg0]);
};
