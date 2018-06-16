//
//  ViewController.swift
//  hackinsampa
//
//  Created by Carlos Doki on 15/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    
    fileprivate func setupLabels() {
//        titleLabel.backgroundColor = .red
//        bodyLabel.backgroundColor = .green
        titleLabel.numberOfLines = 0
        titleLabel.text = "Welcome to Company XYZ"
        titleLabel.font = UIFont(name: "Futura", size: 34)
        bodyLabel.numberOfLines = 0
        bodyLabel.text = "Hello there! thansk for this. blalablabla blablab lablbalb albalba lbalablablablab bablalabl ab abalba ballb albal aalbal abalbaala all lalala."
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        // darker text label in the back
        let darkTextLabel = UILabel()
        darkTextLabel.text = "Shimmer"
        darkTextLabel.textColor = UIColor(white: 1, alpha: 0.2)
        darkTextLabel.font = UIFont.systemFont(ofSize: 80)
        darkTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        darkTextLabel.textAlignment = .center
        
        let shinyTextLabel = UILabel()
        shinyTextLabel.text = "Shimmer"
        shinyTextLabel.textColor = .white
        shinyTextLabel.font = UIFont.systemFont(ofSize: 80)
        shinyTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        shinyTextLabel.textAlignment = .center
        
        view.addSubview(shinyTextLabel)
        
        // pretty easy if you know the code to draw a gradient
        let gradientLayer = CAGradientLayer()
        // if you are following along, make sure to use cgColor
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = shinyTextLabel.frame
        
        let angle = 45 * CGFloat.pi / 180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        shinyTextLabel.layer.mask = gradientLayer
        
        //animation
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.fromValue = -view.frame.width
        animation.toValue = view.frame.width
        animation.repeatCount = Float.infinity
        
        gradientLayer.add(animation, forKey: "doesn'tmatterJustSomeKey")
        
        //        view.layer.addSublayer(gradientLayer)
        
        setupLabels()
        setupStackView()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAnimations)))
    }

    @objc fileprivate func handleTapAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
                self.titleLabel.alpha = 0
                self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -150)
            })
        }
    }
}

