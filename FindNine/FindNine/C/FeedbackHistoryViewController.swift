//
//  FeedbackHistoryViewController.swift
//  FindNine
//
//  Created by Zhao on 2025/10/16.
//

import UIKit

class FeedbackHistoryViewController: UIViewController {

    private var nineBeiJingImageView: UIImageView!
    private var nineMengCengView: UIView!
    private var nineTitleLabel: UILabel!
    private var nineBackButton: UIButton!
    private var nineClearButton: UIButton!
    private var nineTableView: UITableView!
    private var nineFeedbacksArray: [FeedbackModel] = []
    private var nineEmptyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        findSetupUI()
        findLoadFeedbacks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        findLoadFeedbacks()
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
        nineTitleLabel.text = "Feedback History"
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
        nineTableView.register(FeedbackCell.self, forCellReuseIdentifier: "FeedbackCell")
        nineTableView.separatorStyle = .singleLine
        nineTableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.addSubview(nineTableView)

        // Empty label
        nineEmptyLabel = UILabel()
        nineEmptyLabel.text = "No Feedback Yet\n\nYour submitted feedbacks will appear here!"
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

    private func findLoadFeedbacks() {
        nineFeedbacksArray = FeedbackGuanliqi.shared.findAllFeedbacks()
        nineEmptyLabel.isHidden = !nineFeedbacksArray.isEmpty
        nineTableView.reloadData()
    }

    @objc private func findBackAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func findClearAction() {
        let nineAlert = UIAlertController(title: "Clear All Feedbacks?", message: "This action cannot be undone.", preferredStyle: .alert)
        nineAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        nineAlert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            FeedbackGuanliqi.shared.findClearAllFeedbacks()
            self?.findLoadFeedbacks()
        })
        present(nineAlert, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate

extension FeedbackHistoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nineFeedbacksArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nineCell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackCell
        let nineFeedback = nineFeedbacksArray[indexPath.row]
        nineCell.findConfigure(with: nineFeedback)
        return nineCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FeedbackGuanliqi.shared.findDeleteFeedback(at: indexPath.row)
            findLoadFeedbacks()
        }
    }
}

// MARK: - FeedbackCell

class FeedbackCell: UITableViewCell {

    private var nineContentLabel: UILabel!
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

        nineContentLabel = UILabel()
        nineContentLabel.font = UIFont.systemFont(ofSize: 15)
        nineContentLabel.textColor = .darkGray
        nineContentLabel.numberOfLines = 0
        nineContainerView.addSubview(nineContentLabel)

        nineDateLabel = UILabel()
        nineDateLabel.font = UIFont.systemFont(ofSize: 12)
        nineDateLabel.textColor = .lightGray
        nineContainerView.addSubview(nineDateLabel)

        nineContainerView.translatesAutoresizingMaskIntoConstraints = false
        nineContentLabel.translatesAutoresizingMaskIntoConstraints = false
        nineDateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nineContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nineContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nineContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nineContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            nineContentLabel.topAnchor.constraint(equalTo: nineContainerView.topAnchor, constant: 15),
            nineContentLabel.leadingAnchor.constraint(equalTo: nineContainerView.leadingAnchor, constant: 15),
            nineContentLabel.trailingAnchor.constraint(equalTo: nineContainerView.trailingAnchor, constant: -15),

            nineDateLabel.topAnchor.constraint(equalTo: nineContentLabel.bottomAnchor, constant: 10),
            nineDateLabel.leadingAnchor.constraint(equalTo: nineContainerView.leadingAnchor, constant: 15),
            nineDateLabel.trailingAnchor.constraint(equalTo: nineContainerView.trailingAnchor, constant: -15),
            nineDateLabel.bottomAnchor.constraint(equalTo: nineContainerView.bottomAnchor, constant: -15),
        ])
    }

    func findConfigure(with nineFeedback: FeedbackModel) {
        nineContentLabel.text = nineFeedback.nineContent
        nineDateLabel.text = nineFeedback.findFormattedDate()
    }
}
