//
//  LineTab.swift
//  SOL-Plugin
//
//  Created by 60156672 on 2022/04/22.
//

import UIKit
import Then
import FlexLayout
import PinLayout

/// 상단 탭바에서 아래 데이터 스와이프 하라는 이벤트 보내기
protocol LineTabDelegate: AnyObject {
    func scrollToSwipe(indexPath: IndexPath)
}
/// 상단 Paging Tabbar View
final class LinePagerTab: UIView {
    private let rootContainer = UIView()
    private (set) var tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.register(LineTabCollectionViewCell.self, forCellWithReuseIdentifier: "lineTabControl")
    }

    private (set) var indicatorBar = IndicatorBar()
    private (set) var numberOfItems: Int
    private (set) var widthOfTabTitles: [CGFloat] = []

    private var tabHeight: CGFloat
    private var tabTitles: [String]

    weak var delegate: LineTabDelegate?
    
    init(
        items: [String],
        tabHeight: CGFloat
    ) {
        self.numberOfItems = items.count
        self.tabTitles = items
        self.tabHeight = tabHeight
        
        super.init(frame: .zero)

        addSubview(rootContainer)
        
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        
        getWidthOfItems(items)
        configureUI()
        
        // indicator의 첫 row의 width를 가져오기 위한 코드
        indicatorBar.indicator.flex.width(widthOfTabTitles[0] + 24)
        tabCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootContainer.pin.top(pin.safeArea.top).left().right().height(tabHeight)
        rootContainer.flex.layout()
    }
    
    func configureUI() {
        rootContainer.flex
            .define {
                $0.addItem(tabCollectionView).height(tabHeight - 2)
                $0.addItem(indicatorBar).width(UIScreen.main.bounds.width/CGFloat(numberOfItems)).height(2)
            }
    }
    
    func getWidthOfItems(_ items: [String]) {
        items.forEach {
            widthOfTabTitles.append(
                $0.getWidthOfString(font: UIFont.systemFont(ofSize: 16)).rounded()
            )
        }
    }
}

extension LinePagerTab: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lineTabControl", for: indexPath) as? LineTabCollectionViewCell else { fatalError() }
        
        cell.titleLabel.text = tabTitles[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/CGFloat(numberOfItems), height: tabHeight - 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// didSelect시 아래의 독립적인 collectionView indexPath 넘기기
        delegate?.scrollToSwipe(indexPath: indexPath)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        /// 탭바 클릭시 바 이동 애니메이션 주기
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}
