//
//  DownloadDelegate.swift
//  
//
//  Created by Orest Patlyka on 22.06.2021.
//

import Foundation

public struct DownloadInfo {
    public let session: URLSession
    public let downloadTask: URLSessionDownloadTask
    public let bytesWritten: Int64
    public let totalBytesWritten: Int64
    public let totalBytesExpectedToWrite: Int64
}

public final class DownloadDelegate: NSObject, URLSessionDownloadDelegate {

    public var completion: ((URLSessionTask, URL?, URLResponse?, Error?) -> Void)?
    public var receivedData: ((DownloadInfo) -> Void)?
    
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        completion?(downloadTask, location, downloadTask.response, nil)
    }
    
    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        completion?(task, nil, task.response, error)
    }
    
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        receivedData?(.init(
            session: session,
            downloadTask: downloadTask,
            bytesWritten: bytesWritten,
            totalBytesWritten: totalBytesWritten,
            totalBytesExpectedToWrite: totalBytesExpectedToWrite
        ))
    }
}

 
