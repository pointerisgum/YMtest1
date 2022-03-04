//
//  MainTabBarController.swift
//  Lulla
//
//  Created by 김영민 on 2020/12/23.
//

import UIKit

extension MainTabBarController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

// MARK: - MainTabBarController

final class MainTabBarController: UITabBarController {
    
    private(set) var onceFlag = (willAppear: false, didAppear: false)
    
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverStatusCheck()
        
        tabBar.tintColor = UIColor.color_18a0fb
        tabBar.backgroundImage = UIImage(color: UIColor(hex: 0xffffff))
        tabBar.shadowImage = UIImage(color: UIColor(hex: 0xefefef), size: CGSize(width: 1, height: 0.5))
        tabBar.isTranslucent = false

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        }

        var vcs: [UIViewController] = []
        vcs.append({ () -> UIViewController in
            let vc = HomeViewController.instantiate()
            vc.tabBarItem = UITabBarItem(title: HTempSTR("홈"), image: UIImage(named: "btnNav01Disabled"), selectedImage: UIImage(named: "btnNav01Active"))
            return vc
            }())
        vcs.append({ () -> UIViewController in
            let vc = OrderViewController.instantiate()
            vc.tabBarItem = UITabBarItem(title: HTempSTR("발주"), image: UIImage(named: "btnNav02Disabled"), selectedImage: UIImage(named: "btnNav02Active"))
            return vc
            }())
        vcs.append({ () -> UIViewController in
            let vc = ReleaseViewController.instantiate()
            vc.tabBarItem = UITabBarItem(title: HTempSTR("출고 QR"), image: UIImage(named: "btnNav03Disabled"), selectedImage: UIImage(named: "btnNav03Active"))
            return vc
            }())
        vcs.append({ () -> UIViewController in
            let vc = IssueViewController.instantiate()
            vc.tabBarItem = UITabBarItem(title: HTempSTR("이슈"), image: UIImage(named: "btnNav04Disabled"), selectedImage: UIImage(named: "btnNav04Active"))
            return vc
            }())
        vcs.append({ () -> UIViewController in
            let vc = BalanceViewController.instantiate()
            vc.tabBarItem = UITabBarItem(title: HTempSTR("정산"), image: UIImage(named: "btnNav05Disabled"), selectedImage: UIImage(named: "btnNav05Active"))
            return vc
            }())

        vcs.forEach {
            $0.tabBarItem.image = $0.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            $0.tabBarItem.selectedImage = $0.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
//            $0.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10, weight: .medium), .foregroundColor: UIColor(hex: 0x9e9e9e)], for: .normal)
            $0.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10, weight: .medium), .foregroundColor: UIColor(hex: 0x9e9e9e)], for: .normal)
            $0.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10, weight: .medium), .foregroundColor: UIColor(hex: 0x18a0fb)], for: .selected)

            if let title = $0.tabBarItem.title, title.count > 0 {
                $0.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                $0.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
            } else {
                $0.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            }
        }
        
        viewControllers = vcs.compactMap { UMNavigationController(rootViewController: $0) }
        delegate = self
        
        selectedIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if onceFlag.didAppear == false {
            onceFlag.didAppear = true
        }
        
    }
    
    private func serverStatusCheck () {

    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx + 1, let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView }).first else { return }
        
        imageView.layer.add(bounceAnimation, forKey: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
}
