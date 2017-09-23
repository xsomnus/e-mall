//
//  OrderPay1StyleTCell.swift
//  HLMarketV1.0
//
//  Created by 彭仁帅 on 2017/4/25.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

enum OrderPay1Type {
    case wallet,zfb,wx,czk
}

class OrderPay1StyleTCell: UITableViewCell {
    
    lazy var payStyleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var payStyleImageView: UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        return view
    }()
    
    
    var type: OrderPay1Type? {
        didSet{
            switch self.type! {
            case .wallet:
                payStyleImageView.image = #imageLiteral(resourceName: "hlm_wallet")
                priceLabel.alpha = 1.0
                grayView.alpha = 0.0
            case .zfb:
                payStyleImageView.image = #imageLiteral(resourceName: "hlm_zfb")
                priceLabel.alpha = 0.0
                grayView.alpha = 1.0
            case .wx:
                payStyleImageView.image = #imageLiteral(resourceName: "hlm_wx")
                priceLabel.alpha = 0.0
                grayView.alpha = 1.0
            case .czk:
                payStyleImageView.image = #imageLiteral(resourceName: "hlm_czk")
                priceLabel.alpha = 0.0
                grayView.alpha = 0.0
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(payStyleLabel)
        self.contentView.addSubview(payStyleImageView)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(grayView)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        payStyleImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(payStyleImageView.snp.height)
        }
        
        payStyleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(payStyleImageView.snp.right).offset(15)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        grayView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-0.5)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(1)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

