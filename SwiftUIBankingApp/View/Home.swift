//
//  Home.swift
//  SwiftUIBankingApp
//
//  Created by Vladimir Kratinov on 2023-04-20.
//

import SwiftUI

struct Home: View {
    var proxy: ScrollViewProxy
    var size: CGSize
    var safeArea: EdgeInsets
    /// View Properties
    @State private var activePage: Int = 1
    @State private var myCards: [Card] = sampleCards
    /// Page Offset
    @State private var offset: CGFloat = 0
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ProfileCard()
                
                // Indicator
                Capsule()
                    .fill(.gray.opacity(0.2))
                    .frame(width: 50, height: 5)
                    .padding(.vertical, 5)
                
                /// Page Tab View Height Based on Screen Height
                let pageHeight = size.height * 0.65
                /// Page Tab View
                /// To Keep Track of MinY
                GeometryReader {
                    let proxy = $0.frame(in: .global)
                    
                    TabView(selection: $activePage) {
                        ForEach(myCards) { card in
                            ZStack {
                                if card.isFirstBlankCard {
                                    Rectangle()
                                        .fill(.clear)
                                } else {
                                    /// Card View
                                    CardView(card: card)
                                }
                            }
                            .frame(width: proxy.width - 60)
                            /// Page Tag (Index)
                            .tag(index(card))
                            .offsetX(activePage == index(card)) { rect in
                                /// Calculating Entire Page Offset
                                let minX = rect.minX
                                let pageOffset = minX - (size.width * CGFloat(index(card)))
                                offset = pageOffset
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background {
                        RoundedRectangle(cornerRadius: 40 * reverseProgress(size), style: .continuous)
                            .fill(Color("ExpandBG").gradient)
                            .frame(height: pageHeight + fullScreenHeight(size, pageHeight, safeArea))
                            /// Expanding to Full Screen, Based on the Progress
                            .frame(
                                width: proxy.width - (60 * reverseProgress(size)),
                                height: pageHeight,
                                alignment: .top
                            )
                            /// Making it Little Visible at Idle
                            .offset(x: -15 * reverseProgress(size))
                            .scaleEffect(0.95 + (0.05 * progress(size)), anchor: .leading)
                            /// Moving Along Side With the Second Card
                            .offset(x: (offset + size.width) < 0 ? (offset + size.width) : 0)
                            /// Card is expanding to full screen height with the help of the progress we calculated,
                            /// also it's expanding from the subview's top position and not from the main view.
                            /// With the help of Geometry Reader's minY property, we can push the view to the top of the Main View.
                            .offset(y: (offset + size.width) > 0 ? (-proxy.minY * progress(size)) : 0)
                    }
                }
                .frame(height: pageHeight)
                /// Making it above All the Views
                .zIndex(1000)
                
                /// Displaying Expenses
                ExpensesView(expenses: myCards[activePage].expenses)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                
//                Text("\(offset)")
            }
            .padding(.top, safeArea.top + 15)
            .padding(.bottom, safeArea.bottom + 15)
        }
    }
    
    /// Profile Card View
    @ViewBuilder
    func ProfileCard() -> some View {
        HStack(spacing: 4) {
            Text("Hello,")
                .font(.title2)
            
            Text("CardHolder")
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(1)
                
            
            Spacer(minLength: 0)
            
            Image("Pic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 35)
        .background {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(.systemTeal).opacity(0.5))
        }
        .padding(.horizontal, 30)
    }
    
    /// Returns Index for Given Card
    func index(_ of: Card) -> Int {
        return myCards.firstIndex(of: of) ?? 0
    }
    
    /// Full Screen Height
    func fullScreenHeight(_ size: CGSize,_ pageHeight: CGFloat,_ safeArea: EdgeInsets) -> CGFloat {
        let progress = progress(size)
        let remainingScreenHeight = progress * (size.height - (pageHeight - safeArea.top - safeArea.bottom))
        /// Because the page height is already applied, calculate the remaining screen height
        /// and add it based on the progress.
        return remainingScreenHeight
    }
    
    
    /// Converts Offset Into Progress ( 0 - 1 )
    func progress(_ size: CGSize) -> CGFloat {
        let pageOffset = offset + size.width
        let progress = pageOffset / size.width
        return min(progress, 1)
    }
    
    /// Reverse Progress ( 1 - 0 )
    func reverseProgress(_ size: CGSize) -> CGFloat {
        let progress = 1 - progress(size)
        return max(progress, 0)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Card View
struct CardView: View {
    var card: Card
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(card.cardColor.gradient)
                    /// Card Details
                    .overlay(alignment: .top) {
                        VStack {
                            HStack {
                                Image("Sim")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 65, height: 65)
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "wave.3.right")
                                    .font(.largeTitle.bold())
                            }
                            
                            Spacer(minLength: 0)
                            
                            Text(card.cardBalance)
                                .font(.largeTitle.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(30)
                    }
                
                Rectangle()
                    .fill(.black)
                    .frame(height: size.height / 3)
                    /// Card Details
                    .overlay {
                        VStack {
                            Text(card.cardName)
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer(minLength: 0)
                            
                            HStack {
                                Text("Debit Card")
                                    .font(.callout)
                                
                                Spacer(minLength: 0)
                                
                                Image("Visa")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(25)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
        }
    }
}

/// Expenses View
struct ExpensesView: View {
    var expenses: [Expense]
    var body: some View {
        VStack(spacing: 12) {
            ForEach(expenses) { expense in
                HStack(spacing: 12) {
                    Image(expense.productIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55, height: 55)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(expense.product)
                        Text(expense.spendType)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(expense.amountSpent)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
