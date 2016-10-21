@testable import KsApi
import Library
import Prelude
import Prelude_UIKit
import UIKit
import XCPlayground
@testable import Kickstarter_Framework

let project = .cosmicSurgery
//  |> Project.lens.state .~ .successful
  |> Project.lens.dates.deadline .~ NSDate().timeIntervalSince1970 + 60 * 60 * 24 * 2
  |> Project.lens.stats.staticUsdRate .~ 1.32
  |> Project.lens.rewards .~ [Project.cosmicSurgery.rewards.last!]
//  |> Project.lens.personalization.isBacking .~ true
//  |> Project.lens.personalization.backing %~~ { _, project in
//    .template
//      |> Backing.lens.rewardId .~ project.rewards.first?.id
//      |> Backing.lens.reward .~ project.rewards.first
//}

AppEnvironment.replaceCurrentEnvironment(
  apiService: MockService(
    oauthToken: OauthToken(token: "deadbeef"),
    fetchProjectResponse: project
  ),
  config: .template |> Config.lens.countryCode .~ "US",
  mainBundle: NSBundle.framework,
  language: .en
)

initialize()
let controller = ProjectPamphletViewController.configuredWith(projectOrParam: .left(project), refTag: nil)

let (parent, _) = playgroundControllers(device: .pad, orientation: .portrait, child: controller)

let frame = parent.view.frame |> CGRect.lens.size.height .~ 1_800
XCPlaygroundPage.currentPage.liveView = parent
parent.view.frame = frame
