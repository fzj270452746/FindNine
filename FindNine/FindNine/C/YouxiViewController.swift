//
//  YouxiViewController.swift
//  FindNine
//
//  Created by Zhao on 2025/10/14.
//

import UIKit

class YouxiViewController: UIViewController {

    // UI Components
    private var nineBeiJingImageView: UIImageView!
    private var nineMengCengView: UIView!
    private var nineTopContainerView: UIView!
    private var nineTargetNumberLabel: UILabel!
    private var nineScoreLabel: UILabel!
    private var nineTimerLabel: UILabel!
    private var nineBackButton: UIButton!
    private var nineRefreshButton: UIButton!
    private var nineCollectionView: UICollectionView!
    private var nineModeLabel: UILabel!

    // Game State
    private var nineGameMode: GameMode
    private var nineCurrentTarget: Int = 1
    private var nineScore: Int = 0
    private var nineRemainingTime: Int = 60
    private var nineTimer: Timer?
    private var nineStartTime: Date?
    private var nineMahjongDataArray: [NineMahjongModel] = []

    // Initializer
    init(nineGameMode: GameMode) {
        self.nineGameMode = nineGameMode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.nineGameMode = .timed
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        findSetupUI()
        findStartNewGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        findStopTimer()
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
        
        // Top container
        nineTopContainerView = UIView()
        nineTopContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        nineTopContainerView.layer.cornerRadius = 15
        nineTopContainerView.layer.shadowColor = UIColor.black.cgColor
        nineTopContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        nineTopContainerView.layer.shadowOpacity = 0.3
        nineTopContainerView.layer.shadowRadius = 5
        view.addSubview(nineTopContainerView)
        
        // Target number label
        nineTargetNumberLabel = UILabel()
        nineTargetNumberLabel.text = "9"
        nineTargetNumberLabel.font = UIFont.boldSystemFont(ofSize: 80)
        nineTargetNumberLabel.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        nineTargetNumberLabel.textAlignment = .center
        nineTopContainerView.addSubview(nineTargetNumberLabel)
        
        // Score label
        nineScoreLabel = UILabel()
        nineScoreLabel.text = "Score: 0"
        nineScoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nineScoreLabel.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)
        nineScoreLabel.textAlignment = .left
        view.addSubview(nineScoreLabel)
        
        // Timer label
        nineTimerLabel = UILabel()
        nineTimerLabel.text = nineGameMode == .timed ? "Time: 60s" : "Lives: Unlimited"
        nineTimerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nineTimerLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        nineTimerLabel.textAlignment = .right
        view.addSubview(nineTimerLabel)

        // Mode label
        nineModeLabel = UILabel()
        nineModeLabel.text = nineGameMode.displayName()
        nineModeLabel.font = UIFont.systemFont(ofSize: 14)
        nineModeLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        nineModeLabel.textAlignment = .center
        view.addSubview(nineModeLabel)
        
        // Back button
        nineBackButton = findCreateCustomBackButton()
        nineBackButton.addTarget(self, action: #selector(findBackAction), for: .touchUpInside)
        view.addSubview(nineBackButton)
        
        // Refresh button
        nineRefreshButton = findCreateRefreshButton()
        nineRefreshButton.addTarget(self, action: #selector(findRefreshAction), for: .touchUpInside)
        view.addSubview(nineRefreshButton)
        
        // Collection view
        let nineLayout = UICollectionViewFlowLayout()
        nineLayout.minimumInteritemSpacing = 10
        nineLayout.minimumLineSpacing = 10
        nineLayout.scrollDirection = .vertical
        
        nineCollectionView = UICollectionView(frame: .zero, collectionViewLayout: nineLayout)
        nineCollectionView.backgroundColor = .clear
        nineCollectionView.delegate = self
        nineCollectionView.dataSource = self
        nineCollectionView.register(MahjongCell.self, forCellWithReuseIdentifier: "MahjongCell")
        view.addSubview(nineCollectionView)
        
        findSetupConstraints()
    }
    
    private func findCreateCustomBackButton() -> UIButton {
        let nineButton = UIButton(type: .system)
        nineButton.setTitle("←", for: .normal)
        nineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nineButton.setTitleColor(.white, for: .normal)
        nineButton.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        nineButton.layer.cornerRadius = 12
        nineButton.layer.shadowColor = UIColor.black.cgColor
        nineButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nineButton.layer.shadowOpacity = 0.3
        nineButton.layer.shadowRadius = 3
        return nineButton
    }
    
    private func findCreateRefreshButton() -> UIButton {
        let nineButton = UIButton(type: .system)
        nineButton.setTitle("⟳ Refresh", for: .normal)
        nineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nineButton.setTitleColor(.white, for: .normal)
        nineButton.backgroundColor = UIColor(red: 0.9, green: 0.5, blue: 0.1, alpha: 0.9)
        nineButton.layer.cornerRadius = 12
        nineButton.layer.shadowColor = UIColor.black.cgColor
        nineButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nineButton.layer.shadowOpacity = 0.3
        nineButton.layer.shadowRadius = 3
        return nineButton
    }
    
    private func findSetupConstraints() {
        nineMengCengView.translatesAutoresizingMaskIntoConstraints = false
        nineTopContainerView.translatesAutoresizingMaskIntoConstraints = false
        nineTargetNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        nineScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        nineTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        nineModeLabel.translatesAutoresizingMaskIntoConstraints = false
        nineBackButton.translatesAutoresizingMaskIntoConstraints = false
        nineRefreshButton.translatesAutoresizingMaskIntoConstraints = false
        nineCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            nineTopContainerView.topAnchor.constraint(equalTo: nineBackButton.bottomAnchor, constant: 20),
            nineTopContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineTopContainerView.widthAnchor.constraint(equalToConstant: 200),
            nineTopContainerView.heightAnchor.constraint(equalToConstant: 120),
            
            nineTargetNumberLabel.centerXAnchor.constraint(equalTo: nineTopContainerView.centerXAnchor),
            nineTargetNumberLabel.centerYAnchor.constraint(equalTo: nineTopContainerView.centerYAnchor),
            
            nineScoreLabel.topAnchor.constraint(equalTo: nineTopContainerView.bottomAnchor, constant: 15),
            nineScoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ninePadding + 20),
            
            nineTimerLabel.topAnchor.constraint(equalTo: nineTopContainerView.bottomAnchor, constant: 15),
            nineTimerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ninePadding - 20),

            nineModeLabel.centerYAnchor.constraint(equalTo: nineBackButton.centerYAnchor),
            nineModeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nineCollectionView.topAnchor.constraint(equalTo: nineScoreLabel.bottomAnchor, constant: 20),
            nineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ninePadding + 10),
            nineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ninePadding - 10),
            nineCollectionView.bottomAnchor.constraint(equalTo: nineRefreshButton.topAnchor, constant: -15),
            
            nineRefreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ninePadding - 10),
            nineRefreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineRefreshButton.widthAnchor.constraint(equalToConstant: 140),
            nineRefreshButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Game Logic
    
    private func findStartNewGame() {
        nineStartTime = Date()
        if nineGameMode == .timed {
            nineRemainingTime = 60
            findStartTimer()
        } else {
            // Endless mode - no timer
            nineTimerLabel.text = "Lives: Unlimited"
        }
        findGenerateNewRound()
    }
    
    private func findGenerateNewRound() {
        nineCurrentTarget = Int.random(in: 1...9)
        nineTargetNumberLabel.text = "\(nineCurrentTarget)"
        
        // Animate target number
        UIView.animate(withDuration: 0.3, animations: {
            self.nineTargetNumberLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.nineTargetNumberLabel.transform = .identity
            }
        }
        
        findGenerateMahjongData()
        nineCollectionView.reloadData()
    }
    
    private func findGenerateMahjongData() {
        nineMahjongDataArray.removeAll()
        
        let nineAllTiao = [nineMahTiao1, nineMahTiao2, nineMahTiao3, nineMahTiao4, nineMahTiao5, nineMahTiao6, nineMahTiao7, nineMahTiao8, nineMahTiao9]
        let nineAllTong = [nineMahTong1, nineMahTong2, nineMahTong3, nineMahTong4, nineMahTong5, nineMahTong6, nineMahTong7, nineMahTong8, nineMahTong9]
        let nineAllWan = [nineMahWan1, nineMahWan2, nineMahWan3, nineMahWan4, nineMahWan5, nineMahWan6, nineMahWan7, nineMahWan8, nineMahWan9]
        let nineOthers = [otherModel0, otherModel1, otherModel2, otherModel3, otherModel4, otherModel5, otherModel6]
        
        // Add target mahjongs (2-4 of each type)
        let nineTargetCount = Int.random(in: 2...4)
        for _ in 0..<nineTargetCount {
            if let nineTiao = nineAllTiao.filter({ $0.nineID == "\(nineCurrentTarget)" }).first {
                nineMahjongDataArray.append(nineTiao)
            }
            if let nineTong = nineAllTong.filter({ $0.nineID == "\(nineCurrentTarget)" }).first {
                nineMahjongDataArray.append(nineTong)
            }
            if let nineWan = nineAllWan.filter({ $0.nineID == "\(nineCurrentTarget)" }).first {
                nineMahjongDataArray.append(nineWan)
            }
        }
        
        // Add random mahjongs
        let nineRandomCount = Int.random(in: 15...29)
        for _ in 0..<nineRandomCount {
            let nineType = Int.random(in: 0...3)
            switch nineType {
            case 0:
                if let nineMah = nineAllTiao.randomElement() {
                    nineMahjongDataArray.append(nineMah)
                }
            case 1:
                if let nineMah = nineAllTong.randomElement() {
                    nineMahjongDataArray.append(nineMah)
                }
            case 2:
                if let nineMah = nineAllWan.randomElement() {
                    nineMahjongDataArray.append(nineMah)
                }
            case 3:
                if let nineOther = nineOthers.randomElement() {
                    let nineMah = NineMahjongModel(nineImage: nineOther.otherImage, nineTitle: "0", nineID: "0")
                    nineMahjongDataArray.append(nineMah)
                }
            default:
                break
            }
        }
        
        nineMahjongDataArray.shuffle()
    }
    
    private func findStartTimer() {
        // Only start timer in timed mode
        guard nineGameMode == .timed else { return }
        nineTimer?.invalidate()
        nineTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.findUpdateTimer()
        }
    }
    
    private func findStopTimer() {
        nineTimer?.invalidate()
        nineTimer = nil
    }
    
    private func findUpdateTimer() {
        nineRemainingTime -= 1
        nineTimerLabel.text = "Time: \(nineRemainingTime)s"
        
        if nineRemainingTime <= 10 {
            nineTimerLabel.textColor = .red
            UIView.animate(withDuration: 0.2, animations: {
                self.nineTimerLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    self.nineTimerLabel.transform = .identity
                }
            }
        }
        
        if nineRemainingTime <= 0 {
            findGameOver()
        }
    }
    
    private func findCheckSelection(nineIndex: Int) {
        let nineMahjong = nineMahjongDataArray[nineIndex]
        
        if nineMahjong.nineID == "\(nineCurrentTarget)" {
            // Correct selection
            nineScore += 1
            nineScoreLabel.text = "Score: \(nineScore)"
            
            // Show feedback animation then remove the mahjong
            if let nineCell = nineCollectionView.cellForItem(at: IndexPath(item: nineIndex, section: 0)) as? MahjongCell {
                nineCell.nineBorderColor = .green
                nineCell.nineBorderWidth = 4
                
                UIView.animate(withDuration: 0.15, animations: {
                    nineCell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    nineCell.alpha = 0
                }) { _ in
                    // Remove the mahjong from data array
                    self.nineMahjongDataArray.remove(at: nineIndex)
                    
                    // Remove from collection view with animation
                    self.nineCollectionView.performBatchUpdates({
                        self.nineCollectionView.deleteItems(at: [IndexPath(item: nineIndex, section: 0)])
                    }, completion: { _ in
                        // Check if all target mahjongs are removed
                        let nineRemainingTargets = self.nineMahjongDataArray.filter { $0.nineID == "\(self.nineCurrentTarget)" }.count
                        
                        if nineRemainingTargets == 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.findGenerateNewRound()
                            }
                        }
                    })
                }
            }
        } else {
            // Wrong selection
            if nineGameMode == .endless {
                // In endless mode, game over on first mistake
                findShowFeedback(nineCorrect: false, at: nineIndex)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.findGameOver()
                }
            } else {
                // In timed mode, deduct score
                nineScore = max(0, nineScore - 1)
                nineScoreLabel.text = "Score: \(nineScore)"
                findShowFeedback(nineCorrect: false, at: nineIndex)
            }
        }
    }
    
    private func findShowFeedback(nineCorrect: Bool, at nineIndex: Int) {
        if let nineCell = nineCollectionView.cellForItem(at: IndexPath(item: nineIndex, section: 0)) as? MahjongCell {
            let nineOriginalColor = nineCell.nineBorderColor
            nineCell.nineBorderColor = nineCorrect ? .green : .red
            nineCell.nineBorderWidth = 4
            
            UIView.animate(withDuration: 0.2, animations: {
                nineCell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    nineCell.transform = .identity
                    if !nineCorrect {
                        nineCell.nineBorderColor = nineOriginalColor
                        nineCell.nineBorderWidth = 2
                    }
                }
            }
        }
    }
    
    private func findGameOver() {
        findStopTimer()

        let nineUsedTime: Int
        if nineGameMode == .timed {
            nineUsedTime = 60 - nineRemainingTime
        } else {
            // Endless mode - calculate elapsed time
            nineUsedTime = Int(Date().timeIntervalSince(nineStartTime ?? Date()))
        }

        let nineRecord = YouxiJiluModel(nineFenshu: nineScore, nineShijian: Date(), nineYongshi: nineUsedTime, nineGameMode: nineGameMode)
        JiluGuanliqi.shared.findSaveRecord(nineRecord: nineRecord)

        let nineMessage: String
        if nineGameMode == .timed {
            nineMessage = "Your Score: \(nineScore)\nTime: \(nineUsedTime)s"
        } else {
            nineMessage = "Your Score: \(nineScore)\nSurvival Time: \(nineUsedTime)s"
        }

        let nineAlert = UIAlertController(title: "Game Over!", message: nineMessage, preferredStyle: .alert)
        nineAlert.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.nineScore = 0
            self?.nineScoreLabel.text = "Score: 0"
            self?.findStartNewGame()
        })
        nineAlert.addAction(UIAlertAction(title: "Back to Menu", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(nineAlert, animated: true)
    }
    
    @objc private func findBackAction() {
        let nineAlert = UIAlertController(title: "Quit Game?", message: "Your progress will be lost.", preferredStyle: .alert)
        nineAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        nineAlert.addAction(UIAlertAction(title: "Quit", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(nineAlert, animated: true)
    }
    
    @objc private func findRefreshAction() {
        UIView.animate(withDuration: 0.2, animations: {
            self.nineRefreshButton.transform = CGAffineTransform(rotationAngle: .pi)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.nineRefreshButton.transform = CGAffineTransform(rotationAngle: .pi * 2)
            }
        }
        findGenerateNewRound()
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension YouxiViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nineMahjongDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let nineCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MahjongCell", for: indexPath) as! MahjongCell
        let nineMahjong = nineMahjongDataArray[indexPath.item]
        nineCell.findConfigure(with: nineMahjong, isSelected: false)
        return nineCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        findCheckSelection(nineIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ninePadding: CGFloat = 10
        let nineColumns: CGFloat = 7  // Fixed 7 columns per row
        let nineAvailableWidth = collectionView.bounds.width - (ninePadding * (nineColumns + 1))
        let nineWidth = nineAvailableWidth / nineColumns
        return CGSize(width: nineWidth, height: nineWidth * 1.3)
    }
}

// MARK: - MahjongCell

class MahjongCell: UICollectionViewCell {
    
    private var nineImageView: UIImageView!
    var nineBorderColor: UIColor = .white {
        didSet {
            layer.borderColor = nineBorderColor.cgColor
        }
    }
    var nineBorderWidth: CGFloat = 2 {
        didSet {
            layer.borderWidth = nineBorderWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        findSetupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func findSetupCell() {
        backgroundColor = .white
        layer.cornerRadius = 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        
        nineImageView = UIImageView()
        nineImageView.contentMode = .scaleAspectFit
        nineImageView.clipsToBounds = true
        contentView.addSubview(nineImageView)
        
        nineImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nineImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            nineImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            nineImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            nineImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }
    
    func findConfigure(with nineMahjong: NineMahjongModel, isSelected: Bool) {
        nineImageView.image = nineMahjong.nineImage
        alpha = 1.0
        nineBorderColor = .white
        nineBorderWidth = 2
        transform = .identity
    }
}

