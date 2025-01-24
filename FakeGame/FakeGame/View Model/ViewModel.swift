//
//  ViewModel.swift
//  FakeGame
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation
import StoreKit

@MainActor
protocol ViewModelDelegate {
  func toggleOverlay(shouldShow: Bool)
  func willStartLongProcess()
  func didFinishLongProcess()
  func showIAPRelatedError(_ error: Error)
  func shouldUpdateUI()
  func didFinishRestoringPurchasesWithZeroProducts()
  func didFinishRestoringPurchasedProducts()
}

@MainActor
class ViewModel {
    
  // MARK: - Properties
  
  var delegate: ViewModelDelegate?
  
  private let model = Model()
  
  var availableExtraLives: Int {
      return model.gameData.extraLives
  }
      
  var availableSuperPowers: Int {
      return model.gameData.superPowers
  }
  
  var didUnlockAllMaps: Bool {
      return model.gameData.didUnlockAllMaps
  }
  
  
  // MARK: - Init
      
  init() {

  }
  
  
  // MARK: - Fileprivate Methods
  
  fileprivate func updateGameDataWithPurchasedProduct(_ product: SKProduct) {
    // Update the proper game data depending on the keyword the
    // product identifier of the give product contains.
    if product.productIdentifier.contains("extra_lives") {
        model.gameData.extraLives = 3
    } else if product.productIdentifier.contains("superpowers") {
        model.gameData.superPowers = 2
    } else {
        model.gameData.didUnlockAllMaps = true
    }
    
    // Store changes.
    _ = model.gameData.update()
    
    // Ask UI to be updated and reload the table view.
    delegate?.shouldUpdateUI()
  }
  
  
  fileprivate func restoreUnlockedMaps() {
    // Mark all maps as unlocked.
    model.gameData.didUnlockAllMaps = true
    
    // Save changes and update the UI.
    _ = model.gameData.update()
    delegate?.shouldUpdateUI()
  }
  
  
  
  // MARK: - Internal Methods
  
  func getProductForItem(at index: Int) -> SKProduct? {
    // Search for a specific keyword depending on the index value.
    let keyword: String
    
    switch index {
    case 0: keyword = "extra_lives"
    case 1: keyword = "superpowers"
    case 2: keyword = "unlock_maps"
    default: keyword = ""
    }
    
    // Check if there is a product fetched from App Store containing
    // the keyword matching to the selected item's index.
    guard let product = model.getProduct(containing: keyword) else { return nil }
    return product
  }
  
  
  func didConsumeLive() {
    model.gameData.extraLives -= 1
    _ = model.gameData.update()
  }
  
  
  func didConsumeSuperPower() {
    model.gameData.superPowers -= 1
    _ = model.gameData.update()
  }
  
  
  // MARK: - Methods To Implement
    
  func viewDidSetup() async {
    delegate?.willStartLongProcess()
    do {
      let products = try await IAPManagerWrapper.shared.getProducts()
      self.model.products = products
    } catch {
      self.delegate?.showIAPRelatedError(error)
    }
  }
    
    
  func purchase(product: SKProduct) async -> Bool {
    if await !IAPManagerWrapper.shared.canMakePayments() {
        return false
    } else {
      self.delegate?.willStartLongProcess()
      do {
        _ = try await IAPManagerWrapper.shared.buy(product: product)
        self.delegate?.didFinishLongProcess()
        self.updateGameDataWithPurchasedProduct(product)
      } catch {
        self.delegate?.showIAPRelatedError(error)
      }
    }
    return true
  }
    
    
  func restorePurchases() async {
    delegate?.willStartLongProcess()
    do {
      let success = try await IAPManagerWrapper.shared.restorePurchases()
      if success {
          self.restoreUnlockedMaps()
          self.delegate?.didFinishRestoringPurchasedProducts()
      } else {
          self.delegate?.didFinishRestoringPurchasesWithZeroProducts()
      }
    } catch {
      self.delegate?.showIAPRelatedError(error)
    }
    
  }
}
