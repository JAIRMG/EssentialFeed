//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Jair Moreno Gaspar on 02/02/21.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let remoteURL = URL(string: "https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5db4155a4fbade21d17ecd28/1572083034355/essential_app_feed.json")!
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: client)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: client)
        window?.rootViewController = FeedUIComposer.feedComposedWith(feedLoader: remoteFeedLoader,
                                                                     imageLoader: remoteImageLoader)
    }
}

