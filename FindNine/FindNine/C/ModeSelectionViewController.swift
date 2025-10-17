//
//  ModeSelectionViewController.swift
//  FindNine
//
//  Created by Zhao on 2025/10/16.
//

import UIKit

class ModeSelectionViewController: UIViewController {

    private var nineBeiJingImageView: UIImageView!
    private var nineMengCengView: UIView!
    private var nineTitleLabel: UILabel!
    private var nineBackButton: UIButton!
    private var nineTimedModeButton: UIButton!
    private var nineEndlessModeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        findSetupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func findSetupUI() {
        // Background image
        nineBeiJingImageView = UIImageView(frame: view.bounds)
        nineBeiJingImageView.image = UIImage(named: "ninePhoto")
        nineBeiJingImageView.contentMode = .scaleAspectFill
        view.addSubview(nineBeiJingImageView)

        // Overlay view with padding
        nineMengCengView = UIView()
        nineMengCengView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        nineMengCengView.layer.cornerRadius = 20
        view.addSubview(nineMengCengView)

        // Title label
        nineTitleLabel = UILabel()
        nineTitleLabel.text = "Select Game Mode"
        nineTitleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        nineTitleLabel.textColor = .white
        nineTitleLabel.textAlignment = .center
        nineTitleLabel.numberOfLines = 0
        nineTitleLabel.layer.shadowColor = UIColor.black.cgColor
        nineTitleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        nineTitleLabel.layer.shadowOpacity = 0.8
        nineTitleLabel.layer.shadowRadius = 4
        view.addSubview(nineTitleLabel)

        // Back button
        nineBackButton = findCreateStyledButton(nineTitle: "←", nineColor: UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.9))
        nineBackButton.addTarget(self, action: #selector(findBackAction), for: .touchUpInside)
        view.addSubview(nineBackButton)

        // Timed Mode button
        nineTimedModeButton = findCreateModeButton(nineMode: .timed)
        nineTimedModeButton.addTarget(self, action: #selector(findTimedModeAction), for: .touchUpInside)
        view.addSubview(nineTimedModeButton)

        // Endless Mode button
        nineEndlessModeButton = findCreateModeButton(nineMode: .endless)
        nineEndlessModeButton.addTarget(self, action: #selector(findEndlessModeAction), for: .touchUpInside)
        view.addSubview(nineEndlessModeButton)

        findSetupConstraints()
        findAddShadowToButton(nineButton: nineTimedModeButton)
        findAddShadowToButton(nineButton: nineEndlessModeButton)
        findAddGradientToButtons()
        findAddAnimations()
    }

    private func findCreateStyledButton(nineTitle: String, nineColor: UIColor) -> UIButton {
        let nineButton = UIButton(type: .system)
        nineButton.setTitle(nineTitle, for: .normal)
        nineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nineButton.setTitleColor(.white, for: .normal)
        nineButton.backgroundColor = nineColor
        nineButton.layer.cornerRadius = 12
        nineButton.layer.shadowColor = UIColor.black.cgColor
        nineButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nineButton.layer.shadowOpacity = 0.3
        nineButton.layer.shadowRadius = 3
        return nineButton
    }

    private func findCreateModeButton(nineMode: GameMode) -> UIButton {
        let nineButton = UIButton(type: .system)
        nineButton.backgroundColor = .clear
        nineButton.layer.cornerRadius = 15
        nineButton.clipsToBounds = true

        // Create container view
        let nineContainerView = UIView()
        nineContainerView.isUserInteractionEnabled = false
        nineButton.addSubview(nineContainerView)

        // Title label
        let nineTitleLabel = UILabel()
        nineTitleLabel.text = nineMode.displayName()
        nineTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nineTitleLabel.textColor = .white
        nineTitleLabel.textAlignment = .center
        nineContainerView.addSubview(nineTitleLabel)

        // Description label
        let nineDescLabel = UILabel()
        nineDescLabel.text = nineMode.description()
        nineDescLabel.font = UIFont.systemFont(ofSize: 16)
        nineDescLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        nineDescLabel.textAlignment = .center
        nineDescLabel.numberOfLines = 0
        nineContainerView.addSubview(nineDescLabel)

        nineContainerView.translatesAutoresizingMaskIntoConstraints = false
        nineTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nineDescLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nineContainerView.centerXAnchor.constraint(equalTo: nineButton.centerXAnchor),
            nineContainerView.centerYAnchor.constraint(equalTo: nineButton.centerYAnchor),
            nineContainerView.leadingAnchor.constraint(equalTo: nineButton.leadingAnchor, constant: 20),
            nineContainerView.trailingAnchor.constraint(equalTo: nineButton.trailingAnchor, constant: -20),

            nineTitleLabel.topAnchor.constraint(equalTo: nineContainerView.topAnchor),
            nineTitleLabel.leadingAnchor.constraint(equalTo: nineContainerView.leadingAnchor),
            nineTitleLabel.trailingAnchor.constraint(equalTo: nineContainerView.trailingAnchor),

            nineDescLabel.topAnchor.constraint(equalTo: nineTitleLabel.bottomAnchor, constant: 8),
            nineDescLabel.leadingAnchor.constraint(equalTo: nineContainerView.leadingAnchor),
            nineDescLabel.trailingAnchor.constraint(equalTo: nineContainerView.trailingAnchor),
            nineDescLabel.bottomAnchor.constraint(equalTo: nineContainerView.bottomAnchor)
        ])

        return nineButton
    }

    private func findAddShadowToButton(nineButton: UIButton) {
        let nineShadowView = UIView()
        nineShadowView.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.9, alpha: 1.0)
        nineShadowView.layer.shadowColor = UIColor.black.cgColor
        nineShadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        nineShadowView.layer.shadowOpacity = 0.4
        nineShadowView.layer.shadowRadius = 6
        nineShadowView.layer.cornerRadius = 15
        nineShadowView.isUserInteractionEnabled = false

        view.insertSubview(nineShadowView, belowSubview: nineButton)
        nineShadowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nineShadowView.topAnchor.constraint(equalTo: nineButton.topAnchor),
            nineShadowView.leadingAnchor.constraint(equalTo: nineButton.leadingAnchor),
            nineShadowView.trailingAnchor.constraint(equalTo: nineButton.trailingAnchor),
            nineShadowView.bottomAnchor.constraint(equalTo: nineButton.bottomAnchor)
        ])
    }

    private func findAddGradientToButtons() {
        let nineButtons = [nineTimedModeButton, nineEndlessModeButton]

        for (index, nineButton) in nineButtons.enumerated() {
            guard let nineBtn = nineButton else { continue }

            nineBtn.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

            let nineGradientLayer = CAGradientLayer()
            nineGradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 120)

            if index == 0 {
                // Timed mode - blue/purple gradient
                nineGradientLayer.colors = [
                    UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0).cgColor,
                    UIColor(red: 0.6, green: 0.3, blue: 0.9, alpha: 1.0).cgColor
                ]
            } else {
                // Endless mode - orange/red gradient
                nineGradientLayer.colors = [
                    UIColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 1.0).cgColor,
                    UIColor(red: 0.9, green: 0.2, blue: 0.3, alpha: 1.0).cgColor
                ]
            }

            nineGradientLayer.startPoint = CGPoint(x: 0, y: 0)
            nineGradientLayer.endPoint = CGPoint(x: 1, y: 1)
            nineGradientLayer.cornerRadius = 15

            nineBtn.layer.insertSublayer(nineGradientLayer, at: 0)
        }
    }

    private func findSetupConstraints() {
        nineMengCengView.translatesAutoresizingMaskIntoConstraints = false
        nineTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nineBackButton.translatesAutoresizingMaskIntoConstraints = false
        nineTimedModeButton.translatesAutoresizingMaskIntoConstraints = false
        nineEndlessModeButton.translatesAutoresizingMaskIntoConstraints = false

        let ninePadding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 30

        NSLayoutConstraint.activate([
            nineMengCengView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ninePadding),
            nineMengCengView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ninePadding),
            nineMengCengView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ninePadding),
            nineMengCengView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ninePadding),

            nineBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ninePadding + 10),
            nineBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ninePadding + 10),
            nineBackButton.widthAnchor.constraint(equalToConstant: 60),
            nineBackButton.heightAnchor.constraint(equalToConstant: 44),

            nineTitleLabel.topAnchor.constraint(equalTo: nineBackButton.bottomAnchor, constant: 20),
            nineTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nineTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            nineTimedModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineTimedModeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            nineTimedModeButton.widthAnchor.constraint(equalToConstant: 300),
            nineTimedModeButton.heightAnchor.constraint(equalToConstant: 120),

            nineEndlessModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineEndlessModeButton.topAnchor.constraint(equalTo: nineTimedModeButton.bottomAnchor, constant: 30),
            nineEndlessModeButton.widthAnchor.constraint(equalToConstant: 300),
            nineEndlessModeButton.heightAnchor.constraint(equalToConstant: 120),
        ])
    }

    private func findAddAnimations() {
        nineTimedModeButton.alpha = 0
        nineEndlessModeButton.alpha = 0
        nineTimedModeButton.transform = CGAffineTransform(translationX: -300, y: 0)
        nineEndlessModeButton.transform = CGAffineTransform(translationX: 300, y: 0)

        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
            self.nineTimedModeButton.alpha = 1
            self.nineTimedModeButton.transform = .identity
        }

        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
            self.nineEndlessModeButton.alpha = 1
            self.nineEndlessModeButton.transform = .identity
        }
    }

    @objc private func findBackAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func findTimedModeAction() {
        findAnimateButton(nineButton: nineTimedModeButton)
        let nineVC = YouxiViewController(nineGameMode: .timed)
        navigationController?.pushViewController(nineVC, animated: true)
    }

    @objc private func findEndlessModeAction() {
        findAnimateButton(nineButton: nineEndlessModeButton)
        let nineVC = YouxiViewController(nineGameMode: .endless)
        navigationController?.pushViewController(nineVC, animated: true)
    }

    private func findAnimateButton(nineButton: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            nineButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                nineButton.transform = .identity
            }
        }
    }
}
