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
    
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(storeURL: localStoreURL)
    }()
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        configureWindow()
    }
    
    func configureWindow() {
        
        let remoteURL = URL(string: "https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5db4155a4fbade21d17ecd28/1572083034355/essential_app_feed.json")!
        let client = createHTTPClient()
        
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: client)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: client)
        
        
        let localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        window?.rootViewController = UINavigationController(rootViewController: FeedUIComposer.feedComposedWith(feedLoader: FeedLoaderWithFallbackComposite(
                                                                        primary: FeedLoaderCacheDecorator(
                                                                            decoratee: remoteFeedLoader,
                                                                            cache: localFeedLoader),
                                                                        fallback: localFeedLoader),
                                                                     imageLoader: FeedImageDataLoaderWithFallBackComposite(
                                                                        primaryLoader: FeedLoaderCacheImageDecorator(decoratee: remoteImageLoader,
                                                                                                                     cache: localImageLoader),
                                                                        fallbackLoader: localImageLoader)))
    }
    
    func createHTTPClient() -> HTTPClient {
        return httpClient
    }
}
