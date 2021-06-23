//
//  CheckNetworkConnection.swift
//  testForPryaniky
//
//  Created by adeleLover on 23.06.2021.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
