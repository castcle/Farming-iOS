//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  FarmingHistoryViewModel.swift
//  Farming
//
//  Created by Castcle Co., Ltd. on 28/3/2565 BE.
//

import Core
import Networking
import SwiftyJSON

final public class FarmingHistoryViewModel {

    private var farmingRepository: FarmingRepository = FarmingRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var farmingRequest: FarmingRequest = FarmingRequest()
    var farmings: [Farming] = []
    var meta: Meta = Meta()
    var farmingHistoryType: FarmingHistoryType = .unknow
    var state: State = .none
    var loadState: LoadState = .loading
    private var farmId: String = ""

    public init(type: FarmingHistoryType = .unknow) {
        self.tokenHelper.delegate = self
        self.farmingHistoryType = type
    }

    func getFarmingActive() {
        self.state = .getFarmingActive
        self.farmingRepository.getFarmingActive { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.farmings = ((json[JsonKey.payload.rawValue].arrayValue).map { Farming(json: $0) }).sorted(by: { $0.number < $1.number })
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue
                    UserHelper.shared.updateAuthorRef(users: users)
                    self.didLoadFarmingFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    func getFarmingHistory() {
        self.state = .getFarmingHistory
        self.farmingRepository.getFarmingHistory(farmingRequest: self.farmingRequest) { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let farmingData = (json[JsonKey.payload.rawValue].arrayValue).map { Farming(json: $0) }
                    self.farmings.append(contentsOf: farmingData)
                    self.meta = Meta(json: JSON(json[JsonKey.meta.rawValue].dictionaryValue))
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue
                    UserHelper.shared.updateAuthorRef(users: users)
                    self.didLoadFarmingFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    func unfarmingCast(farmId: String) {
        self.state = .unfarmingCast
        self.farmId = farmId
        self.farmingRepository.unfarmingCast(userId: UserManager.shared.id, farmId: self.farmId) { (success, _, isRefreshToken)  in
            if success {
                self.getFarmingActive()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    var didLoadFarmingFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension FarmingHistoryViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
//        if self.state == .farmingLookup {
//            self.farmingLookup()
//        } else if self.state == .farmingCast {
//            self.farmingCast()
//        }
    }
}
