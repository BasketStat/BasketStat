//
//  BaseService.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/30/24.
//

import Foundation

class BaseService {
  unowned let provider: ServiceProviderProtocol

  init(provider: ServiceProviderProtocol) {
    self.provider = provider
  }
}
