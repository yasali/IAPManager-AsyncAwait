# In-App Purchase Manager for Swift 6 (Swift Concurrency Support)

This repository provides a modern, Swift 6-compliant implementation of an **In-App Purchase (IAP) Manager** using Swift concurrency (`async/await`) and the actor model. The `IAPManager` class simplifies interactions with the StoreKit framework for fetching available products, handling purchases, and restoring transactions.

## Key Features
- **Swift Concurrency**: Fully integrated with `async/await`, replacing outdated closure-based APIs.
- **Actor-Based Design**: Ensures thread safety and isolates state using Swift's `actor` model.
- **Error Handling**: Provides a clean error-handling mechanism using enums and `CheckedContinuation`.
- **Formatted Pricing**: Easily format product prices based on the user's locale.
- **Lifecycle Management**: Handles observer registration for `SKPaymentQueue` to ensure proper lifecycle management.

## Benefits of This Implementation
- **Swift 6 Support**: Fully compatible with strict concurrency features in Swift 6.
- **Simplified API**: Asynchronous methods make the code more readable and manageable.
- **Robust Error Handling**: Leverages structured error types for easier debugging and user feedback.

## Functional Highlights
- **Fetch Products**: Asynchronously retrieve available IAP products defined in a plist file.
- **Purchase Products**: Initiate and handle transactions using `async/await`.
- **Restore Purchases**: Restore previously completed purchases, with detailed status handling.
- **Formatted Prices**: Provide user-friendly currency formatting for product prices.
- **Thread Safety**: Actor isolation ensures thread safety for critical operations.

### How It Works
1. **Fetching Products**
   Use the `getProducts()` method to fetch a list of available products asynchronously:
   ```swift
   let products = try await IAPManager.shared.getProducts()

2. **Buying a Product Purchase a product asynchronously**
   ```swift
   let success = try await IAPManager.shared.buy(product: selectedProduct)

3. **Restoring Purchases Restore previously purchased items**
   ```swift
   let restored = try await IAPManager.shared.restorePurchases()

4. **Formatted Pricing Get a product's price as a localized currency string**
   ```swift
   let price = IAPManager.shared.getPriceFormatted(for: product)

### Installation and Setup

1. **Add the IAP_ProductIDs.plist file to your project, containing the product identifiers.**

2. **Register the IAPManager as an observer in your app's lifecycle**
   ```swift
   IAPManager.shared.startObserving()

4. **Register the IAPManager as an observer in your app's lifecycle**
   ```swift
   IAPManager.shared.stopObserving()

## Acknowledgments

This implementation adheres to best practices for managing in-app purchases, utilizing the latest advancements in Swift concurrency to improve safety, readability, and maintainability. It replaces legacy closure-based APIs with modern async/await for an enhanced developer experience.

Feel free to clone, use, and adapt this code for your own projects!
