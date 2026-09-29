
import Foundation
import UIKit

@objc(CustomFileDownloader)
class CustomFileDownloader: CDVPlugin {

    @objc(download:)
    func download(command: CDVInvokedUrlCommand) {

        guard let urlString = command.argument(at: 0) as? String,
              let url = URL(string: urlString) else {

            let result = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: "Invalid URL"
            )

            self.commandDelegate.send(result, callbackId: command.callbackId)
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { location, response, error in

            if let error = error {

                let result = CDVPluginResult(
                    status: CDVCommandStatus_ERROR,
                    messageAs: error.localizedDescription
                )

                self.commandDelegate.send(result, callbackId: command.callbackId)
                return
            }

            guard let location = location else {

                let result = CDVPluginResult(
                    status: CDVCommandStatus_ERROR,
                    messageAs: "Downloaded file location is unavailable"
                )

                self.commandDelegate.send(result, callbackId: command.callbackId)
                return
            }

            do {

                let fileManager = FileManager.default

                let documentsDirectory = fileManager.urls(
                    for: .documentDirectory,
                    in: .userDomainMask
                ).first!

                let fileName = response?.suggestedFilename ?? "download.pdf"

                let destinationURL = documentsDirectory.appendingPathComponent(fileName)

                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }

                try fileManager.moveItem(
                    at: location,
                    to: destinationURL
                )

                let result = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: destinationURL.absoluteString
                )

                self.commandDelegate.send(result, callbackId: command.callbackId)

            } catch {

                let result = CDVPluginResult(
                    status: CDVCommandStatus_ERROR,
                    messageAs: error.localizedDescription
                )

                self.commandDelegate.send(result, callbackId: command.callbackId)
            }
        }

        task.resume()
    }
}
