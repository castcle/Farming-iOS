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
//  FarmingHistoryViewController.swift
//  Farming
//
//  Created by Castcle Co., Ltd. on 28/3/2565 BE.
//

import UIKit
import Core
import Component
import Networking
import XLPagerTabStrip

class FarmingHistoryViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = FarmingHistoryViewModel()
    var pageIndex: Int = 0
    var pageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
        if self.viewModel.farmingHistoryType == .active {
            self.viewModel.getFarmingActive()
        } else if self.viewModel.farmingHistoryType == .history {
            self.viewModel.getFarmingHistory()
        }
        self.tableView.coreRefresh.addHeadRefresh(animator: FastAnimator()) {
            self.tableView.coreRefresh.resetNoMore()
            self.tableView.isScrollEnabled = false
            self.viewModel.farmings = []
            self.viewModel.farmingRequest = FarmingRequest()
            self.viewModel.meta = Meta()
            self.viewModel.loadState = .loading
            self.tableView.reloadData()
            if self.viewModel.farmingHistoryType == .active {
                self.viewModel.getFarmingActive()
            } else if self.viewModel.farmingHistoryType == .history {
                self.viewModel.getFarmingHistory()
            }
        }
        self.tableView.coreRefresh.addFootRefresh(animator: NormalFooterAnimator()) {
            if self.viewModel.farmingHistoryType == .active {
                self.tableView.coreRefresh.noticeNoMoreData()
            } else {
                self.viewModel.farmingRequest.untilId = self.viewModel.meta.oldestId
                self.viewModel.getFarmingHistory()
            }
        }
        self.viewModel.didLoadFarmingFinish = {
            CCLoading.shared.dismiss()
            self.viewModel.loadState = .loaded
            self.tableView.isScrollEnabled = true
            self.tableView.coreRefresh.endHeaderRefresh()
            self.tableView.coreRefresh.endLoadingMore()
            if self.viewModel.farmingHistoryType == .active {
                self.tableView.coreRefresh.noticeNoMoreData()
            } else {
                if self.viewModel.meta.resultCount < self.viewModel.farmingRequest.maxResults {
                    self.tableView.coreRefresh.noticeNoMoreData()
                }
            }
            self.tableView.reloadData()
        }
        self.viewModel.didError = {
            CCLoading.shared.dismiss()
        }
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.skeletonUser, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.skeletonUser)
        self.tableView.register(UINib(nibName: FarmingNibVars.TableViewCell.activeFarming, bundle: ConfigBundle.farming), forCellReuseIdentifier: FarmingNibVars.TableViewCell.activeFarming)
        self.tableView.register(UINib(nibName: FarmingNibVars.TableViewCell.farmingHistory, bundle: ConfigBundle.farming), forCellReuseIdentifier: FarmingNibVars.TableViewCell.farmingHistory)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension FarmingHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.loadState == .loading {
            return 5
        } else {
            return self.viewModel.farmings.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.loadState == .loading {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.skeletonUser, for: indexPath as IndexPath) as? SkeletonUserTableViewCell
            cell?.configCell()
            cell?.backgroundColor = UIColor.Asset.cellBackground
            return cell ?? SkeletonUserTableViewCell()
        } else {
            if self.viewModel.farmingHistoryType == .active {
                let cell = tableView.dequeueReusableCell(withIdentifier: FarmingNibVars.TableViewCell.activeFarming, for: indexPath as IndexPath) as? ActiveFarmingTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.configCell(farming: self.viewModel.farmings[indexPath.row])
                cell?.delegate = self
                return cell ?? ActiveFarmingTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: FarmingNibVars.TableViewCell.farmingHistory, for: indexPath as IndexPath) as? FarmingHistoryTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.configCell(farming: self.viewModel.farmings[indexPath.row])
                return cell ?? FarmingHistoryTableViewCell()
            }
        }
    }
}

extension FarmingHistoryViewController: ActiveFarmingTableViewCellDelegate {
    func activeFarmingTableViewCellDidUnfarm(_ cell: ActiveFarmingTableViewCell, farming: Farming) {
        CCLoading.shared.show(text: "Unfarming")
        self.viewModel.unfarmingCast(farmId: farming.id)
    }
}

extension FarmingHistoryViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}
