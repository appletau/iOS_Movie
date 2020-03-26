//
//  ScrollableTabView.swift
//  Moya+Rx
//
//  Created by Daniel on 2020/2/11.
//  Copyright © 2020 Daniel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ScrollableTabViewData {
    var title: String { get }
    var id: Int? { get }
}

struct ScrollableTabViewOption {
    enum TabIndicatorType {
        case bottomLine, cirlce
    }
    
    var marginPadding: CGFloat = 15
    var itemWidth: CGFloat = 50
    var itemSpace: CGFloat = 10
    var tabIndicatorWidth: CGFloat = 25
    var tabIndicatorHeight: CGFloat = 3
    var tabIndicatorBottomSpace: CGFloat = 0
    var tabIndicatorColor: UIColor = UIColor.c4917121
    var titleShouldTransformWhenSelected: Bool = true
    var titleTransformScale: CGFloat = 1.4
    var shouldChangeTitleColorWhenSelected: Bool = false
    var titleSelectedColor: UIColor = .black
    var titleUnSelectedColor: UIColor = .black
    var titleFontSize: CGFloat = 17
    var tabIndicatorType: TabIndicatorType = .bottomLine
}

class ScrollableTabView: UIView {
    
    //MARK:- Property
    let didTapItem = BehaviorRelay<ScrollableTabViewData?>(value: nil)
    
    private let disposeBag = DisposeBag()
    private var selectedIndex = -1
    private var collectionView: UICollectionView?
    private var tabIndicator: UIView?
    private var option: ScrollableTabViewOption = ScrollableTabViewOption() {
        didSet {
            self.resizeTabIndicator()
            self.reloadData(selectIndex: selectedIndex)
        }
    }
    
    private(set) var dataArray = BehaviorRelay<[ScrollableTabViewData]>(value: [])
    private var itemWidthDic: [Int:CGFloat] = [:]
    
    //MARK:- Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        configureTabIndicator()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCollectionView()
        configureTabIndicator()
        binding()
    }
    
    convenience init(frame: CGRect, option: ScrollableTabViewOption? = nil) {
        self.init(frame: frame)
        
        //initialize call didSet
        //https://stackoverflow.com/a/33979852/12394719
        defer { if let option = option { self.option = option } }
    }
    
    //MARK:- Public function
    func updateOption(_ option: ScrollableTabViewOption) {
        self.option = option
    }
    
    func updateDefualtSelect(_ data: ScrollableTabViewData) {
        let index = self.dataArray.value.enumerated().filter({ $0.element.id == data.id }).first.map({ $0.offset }) ?? 0
        self.reloadData(selectIndex: index)
    }
    
    //MARK:- Private function
    private func binding() {
        self.dataArray
            .currentAndPrevious()
            .subscribe(onNext: { [weak self] (currentData, previosData) in
                guard let self = self, let previosData = previosData else { return }
                self.updateItemWidthDic()
                
                let index = previosData.count > 0 ? currentData.enumerated().filter({ $0.element.id == previosData[self.selectedIndex].id }).first.map({ $0.offset }) ?? 0 : 0
                self.reloadData(selectIndex: index)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = option.itemSpace
        layout.sectionInset = UIEdgeInsets(top: 0, left: option.marginPadding, bottom: 0, right: option.marginPadding)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        collectionView.register(UINib(nibName: String(describing: ScrollableItemCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ScrollableItemCell.self))
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.layoutIfNeeded()
        self.collectionView = collectionView
    }
    
    private func configureTabIndicator() {
        guard let collectionView = self.collectionView else { return }
        
        var tabIndicator = UIView()
        
        switch option.tabIndicatorType {
        case .bottomLine:
            tabIndicator = UIView(frame: CGRect(x: 0, y: self.bounds.size.height - option.tabIndicatorHeight - option.tabIndicatorBottomSpace, width: option.tabIndicatorWidth, height: option.tabIndicatorHeight))
            tabIndicator.layer.cornerRadius = option.tabIndicatorHeight / 2
        case .cirlce:
            let diameter = (option.itemWidth < self.bounds.size.height ? option.itemWidth : self.bounds.size.height) - option.tabIndicatorBottomSpace * 2
            tabIndicator = UIView(frame: CGRect(x: option.tabIndicatorBottomSpace, y: option.tabIndicatorBottomSpace, width: diameter, height: diameter))
            tabIndicator.layer.cornerRadius = diameter / 2
        }
        
        collectionView.insertSubview(tabIndicator, at: 0)
        
        tabIndicator.backgroundColor = option.tabIndicatorColor
        self.tabIndicator = tabIndicator
    }
    
    private func resizeTabIndicator() {
        self.tabIndicator?.removeFromSuperview()
        self.tabIndicator = nil
        self.configureTabIndicator()
    }
    
    private func updateItemWidthDic() {
        for index in 0..<self.dataArray.value.count {
            switch option.tabIndicatorType {
            case .bottomLine:
                let text = self.dataArray.value[index].title
                let textWidth = text.width(font: UIFont.systemFont(ofSize: 17), height: self.bounds.size.height)
                let itemWidth = textWidth * option.titleTransformScale > option.itemWidth ? textWidth * option.titleTransformScale : option.itemWidth
                itemWidthDic[index] = itemWidth
            case .cirlce:
                itemWidthDic = [:]
            }
        }
    }
    
    private func reloadData(selectIndex: Int) {
        self.collectionView?.reloadData()
        self.collectionView?.selectItem(at: IndexPath(item: selectIndex, section: 0), animated: false, scrollPosition: [])
        self.collectionView(self.collectionView!, didSelectItemAt: IndexPath(item: selectIndex, section: 0))
        self.updateTabIndicatorPosition()
    }
    
    private func updateTabIndicatorPosition() {
        guard let tabIndicator = tabIndicator else { return }
        
        var frame = tabIndicator.frame
        
        switch option.tabIndicatorType {
        case .bottomLine:
            let startX = option.marginPadding
            let totalItemWitdh: CGFloat = itemWidthDic.filter({ $0.key < selectedIndex }).compactMap({ $0.value }).reduce(0, +)
            let halfWidth = ((itemWidthDic[selectedIndex] ?? option.itemWidth) -  option.tabIndicatorWidth) / 2
            let spaces = CGFloat(selectedIndex) * option.itemSpace
            let x = startX + totalItemWitdh + halfWidth + spaces
            frame.origin.x = x
        case .cirlce:
            let startX = option.marginPadding
            let totalItemWidth = CGFloat(selectedIndex) * (option.itemWidth - option.tabIndicatorBottomSpace * 2)
            let spaces = CGFloat(selectedIndex) * option.itemSpace + CGFloat(selectedIndex * 2 + 1) * option.tabIndicatorBottomSpace
            let x = startX + totalItemWidth + spaces
            frame.origin.x = x
        }
        
        self.collectionView?.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            tabIndicator.frame = frame
        })
    }
    
    private func updateTitle(in label: UILabel, selected: Bool, animation: Bool = true) {
        if option.titleShouldTransformWhenSelected {
            if animation {
                UIView.animate(withDuration: 0.3, animations: {
                    label.transform = selected ? CGAffineTransform(scaleX: self.option.titleTransformScale, y: self.option.titleTransformScale) : .identity
                })
            } else {
                label.transform = selected ? CGAffineTransform(scaleX: self.option.titleTransformScale, y: self.option.titleTransformScale) : .identity
            }
        }
        
        if option.shouldChangeTitleColorWhenSelected {
            label.textColor = selected ? option.titleSelectedColor : option.titleUnSelectedColor
        }
    }
}

extension ScrollableTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ScrollableItemCell.self), for: indexPath) as! ScrollableItemCell
        cell.titleLabel.text = dataArray.value[indexPath.item].title
        cell.titleLabel.font = UIFont.systemFont(ofSize: option.titleFontSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.bringSubviewToFront(cell)
        if let cell = cell as? ScrollableItemCell {
            updateTitle(in: cell.titleLabel, selected: selectedIndex == indexPath.item, animation: false)
        }
    }
}

extension ScrollableTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch option.tabIndicatorType {
        case .bottomLine:
            return CGSize(width: itemWidthDic[indexPath.item] ?? 0, height: self.bounds.size.height)
        case .cirlce:
            return CGSize(width: option.itemWidth, height: self.bounds.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row { return }
        selectedIndex = indexPath.item
        
        if indexPath.row < dataArray.value.count { didTapItem.accept(dataArray.value[indexPath.row]) }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ScrollableItemCell else { return }
        updateTabIndicatorPosition()
        updateTitle(in: cell.titleLabel, selected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ScrollableItemCell else { return }
        updateTitle(in: cell.titleLabel, selected: false)
    }
}
