//
//  ClientSocket.swift
//  Redbird
//
//  Created by Honza Dvorsky on 2/10/16.
//  Copyright © 2016 Honza Dvorsky. All rights reserved.
//

import Socks
import SocksCore

typealias SocketError = SocksCore.Error

protocol Socket: class, SocketReader {
    func write(string: String) throws
    func read(bytes: Int) throws -> [CChar]
    func newWithConfig(config: RedbirdConfig) throws -> Socket
    func close()
}

extension Socket {
    func read() throws -> [CChar] {
        return try self.read(BufferCapacity)
    }
}

class ClientSocket: Socket {
    
    let client: TCPClient
    
    init(address: String, port: Int) throws {
        self.client = try TCPClient(hostname: address, port: port)
    }

    func close() {
        try! self.client.close()
    }
    
    func newWithConfig(config: RedbirdConfig) throws -> Socket {
        return try ClientSocket(address: config.address, port: config.port)
    }
    
    //MARK: Actual functionality
    
    func write(string: String) throws {
        try self.client.write(string)
    }
    
    func read(bytes: Int = BufferCapacity) throws -> [CChar] {
        return try self.client.read(bytes).map { CChar($0) }
    }
}

protocol SocketReader: class {
    func read(bytes: Int) throws -> [CChar]
}

let BufferCapacity = 512

extension SocketReader {

    /// Reads until 1) we run out of characters or 2) we detect the delimiter
    /// whichever happens first.
    func readUntilDelimiter(alreadyRead alreadyRead: [CChar], delimiter: String) throws -> ([CChar], [CChar]?) {
        
        var totalBuffer = alreadyRead
        let delimiterChars = delimiter.ccharArrayView()
        var lastReadCount = BufferCapacity
        
        while true {
            
            //test whether the incoming chars contain the delimiter
            let (head, tail) = totalBuffer.splitAround(delimiterChars)
            
            //if we have a tail, we found the delimiter in the buffer,
            //or if there's no more data to read
            //let's terminate and return the current split
            if tail != nil || lastReadCount < BufferCapacity {
                //end of transmission
                return (head, tail)
            }
            
            //read more characters from the reader
            let readChars = try self.read(BufferCapacity)
            lastReadCount = readChars.count
            
            //append received chars before delimiter
            totalBuffer.appendContentsOf(readChars)
        }
    }
}

extension ClientSocket: SocketReader {}

extension CollectionType where Generator.Element == CChar {
    
    func stringView() throws -> String {
        return try self.toString()
    }
}

