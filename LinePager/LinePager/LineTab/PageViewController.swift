//
//  PagerViewController.swift
//  SOL
//
//  Created by 60156672 on 2022/04/25.
//

import UIKit
import FlexLayout
import PinLayout

class PagerViewController: UIViewController {
    private let rootContainer = UIView().then { $0.backgroundColor = .white }
    private let lineTabView: LinePagerTab
    private lazy var swipeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.isPagingEnabled = true
        $0.decelerationRate = .normal
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "swipeControl")
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let tabHeight: CGFloat
    private let viewControllers: [UIViewController]
    private let numberOfItems: Int
    
    init(
        title: [String],
        viewControllers: [UIViewController],
        height: CGFloat
    ) {
        self.lineTabView = LinePagerTab(items: title, tabHeight: height)
        self.tabHeight = height
        self.viewControllers = viewControllers
        self.numberOfItems = title.count
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(rootContainer)
        
        swipeCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        
        lineTabView.delegate = self
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootContainer.pin.all(view.pin.safeArea)
        rootContainer.flex.layout()
    }
    
    private func configureUI() {
        rootContainer.flex
            .justifyContent(.spaceBetween)
            .define {
                $0.addItem(lineTabView).height(tabHeight)
                $0.addItem(swipeCollectionView).grow(1)
            }
    }
    
    private func addCollectionViewChild(view: UIViewController, contentView: UIView) {
        addChild(view)
        contentView.addSubview(view.view)
        view.willMove(toParent: self)
        view.didMove(toParent: self)
    }
}


extension PagerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "swipeControl", for: indexPath)
        
                addCollectionViewChild(view: viewControllers[indexPath.row], contentView: cell.contentView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = IndexPath(row: Int(scrollView.contentOffset.x) / Int(scrollView.frame.width), section: 0)
        
        lineTabView.tabCollectionView.selectItem(at: index, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let numOfItemsRect = CGFloat(numberOfItems)
        let currentScroll = scrollView.contentOffset.x/numOfItemsRect //?????? scroll
        let currentIndexPath = IndexPath(row: Int(scrollView.contentOffset.x) / Int(scrollView.frame.width), section: 0) //?????? scroll??? ?????? indexPath ??????
        let indicatorWidth = lineTabView.widthOfTabTitles[currentIndexPath.row] + 24 //indicator??? ?????? ??????
        var distance = lineTabView.widthOfTabTitles[currentIndexPath.row] //???????????? ??? ??????
        let percent = ((currentScroll - (CGFloat(currentIndexPath.row) * swipeCollectionView.frame.width/numOfItemsRect)) / (swipeCollectionView.frame.width/numOfItemsRect) * 100).rounded() //???????????? ?????????(??? row ??? 100%??? ??????)
        
        // ?????? ?????? indexPath + 1??? ?????? ?????? ???????????? ?????? indicator ?????? - ?????? indicator ?????? = ?????????????????? ??????
        if currentIndexPath.row + 1 != lineTabView.widthOfTabTitles.count {
            distance = lineTabView.widthOfTabTitles[currentIndexPath.row + 1] - lineTabView.widthOfTabTitles[currentIndexPath.row]
        }
        
        let ratioWidth = distance * percent * 0.01 //???????????? ??? ?????? * ???????????? ????????? * ????????? = ???????????? ???????????? ?????? ???????????? ??? ??? ?????????
        let resultWidth = indicatorWidth + ratioWidth //?????? indicaotr??? ???????????? ratioWidth ????????????
        
        lineTabView.indicatorBar.flex.marginLeft(scrollView.contentOffset.x/CGFloat(numberOfItems)).markDirty()
        lineTabView.indicatorBar.indicator.flex.width(resultWidth).markDirty()
        
        lineTabView.setNeedsLayout()
    }
}

extension PagerViewController: LineTabDelegate {
    func scrollToSwipe(indexPath: IndexPath) {
        swipeCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
