//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Jair Moreno Gaspar on 17/02/21.
//

import XCTest
import EssentialFeediOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {
    
    func test_configureWindow_makeKeyWindowKeyAndVisible() {
        let sut = SceneDelegate()
        let window = UIWindow()
        sut.window = window
        
        sut.configureWindow()
        
        XCTAssertTrue(window.isKeyWindow, "Expected window to be key window")
        XCTAssertFalse(window.isHidden, "Expected window to be visible")
    }
    
    func test_configureWindow_configuresToRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root))")
        XCTAssertTrue(topController is FeedViewController, "Expected a FeedViewController as a top controller, got \(String(describing: topController))")
    }
    
}
