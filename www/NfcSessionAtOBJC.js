var exec = require('cordova/exec');

function NfcSessionAtOBJC() {};

NfcSessionAtOBJC.prototype.beginScan = function (success, error) {
    exec(success, error, 'NfcSessionAtOBJC', 'beginScan', []);
};


if(!window.plugins)
    window.plugins = {};

if (!window.plugins.NfcSessionAtOBJC)
    window.plugins.NfcSessionAtOBJC = new NfcSessionAtOBJC();

if (typeof module != 'undefined' && module.exports)
    module.exports = NfcSessionAtOBJC;