var exec = require('cordova/exec');

exports.beginScan = function ( success, error) {
    exec(success, error, 'NfcSessionAtOBJC', 'beginScan', []);
};

exports.tagReaderSession = function (arg0, success, error) {
    exec(success, error, 'NfcSessionAtOBJC', 'tagReaderSession', [arg0]);
};

exports.tagReaderSession = function (arg0, success, error) {
    exec(success, error, 'NfcSessionAtOBJC', 'tagReaderSession', [arg0]);
};