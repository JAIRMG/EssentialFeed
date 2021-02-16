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
        let client = createHTTPClient()
        
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: client)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: client)
        
        let localStoreURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        
        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: localStoreURL)
        }
        
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        window?.rootViewController = FeedUIComposer.feedComposedWith(feedLoader: FeedLoaderWithFallbackComposite(
                                                                        primary: FeedLoaderCacheDecorator(
                                                                            decoratee: remoteFeedLoader,
                                                                            cache: localFeedLoader),
                                                                        fallback: localFeedLoader),
                                                                     imageLoader: FeedImageDataLoaderWithFallBackComposite(
                                                                        primaryLoader: FeedLoaderCacheImageDecorator(decoratee: remoteImageLoader,
                                                                                                                     cache: localImageLoader),
                                                                        fallbackLoader: localImageLoader))
    }
    
    private func createHTTPClient() -> HTTPClient {
        switch UserDefaults.standard.string(forKey: "connectivity") {
            
        case "offline":
            return AlwaysFailingHTTPClient()
        default:
            return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        }
    }
}

private class AlwaysFailingHTTPClient: HTTPClient {
    
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(.failure(NSError(domain: "offline app", code: 0)))
        return Task()
    }
}
