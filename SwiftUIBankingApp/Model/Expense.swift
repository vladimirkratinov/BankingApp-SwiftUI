//
//  Expense.swift
//  SwiftUIBankingApp
//
//  Created by Vladimir Kratinov on 2023-04-20.
//

import SwiftUI

struct Expense: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var amountSpent: String
    var product: String
    var productIcon: String
    var spendType: String
}
