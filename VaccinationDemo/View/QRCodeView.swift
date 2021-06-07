//
//  QRCodeView.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/4.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class QRCodeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(effectView)
        effectView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview().offset(VerticalPixel(-50))
            maker.left.equalToSuperview().offset(HorizontalPixel(17))
            maker.right.equalToSuperview().offset(HorizontalPixel(-17))
        }
        
        addSubview(saveButton)
        saveButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.bottom).offset(VerticalPixel(35))
            maker.centerX.equalToSuperview()
            maker.height.equalTo(saveButton.height)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc private func effectViewTapHandler() {
        self.dismiss()
        
        self.cancelBlock?()
    }
    
    @objc private func saveButtonTapHandler() {
        guard let image = imageView.image else { return }
        
        HSPhotosManager.requestAccessPhotoLibrary(isAlert: true) { (auth) in
            if auth {
                HSPhotosManager.saveImage(image) { (ret) in
                    self.dismiss()
                    
                    self.didSaveBlock?()
                }
            }
        }
    }
    
    
    
    func show(on view: UIView? = nil) {
        if let spv = view ?? KeyWindow {
            spv.addSubview(self)
            self.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
        }
    }
    
    func dismiss() {
        if superview != nil {
            removeFromSuperview()
            self.snp.removeConstraints()
        }
    }
    
    func generateQRCode(value: String) {
        if let filter = CIFilter.init(name: "CIQRCodeGenerator") {
            filter.setDefaults()
            
            let data = value.data(using: .utf8)
            filter.setValue(data, forKey: "inputMessage")
            //filter.setValue("M", forKey: "inputCorrectionLevel")
            
            if let outputImage = filter.outputImage {
                imageView.image = createNonInterpolatedUIImageFromCIImage(outputImage, size: 500)
            }
        }
    }
    
    private func createNonInterpolatedUIImageFromCIImage(_ ciImage: CIImage, size: CGFloat) -> UIImage? {
        let extent = ciImage.extent.integral
        let scale = CGFloat.minimum(size / extent.width, size / extent.height)
        
        let width = Int(extent.width * scale)
        let height = Int(extent.height * scale)
        
        let cs = CGColorSpaceCreateDeviceGray()
        guard let cgContext = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return nil }
        
        let ciContext = CIContext.init(options: nil)
        guard let bitmapImage = ciContext.createCGImage(ciImage, from: extent) else { return nil }
        
        cgContext.interpolationQuality = CGInterpolationQuality.none
        cgContext.scaleBy(x: scale, y: scale)
        cgContext.draw(bitmapImage, in: extent)
        
        if let scaledImage = cgContext.makeImage() {
            return UIImage(cgImage: scaledImage)
        }
        
        return nil
    }
    
    
    
    var didSaveBlock: (() -> Void)?
    
    var cancelBlock: (() -> Void)?
    
    private lazy var effectView: UIVisualEffectView = {
        let effect = UIBlurEffect.init(style: .light)
        let ev = UIVisualEffectView.init(effect: effect)
        ev.alpha = 0.8
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(effectViewTapHandler))
        ev.addGestureRecognizer(tap)
        
        return ev
    }()
    
    private lazy var contentView: UIView = {
        let v = UIView()
        
        let cornerRadius: CGFloat = 10
        
        var shadow = HSShadow()
        shadow.color = UIColor.init(white: 0, alpha: 0.1)
        shadow.opacity = 1
        shadow.offset = CGSize(width: 4, height: 4)
        shadow.radius = cornerRadius
        shadow.cornerRadius = cornerRadius
        v.hs_setupShadow(shadow)
        
        let cv = UIView()
        cv.layer.cornerRadius = cornerRadius
        cv.backgroundColor = UIColor(hex: 0x03d9c5)
        v.addSubview(cv)
        cv.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        cv.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(VerticalPixel(15))
        }
        
        cv.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(VerticalPixel(15))
            maker.left.equalToSuperview().offset(HorizontalPixel(25))
            maker.right.equalToSuperview().offset(HorizontalPixel(-25))
            maker.height.equalTo(imageView.snp.width)
        }
        
        cv.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(VerticalPixel(25))
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(VerticalPixel(-30))
        }
        
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.hs_systemFont(size: 28, isBold: true)
        lbl.textColor = .white
        lbl.text = "e-Health Certificate"
        return lbl
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private(set) lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.hs_systemFont(size: 26, isBold: true)
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var saveButton: UIView = {
        let height = VerticalPixel(60)
        let btn = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        
        var shadow = HSShadow()
        shadow.color = UIColor.init(white: 0, alpha: 0.2)
        shadow.opacity = 1
        shadow.offset = CGSize(width: 0, height: 7)
        shadow.radius = 7
        shadow.cornerRadius = height / 2
        btn.hs_setupShadow(shadow)
        
        let cv = UIView()
        cv.layer.cornerRadius = height / 2
        cv.backgroundColor = UIColor(hex: 0xfca427)
        btn.addSubview(cv)
        cv.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        let lbl = UILabel()
        lbl.font = UIFont.hs_systemFont(size: 22, isBold: true)
        lbl.textColor = .white
        lbl.text = "SAVE MY QR CODE"
        cv.addSubview(lbl)
        lbl.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.left.equalToSuperview().offset(HorizontalPixel(50))
            maker.right.equalToSuperview().offset(HorizontalPixel(-50))
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapHandler))
        cv.addGestureRecognizer(tap)
        
        return btn
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
