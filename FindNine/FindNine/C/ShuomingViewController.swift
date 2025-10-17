//
//  ShuomingViewController.swift
//  FindNine
//
//  Created by Zhao on 2025/10/14.
//

import UIKit

class ShuomingViewController: UIViewController {
    
    private var nineBeiJingImageView: UIImageView!
    private var nineMengCengView: UIView!
    private var nineTitleLabel: UILabel!
    private var nineBackButton: UIButton!
    private var nineScrollView: UIScrollView!
    private var nineContentView: UIView!
    private var nineSection1View: UIView!
    private var nineSection2View: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findSetupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func findSetupUI() {
        // Background
        nineBeiJingImageView = UIImageView(frame: view.bounds)
        nineBeiJingImageView.image = UIImage(named: "ninePhoto")
        nineBeiJingImageView.contentMode = .scaleAspectFill
        view.addSubview(nineBeiJingImageView)
        
        // Overlay
        nineMengCengView = UIView()
        nineMengCengView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        nineMengCengView.layer.cornerRadius = 20
        view.addSubview(nineMengCengView)
        
        // Title
        nineTitleLabel = UILabel()
        nineTitleLabel.text = "Overview​"
        nineTitleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        nineTitleLabel.textColor = .white
        nineTitleLabel.textAlignment = .center
        nineTitleLabel.layer.shadowColor = UIColor.black.cgColor
        nineTitleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        nineTitleLabel.layer.shadowOpacity = 0.8
        nineTitleLabel.layer.shadowRadius = 4
        view.addSubview(nineTitleLabel)
        
        // Back button
        nineBackButton = findCreateStyledButton(nineTitle: "←", nineColor: UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.9))
        nineBackButton.addTarget(self, action: #selector(findBackAction), for: .touchUpInside)
        view.addSubview(nineBackButton)
        
        // Scroll view
        nineScrollView = UIScrollView()
        nineScrollView.backgroundColor = .clear
        nineScrollView.showsVerticalScrollIndicator = true
        view.addSubview(nineScrollView)
        
        // Content view
        nineContentView = UIView()
        nineScrollView.addSubview(nineContentView)
        
        // Section 1 - Game Objective
        nineSection1View = findCreateSectionView(
            nineTitle: "Game Objective",
            nineContent: """
            Welcome to Mahjong - Find All Nums!
            
            • A random number (1-9) appears at the top of the screen
            
            • Your goal is to find and tap ALL mahjong tiles that match this number
            
            • Mahjong tiles come in different suits (Bamboo, Dots, Characters) but the same number
            
            • Complete each round by finding all matching tiles before time runs out!
            """
        )
        nineContentView.addSubview(nineSection1View)
        
        // Section 2 - Scoring & Rules
        nineSection2View = findCreateSectionView(
            nineTitle: "Scoring & Rules",
            nineContent: """
            Scoring System:
            • Correct tile: +1 point ✅
            • Wrong tile: -1 point ❌
            • Minimum score: 0 points
            
            Game Mechanics:
            • You have 60 seconds to score as many points as possible
            
            • When you find all matching tiles, the game automatically refreshes with a new number
            
            • Use the "Refresh" button at the bottom to manually start a new round
            
            • Your game record will be saved automatically when time runs out
            
            Tips:
            • Pay attention to the number value, not the suit
            • Work quickly but carefully
            • Already selected tiles will appear dimmed
            """
        )
        nineContentView.addSubview(nineSection2View)
        
        findSetupConstraints()
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
    
    private func findCreateSectionView(nineTitle: String, nineContent: String) -> UIView {
        let nineView = UIView()
        nineView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        nineView.layer.cornerRadius = 15
        nineView.layer.shadowColor = UIColor.black.cgColor
        nineView.layer.shadowOffset = CGSize(width: 0, height: 2)
        nineView.layer.shadowOpacity = 0.2
        nineView.layer.shadowRadius = 4
        
        let nineTitleLabel = UILabel()
        nineTitleLabel.text = nineTitle
        nineTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nineTitleLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        nineTitleLabel.numberOfLines = 0
        nineView.addSubview(nineTitleLabel)
        
        let nineContentLabel = UILabel()
        nineContentLabel.text = nineContent
        nineContentLabel.font = UIFont.systemFont(ofSize: 16)
        nineContentLabel.textColor = .darkGray
        nineContentLabel.numberOfLines = 0
        nineContentLabel.lineBreakMode = .byWordWrapping
        nineView.addSubview(nineContentLabel)
        
        nineTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nineContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nineTitleLabel.topAnchor.constraint(equalTo: nineView.topAnchor, constant: 20),
            nineTitleLabel.leadingAnchor.constraint(equalTo: nineView.leadingAnchor, constant: 20),
            nineTitleLabel.trailingAnchor.constraint(equalTo: nineView.trailingAnchor, constant: -20),
            
            nineContentLabel.topAnchor.constraint(equalTo: nineTitleLabel.bottomAnchor, constant: 15),
            nineContentLabel.leadingAnchor.constraint(equalTo: nineView.leadingAnchor, constant: 20),
            nineContentLabel.trailingAnchor.constraint(equalTo: nineView.trailingAnchor, constant: -20),
            nineContentLabel.bottomAnchor.constraint(equalTo: nineView.bottomAnchor, constant: -20),
        ])
        
        return nineView
    }
    
    private func findSetupConstraints() {
        nineMengCengView.translatesAutoresizingMaskIntoConstraints = false
        nineTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nineBackButton.translatesAutoresizingMaskIntoConstraints = false
        nineScrollView.translatesAutoresizingMaskIntoConstraints = false
        nineContentView.translatesAutoresizingMaskIntoConstraints = false
        nineSection1View.translatesAutoresizingMaskIntoConstraints = false
        nineSection2View.translatesAutoresizingMaskIntoConstraints = false
        
        let ninePadding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20
        
        NSLayoutConstraint.activate([
            nineMengCengView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ninePadding),
            nineMengCengView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ninePadding),
            nineMengCengView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ninePadding),
            nineMengCengView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ninePadding),
            
            nineBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ninePadding + 10),
            nineBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ninePadding + 10),
            nineBackButton.widthAnchor.constraint(equalToConstant: 60),
            nineBackButton.heightAnchor.constraint(equalToConstant: 44),
            
            nineTitleLabel.topAnchor.constraint(equalTo: nineBackButton.bottomAnchor, constant: 10),
            nineTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nineTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            nineScrollView.topAnchor.constraint(equalTo: nineTitleLabel.bottomAnchor, constant: 20),
            nineScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ninePadding + 10),
            nineScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ninePadding - 10),
            nineScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ninePadding - 10),
            
            nineContentView.topAnchor.constraint(equalTo: nineScrollView.topAnchor),
            nineContentView.leadingAnchor.constraint(equalTo: nineScrollView.leadingAnchor),
            nineContentView.trailingAnchor.constraint(equalTo: nineScrollView.trailingAnchor),
            nineContentView.bottomAnchor.constraint(equalTo: nineScrollView.bottomAnchor),
            nineContentView.widthAnchor.constraint(equalTo: nineScrollView.widthAnchor),
            
            nineSection1View.topAnchor.constraint(equalTo: nineContentView.topAnchor, constant: 10),
            nineSection1View.leadingAnchor.constraint(equalTo: nineContentView.leadingAnchor, constant: 5),
            nineSection1View.trailingAnchor.constraint(equalTo: nineContentView.trailingAnchor, constant: -5),
            
            nineSection2View.topAnchor.constraint(equalTo: nineSection1View.bottomAnchor, constant: 20),
            nineSection2View.leadingAnchor.constraint(equalTo: nineContentView.leadingAnchor, constant: 5),
            nineSection2View.trailingAnchor.constraint(equalTo: nineContentView.trailingAnchor, constant: -5),
            nineSection2View.bottomAnchor.constraint(equalTo: nineContentView.bottomAnchor, constant: -20),
        ])
    }
    
    @objc private func findBackAction() {
        navigationController?.popViewController(animated: true)
    }
}

