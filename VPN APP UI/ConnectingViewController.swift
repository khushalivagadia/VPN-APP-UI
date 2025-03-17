//
//  ConnectingViewController.swift
//  VPN APP UI
//
//  Created by Khushali Vagadia on 17/03/25.
//

import UIKit

class ConnectingViewController: UIViewController {
    
    // Background gradient layer
    private let gradientLayer = CAGradientLayer()
    
    // Circular progress indicator layer
    private let progressCircle = CAShapeLayer()
    
    // Status label to indicate connection progress
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Connecting..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.alpha = 0  // Starts invisible for fade-in animation
        return label
    }()
    
    // Container for the circular progress indicator
    private let progressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup background gradient animation
        setupBackground()
        
        // Setup UI elements including labels and progress circle
        setupUI()
        
        // Start loading animation for connection progress
        startLoading()
        
        // Fade-in animation for status label
        animateIntro()
    }
    
    // MARK: - Background Setup
    private func setupBackground() {
        gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Animate gradient for dynamic effect
        animateGradient()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Disable autoresizing mask translation for manual layout
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statusLabel)
        view.addSubview(progressContainer)
        
        // Constraints for status label and progress container
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            progressContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressContainer.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30),
            progressContainer.widthAnchor.constraint(equalToConstant: 120),
            progressContainer.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        setupProgressCircle()
    }
    
    // MARK: - Circular Progress Indicator Setup
    private func setupProgressCircle() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60), radius: 50, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        progressCircle.path = circularPath.cgPath
        progressCircle.strokeColor = UIColor.white.cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = 6
        progressCircle.lineCap = .round
        progressCircle.strokeEnd = 0  // Initially set to 0 for animation effect
        
        // Adding glow effect for visual enhancement
        progressCircle.shadowColor = UIColor.white.cgColor
        progressCircle.shadowRadius = 5
        progressCircle.shadowOpacity = 0.8
        progressCircle.shadowOffset = .zero
        
        progressContainer.layer.addSublayer(progressCircle)
    }
    
    // MARK: - Background Gradient Animation
    private func animateGradient() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 3.0
        animation.toValue = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        animation.autoreverses = true
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "colorChange")
    }
    
    // MARK: - Status Label Animation
    private func animateIntro() {
        UIView.animate(withDuration: 1.2, delay: 0, options: .curveEaseInOut) {
            self.statusLabel.alpha = 1.0
            self.statusLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.statusLabel.transform = .identity
            }
        }
    }
    
    // MARK: - Start Loading Animation
    private func startLoading() {
        var progress: Float = 0.0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            progress += 0.1
            self.triggerHapticFeedback(progress)
            self.updateCircleProgress(progress)
            
            if progress >= 1.0 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.transitionToSuccessScreen()
                }
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    // MARK: - Haptic Feedback Based on Progress
    private func triggerHapticFeedback(_ progress: Float) {
        let generator: UIImpactFeedbackGenerator
        switch progress {
        case 0.1...0.3:
            generator = UIImpactFeedbackGenerator(style: .light)
        case 0.4...0.7:
            generator = UIImpactFeedbackGenerator(style: .medium)
        default:
            generator = UIImpactFeedbackGenerator(style: .heavy)
        }
        generator.impactOccurred()
    }
    
    // MARK: - Update Circular Progress
    private func updateCircleProgress(_ progress: Float) {
        progressCircle.strokeEnd = CGFloat(progress)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = progress
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressCircle.add(animation, forKey: "progressAnim")
    }
    
    // MARK: - Transition to Success Screen
    private func transitionToSuccessScreen() {
        let successVC = SuccessViewController()
        successVC.modalTransitionStyle = .crossDissolve
        successVC.modalPresentationStyle = .fullScreen
        self.present(successVC, animated: true, completion: nil)
    }
}

