var exec = require('cordova/exec');

exports.beginScan = function (arg0, success, error) {
    exec(success, error, 'NfcSessionAtOBJC', 'beginScan', [arg0]);
};

exports.tagReaderSession = function (arg0, success, error) {
    exec(success, error, 'NfcSessionAtOBJC', 'tagReaderSession', [arg0]);
};

exports.tagReaderSession = function (arg0, success, error) {
    exec(success, error, 'NfcSessionAtOBJC', 'tagReaderSession', [arg0]);
};