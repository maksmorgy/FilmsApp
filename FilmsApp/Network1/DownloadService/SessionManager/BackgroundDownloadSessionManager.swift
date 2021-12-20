//
//  BackgroundDownloadSessionManager.swift
//  
//
//  Created by Orest Patlyka on 22.06.2021.
//

import Foundation

public final class BackgroundDownloadSessionManager: DownloadSessionManager {
    
    private let session: URLSession
    private let downloadDelegate: DownloadDelegate
    private var completionHandlers: [URLSessionTask: URLSessionDownloadTaskCompletion] = .init()
    
    public init(configuration: URLSessionConfiguration, downloadDelegate: DownloadDelegate) {
        self.downloadDelegate = downloadDelegate
        self.session = .init(
            configuration: configuration,
            delegate: downloadDelegate,
            delegateQueue: nil
        )
        configureDownloadCompletion(downloadDelegate)
    }
    
    private func configureDownloadCompletion(_ downloadDelegate: DownloadDelegate) {
        downloadDelegate.completion = { [weak self] task, location, response, error in
            self?.completionHandlers[task]?(location, response, error)
            self?.completionHandlers.removeValue(forKey: task)
        }
    }
    
    public func download(url: URL, completion: @escaping URLSessionDownloadTaskCompletion) -> URLSessionDownloadTask {
        let task = session.downloadTask(with: url)
        completionHandlers[task] = completion
        task.resume()
        return task
    }
}
