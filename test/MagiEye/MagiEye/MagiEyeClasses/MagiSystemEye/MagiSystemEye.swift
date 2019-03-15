//
//  MagiSystem.swift
//  MagiSystemEye
//
//  Created by anran on 2019/3/13.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation


private let HOST_BASIC_INFO_COUNT: mach_msg_type_number_t =
    UInt32(MemoryLayout<host_basic_info_data_t>.size/MemoryLayout<integer_t>.size)

open class MagiSystemEye: NSObject {
    
    // MARK: - OPEN PROPERTY
    static let hardware = MagiHardware.self
    static let cpu      = MagiCPU.self
    static let memory   = MagiMemory.self
    static let network  = MagiNetwork.self
    
    // MARK: - PRIVATE PROPERTY
    static let machHost = mach_host_self()
    
    // MARK: - Internal PROPERTY
    static var hostBasicInfo: host_basic_info {
        get {
            var size     = HOST_BASIC_INFO_COUNT
            var hostInfo = host_basic_info()
            
            let result = withUnsafeMutablePointer(to: &hostInfo) {
                $0.withMemoryRebound(to: integer_t.self,
                                     capacity: Int(size), {
                    host_info(machHost, HOST_BASIC_INFO,$0,&size)
                })
            }
            #if DEBUG
            if result != KERN_SUCCESS {
                fatalError("ERROR - \(#file):\(#function) - kern_result_t = "
                    + "\(result)")
            }
            #endif
            return hostInfo
        }
    }

}
