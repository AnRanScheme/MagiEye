//
//  MagiURLEyeProtocol.swift
//  MagiNetworkEye
//
//  Created by anran on 2019/3/12.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

class MagiEyeURLProtocol: URLProtocol {
    
    fileprivate var connection: NSURLConnection?
    fileprivate var ca_request: URLRequest?
    fileprivate var ca_response: URLResponse?
    fileprivate var ca_data: Data?
    fileprivate static let AppNetworkGreenCard = "AppNetworkGreenCard"
    private(set) static  var delegates = NSHashTable<MagiNetworkEyeDelegate>(options: NSPointerFunctions.Options.weakMemory)
    
    class func open() {
        URLProtocol.registerClass(self.classForCoder())
    }
    
    class func close() {
        URLProtocol.unregisterClass(self.classForCoder())
    }
    
    open class func add(delegate: MagiNetworkEyeDelegate) {
        delegates.add(delegate)
    }
    
    open class func remove(delegate: MagiNetworkEyeDelegate) {
        delegates.remove(delegate)
    }
    
    
}

extension MagiEyeURLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        
        guard let scheme = request.url?.scheme,
            scheme == "http" || scheme == "https" else {
                return false
        }
        
        guard URLProtocol.property(
            forKey: AppNetworkGreenCard,
            in: request) == nil else {
                return false
        }
        
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        
        let req = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: AppNetworkGreenCard, in: req)
        return req.copy() as! URLRequest
    }
    
    override func startLoading() {
        let request = MagiEyeURLProtocol.canonicalRequest(for: self.request)
        if #available(iOS 9.0, *) {
            
        }
        else {
           self.connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        }
        self.ca_request = self.request
    }
    
    override func stopLoading() {
        self.connection?.cancel()
        for element in MagiEyeURLProtocol.delegates.allObjects {
            element.networkEyeDidCatch(
                with: self.ca_request,
                response: self.ca_response,
                data: self.ca_data)
        }
    }
    
}

extension MagiEyeURLProtocol: NSURLConnectionDelegate {
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        self.client?.urlProtocol(self, didFailWithError: error)
    }
    
    func connectionShouldUseCredentialStorage(_ connection: NSURLConnection) -> Bool {
        return true
    }
    
    func connection(_ connection: NSURLConnection, didReceive challenge: URLAuthenticationChallenge) {
        self.client?.urlProtocol(self, didReceive: challenge)
    }
    
    func connection(_ connection: NSURLConnection, didCancel challenge: URLAuthenticationChallenge) {
        self.client?.urlProtocol(self, didCancel: challenge)
    }
    
}

extension MagiEyeURLProtocol: NSURLConnectionDataDelegate {
    
    func connection(_ connection: NSURLConnection, willSend request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
        if response != nil {
            self.ca_response = response
            self.client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response!)
        }
        return request
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.allowed)
        self.ca_response = response
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
        if self.ca_data == nil {
            self.ca_data = data
        }else {
            self.ca_data!.append(data)
        }
    }
    
    func connection(_ connection: NSURLConnection, willCacheResponse cachedResponse: CachedURLResponse) -> CachedURLResponse? {
        return cachedResponse
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        self.client?.urlProtocolDidFinishLoading(self)
    }
}
