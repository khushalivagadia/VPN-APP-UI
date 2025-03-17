//
//  SuccessViewController.swift
//  VPN APP UI
//
//  Created by Khushali Vagadia on 17/03/25.
//

import UIKit

class SuccessViewController: UIViewController {
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Connected Successfully!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.alpha = 0  // For smooth fade-in animation
        return label
    }()
    
    private let buttonContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        return view
    }()
    
    private let disconnectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DISCONNECT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(disconnectTapped), for: .touchUpInside)
        return button
    }()
    
    private let buttonBackgroundLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
        animateIntro()
    }
    
    // MARK: - Background Setup
    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemGreen.cgColor, UIColor.systemBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statusLabel)
        view.addSubview(buttonContainerView)
        buttonContainerView.addSubview(disconnectButton)
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            
            buttonContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonContainerView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            buttonContainerView.widthAnchor.constraint(equalToConstant: 160),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            disconnectButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            disconnectButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            disconnectButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            disconnectButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        setupButtonBackground()
    }
    
    // MARK: - Button Styling
    private func setupButtonBackground() {
        buttonBackgroundLayer.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemOrange.cgColor
        ]
        buttonBackgroundLayer.startPoint = CGPoint(x: 0, y: 0.5)
        buttonBackgroundLayer.endPoint = CGPoint(x: 1, y: 0.5)
        buttonBackgroundLayer.frame = CGRect(x: 0, y: 0, width: 160, height: 44)
        buttonBackgroundLayer.cornerRadius = 22
        
        disconnectButton.layer.insertSublayer(buttonBackgroundLayer, at: 0)
        
        animateButtonGradient()
    }
    
    // MARK: - Button Gradient Animation
    private func animateButtonGradient() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [UIColor.systemRed.cgColor, UIColor.systemOrange.cgColor]
        animation.toValue = [UIColor.systemPink.cgColor, UIColor.systemYellow.cgColor]
        animation.duration = 2.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        buttonBackgroundLayer.add(animation, forKey: "gradientAnimation")
    }
    
    // MARK: - Intro Animation
    private func animateIntro() {
        UIView.animate(withDuration: 1.2, delay: 0, options: .curveEaseInOut) {
            self.statusLabel.alpha = 1.0
            self.statusLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.statusLabel.transform = .identity
            }
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseOut) {
            self.buttonContainerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.buttonContainerView.transform = .identity
            }
        }
    }
    
    // MARK: - Disconnect Button Action
    @objc private func disconnectTapped() {
        triggerHapticFeedback()
        
        // Pulsating Effect
        UIView.animate(withDuration: 0.1,
                       animations: { self.disconnectButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.disconnectButton.transform = .identity
            }
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0
        }) { _ in
            self.navigateToHomeScreen() // Navigate to Home Screen
        }
    }
    
    private func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // MARK: - Navigation to Home
    private func navigateToHomeScreen() {
        DispatchQueue.main.async {
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = homeVC
                window.makeKeyAndVisible()
            }
        }
    }
}
