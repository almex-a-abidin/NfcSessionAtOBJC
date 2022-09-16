var exec = require('cordova/exec');

function NfcSession() {};

NfcSession.prototype.beginScan = function () {
    exec(null, null, 'NfcSession', 'beginScan', []);
};


if(!window.plugins)
    window.plugins = {};

if (!window.plugins.NfcSession)
    window.plugins.NfcSession = new NfcSession();

if (typeof module != 'undefined' && module.exports)
    module.exports = NfcSession;