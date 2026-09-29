var exec = require('cordova/exec');

var CustomFileDownloader = {

    download: function (url, fileName, success, error) {

        try {

            exec(
                success,
                error,
                'CustomFileDownloader',
                'download',
                [url, fileName]
            );

        } catch (e) {

            if (error) {
                error("EXEC ERROR: " + e.message);
            }
        }
    },

    open: function (filePath, success, error) {

        try {

            exec(
                success,
                error,
                'CustomFileDownloader',
                'open',
                [filePath]
            );

        } catch (e) {

            if (error) {
                error("EXEC ERROR: " + e.message);
            }
        }
    }

};

module.exports = CustomFileDownloader;
