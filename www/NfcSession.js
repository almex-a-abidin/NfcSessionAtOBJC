var exec = require('cordova/exec');

function NfcSession() {};

NfcSession.prototype.beginScan = function (success, error) {
    exec(success, error, 'NfcSession', 'beginScan', []);
};

NfcSession.prototype.getRecordedData = function (success, error) {
    exec(success, error, 'NfcSession', 'getRecordedData', []);
};


if(!window.plugins)
    window.plugins = {};

if (!window.plugins.NfcSession)
    window.plugins.NfcSession = new NfcSession();

if (typeof module != 'undefined' && module.exports)
    module.exports = NfcSession;