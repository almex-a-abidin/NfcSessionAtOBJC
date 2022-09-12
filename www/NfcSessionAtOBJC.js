var exec = require('cordova/exec');

exports.beginScan = function (success, error) {
    exec(success, error, 'NfcSessionAtOBJC', 'beginScan', []);
};
