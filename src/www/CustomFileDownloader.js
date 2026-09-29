
var exec = require('cordova/exec');

var CustomFileDownloader = {

    download: function (url, success, error) {
        exec(
            success,
            error,
            'CustomFileDownloader',
            'download',
            [url]
        );
    }

};

module.exports = CustomFileDownloader;
