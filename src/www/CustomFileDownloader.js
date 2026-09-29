var exec = require('cordova/exec');

var CustomFileDownloader = {

    download: function (url, success, error) {

        exec(
            function (filePath) {
                if (success) {
                    success(filePath);
                }
            },
            function (errorMessage) {
                if (error) {
                    error(errorMessage);
                }
            },
            'CustomFileDownloader',
            'download',
            [url]
        );
    }

};

module.exports = CustomFileDownloader;
