//
//  ViewController.swift
//  VPN APP UI
//
//  Created by Khushali Vagadia on 17/03/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    // Button for initiating the connection process
    private let connectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 50
        button.clipsToBounds = false // Ensure the shadow remains visible
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add shadow for a glowing effect
        button.layer.shadowColor = UIColor.purple.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 10
        
        return button
    }()
    
    // Icon displayed inside the button
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "wifi") // System image representing connectivity
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Label indicating the connection action
    private let connectLabel: UILabel = {
        let label = UILabel()
        label.text = "CONNECT"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Gradient background layer
    private let backgroundLayer = CAGradientLayer()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
    }
    
    // MARK: - Gradient Background
    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.95, green: 0.9, blue: 1.0, alpha: 1.0).cgColor, // Light purple shade
            UIColor(red: 0.85, green: 0.8, blue: 1.0, alpha: 1.0).cgColor  // Slightly darker purple
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0) // Add gradient as background
    }
    
    // MARK: - Setup UI Elements
    private func setupUI() {
        view.addSubview(connectButton) // Add button to view
        connectButton.addSubview(iconImageView) // Add icon inside button
        view.addSubview(connectLabel) // Add label below button
        
        // Apply gradient effect to the button
        backgroundLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        backgroundLayer.startPoint = CGPoint(x: 0.3, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 0.7, y: 1)
        backgroundLayer.cornerRadius = 50
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        connectButton.layer.insertSublayer(backgroundLayer, at: 0)
        
        // MARK: - Constraints for UI Elements
        NSLayoutConstraint.activate([
            // Position button in the center of the screen
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            connectButton.widthAnchor.constraint(equalToConstant: 100),
            connectButton.heightAnchor.constraint(equalToConstant: 100),
            
            // Position icon inside the button
            iconImageView.centerXAnchor.constraint(equalTo: connectButton.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: connectButton.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Position label below the button
            connectLabel.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 10),
            connectLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // MARK: - Button Tap Action
        connectButton.addTarget(self, action: #selector(connectTapped), for: .touchUpInside)
    }
    
    // MARK: - Connect Button Action
    @objc private func connectTapped() {
        animateButtonPress() // Add tap animation effect
        
        // Delayed transition to Connecting screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let connectingVC = ConnectingViewController()
            connectingVC.modalPresentationStyle = .fullScreen
            self.present(connectingVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Button Press Animation
    private func animateButtonPress() {
        UIView.animate(withDuration: 0.1, animations: {
            self.connectButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) // Slight shrink
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.connectButton.transform = .identity // Restore to normal size
            }
        }
    }
}

