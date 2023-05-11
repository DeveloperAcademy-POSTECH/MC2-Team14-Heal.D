import SwiftUI

struct SnapCarousel: View {
    @EnvironmentObject var UIState: UIStateModel
    @State private var progressBig: CGFloat = 0.75
    @State private var progressMedium: CGFloat = 1.26
    @State private var progressSmall: CGFloat = 1.1
    
    var body: some View {
        let spacing: CGFloat = 16
        let widthOfHiddenCards: CGFloat = 32
        let cardHeight: CGFloat = 150
        
        let items = [ // 가족추가를 하거나 가족 데이터를 받아올때, 마지막에 비어있는 가족구성원 객체를 한개 더 만들기
            // 그래야 for each에서 마지막 인덱스에스 가족추가하는 뷰를 구성이 가능
            // 처음엔 본인 데이터만 있으니 본인객체 + 비어있는 객체 = 배열의 길이가 2
            // 가족 다 추가하면 예를들어 본인 포함해서 가족이 총 4명일 경우 배열의 길이는 4 + 1 = 5
            // 추가할때는 기존 비어있는 객체 lastIndex로 삭제한 다음에 추가하고 다시 추가
            Card(id: 0, name: "가족"),
            Card(id: 1, name: "아버지"),
            Card(id: 2, name: "어머니"),
            Card(id: 3, name: "나"),
            Card(id: 4, name: "ㄱㄱ") // 비어있는 객체
        ]
        
        return Canvas {
            Carousel(
                numberOfItems: CGFloat(items.count),
                spacing: spacing,
                widthOfHiddenCards: widthOfHiddenCards
            ) {
                ForEach(items, id: \.self.id) { item in // if문으로 분기처리해서 비어있는 객체라고 판단될 경우 추가 버튼 및 안내문 출력
                        Item(
                            _id: Int(item.id),
                            spacing: spacing,
                            widthOfHiddenCards: widthOfHiddenCards,
                            cardHeight: cardHeight
                        ) {
                            HStack {
                                if item.id != items.count - 1 {
                                    VStack {
                                        Text(item.name)
                                        Text("칼로리")
                                        Text("걸음수")
                                        Text("운동시간")
                                    }
                                    .frame(width: 130, height: 130)
                                } else {
                                    VStack {
                                        Text("가족 추가하기")
                                            .padding()
                                        Button(action:{print("가족 추가하기")}){
                                        Image(systemName: "plus")
                                        .imageScale(.large)
                                        .font(.largeTitle)
                                        }
                                    }
                                    
                                }
                                if item.id != items.count - 1 {
                                    VStack {
                                        ActivityRings(big: $progressBig,
                                                      medium: $progressMedium,
                                                      small: $progressSmall)
                                        .onTapGesture {
                                            withAnimation {
                                                self.progressBig = CGFloat.random(in: 0.0...3.5)
                                                self.progressMedium = CGFloat.random(in: 0.0...3.5)
                                                self.progressSmall = CGFloat.random(in: 0.0...2)
                                            }
                                        }
                                        .frame(width: 120, height: 200)
                                    }
                                }
                            }
                        }
                        .background(Color.gray)
                        .cornerRadius(8)
                        .shadow(color: Color.gray, radius: 4, x: 0, y: 4)
                        .transition(AnyTransition.slide)
                    
                } // forEach end
                VStack {
                    Text("가족 추가하기")
                }
            }
        }
    }
}

struct Card: Decodable, Hashable, Identifiable {
    var id: Int
    var name: String = ""
}

public class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 0.0
}

struct Carousel<Items : View> : View {
    let items: Items
    let numberOfItems: CGFloat
    let spacing: CGFloat
    let widthOfHiddenCards: CGFloat
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false
    
    @EnvironmentObject var UIState: UIStateModel
        
    @inlinable public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        @ViewBuilder _ items: () -> Items) {
        
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2)
        
    }
    
    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing

        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1)

        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }
        
        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.UIState.screenDrag = Float(currentState.translation.width)
            
        }.onEnded { value in
            self.UIState.screenDrag = 0
            
            if (value.translation.width < -50) &&  self.UIState.activeCard < Int(numberOfItems) - 1 {
                self.UIState.activeCard = self.UIState.activeCard + 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            
            if (value.translation.width > 50) && self.UIState.activeCard > 0 {
                self.UIState.activeCard = self.UIState.activeCard - 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
    }
}

struct Canvas<Content : View> : View {
    let content: Content
    @EnvironmentObject var UIState: UIStateModel
    
    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
//            .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Item<Content: View>: View {
    @EnvironmentObject var UIState: UIStateModel
    let cardWidth: CGFloat
    let cardHeight: CGFloat

    var _id: Int
    var content: Content

    @inlinable public init(
        _id: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2)
        self.cardHeight = cardHeight
        self._id = _id
    }

    var body: some View {
        content
            .frame(width: cardWidth, height: _id == UIState.activeCard ? cardHeight : cardHeight - 60, alignment: .center)
    }
}

