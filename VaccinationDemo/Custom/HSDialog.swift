//
//  HSDialog.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/4.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class HSDialogAction {
    var title: String
    
    var action: (() -> Void)?
    
    var titleColor: UIColor = UIColor(hex: 0x007aff)
    
    var titleFont: UIFont = UIFont.hs_systemFont(size: 17, isBold: true)
    
    var height: CGFloat = 44
    
    init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }
}

class HSDialogActionCell: UIView {
    private(set) var index: Int = 0
    
    var action: ((_ index: Int) -> Void)?
    
    init(index: Int) {
        super.init(frame: CGRect.zero)
        
        self.index = index
        
        addSubview(line)
        line.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.height.equalTo(0.5)
        }
        
        addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTouchUp() {
        action?(index)
    }
    
    private(set) lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(buttonTouchUp), for: .touchUpInside)
        return btn
    }()
    
    private lazy var line: UIView = {
        let l = UIView()
        l.backgroundColor = UIColor(hex: 0x3c3c43, alpha: 0.36)
        return l
    }()
}

class HSDialog: UIView {
    var message: String
    
    private(set) var actions = [HSDialogAction]()
    
    init(message: String) {
        self.message = message
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        if contentView.superview == nil {
            addSubview(effectView)
            effectView.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
            
            addSubview(contentView)
            contentView.snp.makeConstraints { (maker) in
                maker.centerY.equalToSuperview()
                maker.left.equalToSuperview().offset(HorizontalPixel(50))
                maker.right.equalToSuperview().offset(HorizontalPixel(-50))
            }
            
            contentView.addSubview(messageView)
            messageView.snp.makeConstraints { (maker) in
                maker.left.top.right.equalToSuperview()
            }
            
            contentView.addSubview(actionsView)
            actionsView.snp.makeConstraints { (maker) in
                maker.left.right.bottom.equalToSuperview()
                maker.top.equalTo(messageView.snp.bottom)
            }
        }
        
        messageLabel.text = message
        
        actionsView.subviews.forEach { (v) in
            v.removeFromSuperview()
        }
        
        var preCell: HSDialogActionCell?
        for i in 0..<actions.count {
            let act = actions[i]
            let cell = HSDialogActionCell(index: i)
            cell.button.titleLabel?.font = act.titleFont
            cell.button.setTitle(act.title, for: .normal)
            cell.button.setTitleColor(act.titleColor, for: .normal)
            cell.action = { [weak self] index in
                guard let `self` = self else { return }
                
                self.dismiss()
                
                guard self.actions.count > index else { return }
                
                self.actions[index].action?()
            }
            
            actionsView.addSubview(cell)
            cell.snp.makeConstraints { (maker) in
                maker.left.right.equalToSuperview()
                maker.height.equalTo(act.height)
                if preCell == nil {
                    maker.top.equalToSuperview()
                } else {
                    maker.top.equalTo(preCell!.snp.bottom)
                }
                
                if i == actions.count - 1 {
                    maker.bottom.equalToSuperview()
                }
            }
            
            preCell = cell
        }
    }
    
    func addAction(_ action: HSDialogAction) {
        actions.append(action)
    }
    
    func show(on view: UIView? = nil) {
        
        if superview != nil { return }
        if actions.count == 0 { return }
        guard let sv = view ?? KeyWindow else { return }
        setupUI()
        
        effectView.alpha = 0
        contentView.alpha = 0
        
        self.frame = sv.bounds
        sv.addSubview(self)
        
        if self.frame.width == 0 {
            self.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
        }
        
        contentView.transform = CGAffineTransform.init(scaleX: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude)

        UIView.animate(withDuration: 0.15, animations: {
            self.effectView.alpha = 0.85
            self.contentView.alpha = 1
            self.contentView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        }) { (finished) in
            self.contentView.transform = CGAffineTransform.identity
        }
    }
    
    func dismiss() {
        if superview != nil {
            removeFromSuperview()
        }
    }
    
    
    
    private lazy var effectView: UIVisualEffectView = {
        let effect = UIBlurEffect.init(style: .dark)
        let ev = UIVisualEffectView.init(effect: effect)
        ev.alpha = 0.8
        return ev
    }()
    
    private lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 14
        return v
    }()
    
    private lazy var messageView: UIView = {
        let v = UIView()
        
        v.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(20))
            maker.right.equalToSuperview().offset(HorizontalPixel(-20))
            maker.top.equalToSuperview().offset(VerticalPixel(20))
            maker.bottom.equalToSuperview().offset(VerticalPixel(-20))
        }
        
        return v
    }()
    
    private(set) lazy var messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.hs_systemFont(size: 17, isBold: true)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var actionsView: UIView = {
        let v = UIView()
        return v
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
