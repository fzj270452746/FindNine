//
//  JiluViewController.swift
//  FindNine
//
//  Created by Zhao on 2025/10/14.
//

import UIKit
import DateToolsSwift

class JiluViewController: UIViewController {
    
    private var nineBeiJingImageView: UIImageView!
    private var nineMengCengView: UIView!
    private var nineTitleLabel: UILabel!
    private var nineBackButton: UIButton!
    private var nineClearButton: UIButton!
    private var nineTableView: UITableView!
    private var nineRecordsArray: [YouxiJiluModel] = []
    private var nineEmptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findSetupUI()
        findLoadRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        findLoadRecords()
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
        nineTitleLabel.text = "Game Records"
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
        
        // Clear button
        nineClearButton = findCreateStyledButton(nineTitle: "Clear All", nineColor: UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 0.9))
        nineClearButton.addTarget(self, action: #selector(findClearAction), for: .touchUpInside)
        view.addSubview(nineClearButton)
        
        // Table view
        nineTableView = UITableView(frame: .zero, style: .plain)
        nineTableView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        nineTableView.layer.cornerRadius = 15
        nineTableView.delegate = self
        nineTableView.dataSource = self
        nineTableView.register(RecordCell.self, forCellReuseIdentifier: "RecordCell")
        nineTableView.separatorStyle = .singleLine
        nineTableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.addSubview(nineTableView)
        
        // Empty label
        nineEmptyLabel = UILabel()
        nineEmptyLabel.text = "No Records Yet\n\nPlay a game to see your records here!"
        nineEmptyLabel.font = UIFont.systemFont(ofSize: 18)
        nineEmptyLabel.textColor = .gray
        nineEmptyLabel.textAlignment = .center
        nineEmptyLabel.numberOfLines = 0
        nineEmptyLabel.isHidden = true
        view.addSubview(nineEmptyLabel)
        
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
    
    private func findSetupConstraints() {
        nineMengCengView.translatesAutoresizingMaskIntoConstraints = false
        nineTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nineBackButton.translatesAutoresizingMaskIntoConstraints = false
        nineClearButton.translatesAutoresizingMaskIntoConstraints = false
        nineTableView.translatesAutoresizingMaskIntoConstraints = false
        nineEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            nineClearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ninePadding + 10),
            nineClearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ninePadding - 10),
            nineClearButton.widthAnchor.constraint(equalToConstant: 100),
            nineClearButton.heightAnchor.constraint(equalToConstant: 44),
            
            nineTitleLabel.topAnchor.constraint(equalTo: nineBackButton.bottomAnchor, constant: 10),
            nineTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nineTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            nineTableView.topAnchor.constraint(equalTo: nineTitleLabel.bottomAnchor, constant: 20),
            nineTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ninePadding + 10),
            nineTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ninePadding - 10),
            nineTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ninePadding - 10),
            
            nineEmptyLabel.centerXAnchor.constraint(equalTo: nineTableView.centerXAnchor),
            nineEmptyLabel.centerYAnchor.constraint(equalTo: nineTableView.centerYAnchor),
            nineEmptyLabel.leadingAnchor.constraint(equalTo: nineTableView.leadingAnchor, constant: 20),
            nineEmptyLabel.trailingAnchor.constraint(equalTo: nineTableView.trailingAnchor, constant: -20),
        ])
    }
    
    private func findLoadRecords() {
        nineRecordsArray = JiluGuanliqi.shared.findAllRecords()
        // Sort by score (highest first), then by date (most recent first)
        nineRecordsArray.sort { record1, record2 in
            if record1.nineFenshu == record2.nineFenshu {
                return record1.nineShijian > record2.nineShijian
            }
            return record1.nineFenshu > record2.nineFenshu
        }
        nineEmptyLabel.isHidden = !nineRecordsArray.isEmpty
        nineTableView.reloadData()
    }
    
    @objc private func findBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func findClearAction() {
        let nineAlert = UIAlertController(title: "Clear All Records?", message: "This action cannot be undone.", preferredStyle: .alert)
        nineAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        nineAlert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            JiluGuanliqi.shared.findClearAllRecords()
            self?.findLoadRecords()
        })
        present(nineAlert, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate

extension JiluViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nineRecordsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nineCell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        let nineRecord = nineRecordsArray[indexPath.row]
        nineCell.findConfigure(with: nineRecord, nineIndex: indexPath.row + 1)
        return nineCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - RecordCell

class RecordCell: UITableViewCell {
    
    private var nineIndexLabel: UILabel!
    private var nineScoreLabel: UILabel!
    private var nineTimeLabel: UILabel!
    private var nineDateLabel: UILabel!
    private var nineContainerView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        findSetupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func findSetupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        nineContainerView = UIView()
        nineContainerView.backgroundColor = .white
        nineContainerView.layer.cornerRadius = 10
        nineContainerView.layer.shadowColor = UIColor.black.cgColor
        nineContainerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        nineContainerView.layer.shadowOpacity = 0.1
        nineContainerView.layer.shadowRadius = 2
        contentView.addSubview(nineContainerView)
        
        nineIndexLabel = UILabel()
        nineIndexLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nineIndexLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        nineIndexLabel.textAlignment = .center
        nineContainerView.addSubview(nineIndexLabel)
        
        nineScoreLabel = UILabel()
        nineScoreLabel.font = UIFont.boldSystemFont(ofSize: 12)
        nineScoreLabel.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)
        nineContainerView.addSubview(nineScoreLabel)
        
        nineTimeLabel = UILabel()
        nineTimeLabel.font = UIFont.systemFont(ofSize: 15)
        nineTimeLabel.textColor = UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)
        nineContainerView.addSubview(nineTimeLabel)
        
        nineDateLabel = UILabel()
        nineDateLabel.font = UIFont.systemFont(ofSize: 14)
        nineDateLabel.textColor = .gray
        nineDateLabel.numberOfLines = 0
        nineContainerView.addSubview(nineDateLabel)
        
        nineContainerView.translatesAutoresizingMaskIntoConstraints = false
        nineIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        nineScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        nineTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        nineDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nineContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nineContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nineContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nineContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            nineIndexLabel.leadingAnchor.constraint(equalTo: nineContainerView.leadingAnchor, constant: 15),
            nineIndexLabel.centerYAnchor.constraint(equalTo: nineContainerView.centerYAnchor),
            nineIndexLabel.widthAnchor.constraint(equalToConstant: 40),
            
            nineScoreLabel.leadingAnchor.constraint(equalTo: nineIndexLabel.trailingAnchor, constant: 15),
            nineScoreLabel.topAnchor.constraint(equalTo: nineContainerView.topAnchor, constant: 15),
            
            nineTimeLabel.leadingAnchor.constraint(equalTo: nineIndexLabel.trailingAnchor, constant: 15),
            nineTimeLabel.topAnchor.constraint(equalTo: nineScoreLabel.bottomAnchor, constant: 5),
            
            nineDateLabel.trailingAnchor.constraint(equalTo: nineContainerView.trailingAnchor, constant: -15),
            nineDateLabel.centerYAnchor.constraint(equalTo: nineContainerView.centerYAnchor),
            nineDateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nineScoreLabel.trailingAnchor, constant: 10),
        ])
    }
    
    func findConfigure(with nineRecord: YouxiJiluModel, nineIndex: Int) {
        nineIndexLabel.text = "#\(nineIndex)"
        nineScoreLabel.text = "Score: \(nineRecord.nineFenshu)"

        // Show mode-specific time label
        if nineRecord.nineGameMode == .timed {
            nineTimeLabel.text = "Time: \(nineRecord.nineYongshi)s"
        } else {
            nineTimeLabel.text = "Survived: \(nineRecord.nineYongshi)s"
        }

        // Include mode in date label
        nineDateLabel.text = "\(nineRecord.findFormattedDate())\n\(nineRecord.findModeDisplayName())"
    }
}

