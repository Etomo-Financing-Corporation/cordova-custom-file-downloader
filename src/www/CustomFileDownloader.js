var exec = require('cordova/exec');

var CustomFileDownloader = {

    download: function (url, success, error) {

        try {

            exec(
                success,
                error,
                'CustomFileDownloader',
                'download',
                [url]
            );

        } catch (e) {

            if (error) {
                error("EXEC ERROR: " + e.message);
            }
        }
    }

};

module.exports = CustomFileDownloader;
