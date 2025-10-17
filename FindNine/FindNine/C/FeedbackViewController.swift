//
//  FeedbackViewController.swift
//  FindNine
//
//  Created by Zhao on 2025/10/16.
//

import UIKit

class FeedbackViewController: UIViewController {

    private var nineBeiJingImageView: UIImageView!
    private var nineMengCengView: UIView!
    private var nineTitleLabel: UILabel!
    private var nineBackButton: UIButton!
    private var nineScrollView: UIScrollView!
    private var nineContentView: UIView!
    private var nineTextView: UITextView!
    private var nineSubmitButton: UIButton!
    private var nineHistoryButton: UIButton!
    private var ninePlaceholderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        findSetupUI()
        findSetupKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        nineTitleLabel.text = "Feedback"
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
        view.addSubview(nineScrollView)

        // Content view
        nineContentView = UIView()
        nineScrollView.addSubview(nineContentView)

        // TextView container
        let nineTextViewContainer = UIView()
        nineTextViewContainer.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        nineTextViewContainer.layer.cornerRadius = 15
        nineTextViewContainer.layer.shadowColor = UIColor.black.cgColor
        nineTextViewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        nineTextViewContainer.layer.shadowOpacity = 0.2
        nineTextViewContainer.layer.shadowRadius = 4
        nineContentView.addSubview(nineTextViewContainer)

        // TextView
        nineTextView = UITextView()
        nineTextView.font = UIFont.systemFont(ofSize: 16)
        nineTextView.textColor = .darkGray
        nineTextView.backgroundColor = .clear
        nineTextView.layer.cornerRadius = 10
        nineTextView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        nineTextView.delegate = self
        nineTextViewContainer.addSubview(nineTextView)

        // Placeholder label
        ninePlaceholderLabel = UILabel()
        ninePlaceholderLabel.text = "Please share your feedback, suggestions, or report any issues..."
        ninePlaceholderLabel.font = UIFont.systemFont(ofSize: 16)
        ninePlaceholderLabel.textColor = UIColor.lightGray
        ninePlaceholderLabel.numberOfLines = 0
        nineTextView.addSubview(ninePlaceholderLabel)

        // Submit button
        nineSubmitButton = findCreateStyledButton(nineTitle: "Submit Feedback", nineColor: UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 0.9))
        nineSubmitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nineSubmitButton.addTarget(self, action: #selector(findSubmitAction), for: .touchUpInside)
        nineContentView.addSubview(nineSubmitButton)

        // History button
        nineHistoryButton = findCreateStyledButton(nineTitle: "View History", nineColor: UIColor(red: 0.4, green: 0.5, blue: 0.8, alpha: 0.9))
        nineHistoryButton.addTarget(self, action: #selector(findHistoryAction), for: .touchUpInside)
        nineContentView.addSubview(nineHistoryButton)

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
        nineScrollView.translatesAutoresizingMaskIntoConstraints = false
        nineContentView.translatesAutoresizingMaskIntoConstraints = false
        nineTextView.superview!.translatesAutoresizingMaskIntoConstraints = false
        nineTextView.translatesAutoresizingMaskIntoConstraints = false
        ninePlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        nineSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        nineHistoryButton.translatesAutoresizingMaskIntoConstraints = false

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

            nineTextView.superview!.topAnchor.constraint(equalTo: nineContentView.topAnchor, constant: 10),
            nineTextView.superview!.leadingAnchor.constraint(equalTo: nineContentView.leadingAnchor, constant: 5),
            nineTextView.superview!.trailingAnchor.constraint(equalTo: nineContentView.trailingAnchor, constant: -5),
            nineTextView.superview!.heightAnchor.constraint(equalToConstant: 250),

            nineTextView.topAnchor.constraint(equalTo: nineTextView.superview!.topAnchor, constant: 10),
            nineTextView.leadingAnchor.constraint(equalTo: nineTextView.superview!.leadingAnchor, constant: 10),
            nineTextView.trailingAnchor.constraint(equalTo: nineTextView.superview!.trailingAnchor, constant: -10),
            nineTextView.bottomAnchor.constraint(equalTo: nineTextView.superview!.bottomAnchor, constant: -10),

            ninePlaceholderLabel.topAnchor.constraint(equalTo: nineTextView.topAnchor, constant: 15),
            ninePlaceholderLabel.leadingAnchor.constraint(equalTo: nineTextView.leadingAnchor, constant: 15),
            ninePlaceholderLabel.trailingAnchor.constraint(equalTo: nineTextView.trailingAnchor, constant: -15),

            nineSubmitButton.topAnchor.constraint(equalTo: nineTextView.superview!.bottomAnchor, constant: 20),
            nineSubmitButton.centerXAnchor.constraint(equalTo: nineContentView.centerXAnchor),
            nineSubmitButton.widthAnchor.constraint(equalToConstant: 200),
            nineSubmitButton.heightAnchor.constraint(equalToConstant: 50),

            nineHistoryButton.topAnchor.constraint(equalTo: nineSubmitButton.bottomAnchor, constant: 15),
            nineHistoryButton.centerXAnchor.constraint(equalTo: nineContentView.centerXAnchor),
            nineHistoryButton.widthAnchor.constraint(equalToConstant: 160),
            nineHistoryButton.heightAnchor.constraint(equalToConstant: 44),
            nineHistoryButton.bottomAnchor.constraint(equalTo: nineContentView.bottomAnchor, constant: -20),
        ])
    }

    private func findSetupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(findKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(findKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let nineTapGesture = UITapGestureRecognizer(target: self, action: #selector(findDismissKeyboard))
        view.addGestureRecognizer(nineTapGesture)
    }

    @objc private func findKeyboardWillShow(notification: NSNotification) {
        guard let nineKeyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let nineKeyboardHeight = nineKeyboardFrame.height
        nineScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: nineKeyboardHeight, right: 0)
        nineScrollView.scrollIndicatorInsets = nineScrollView.contentInset
    }

    @objc private func findKeyboardWillHide(notification: NSNotification) {
        nineScrollView.contentInset = .zero
        nineScrollView.scrollIndicatorInsets = .zero
    }

    @objc private func findDismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func findBackAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func findSubmitAction() {
        let nineFeedbackText = nineTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !nineFeedbackText.isEmpty else {
            let nineAlert = UIAlertController(title: "Empty Feedback", message: "Please enter your feedback before submitting.", preferredStyle: .alert)
            nineAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(nineAlert, animated: true)
            return
        }

        // Save feedback locally
        let nineFeedback = FeedbackModel(nineContent: nineFeedbackText, nineDate: Date())
        FeedbackGuanliqi.shared.findSaveFeedback(nineFeedback: nineFeedback)

        // Show success message
        let nineAlert = UIAlertController(title: "Thank You!", message: "Your feedback has been submitted successfully.", preferredStyle: .alert)
        nineAlert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.nineTextView.text = ""
            self?.ninePlaceholderLabel.isHidden = false
        })
        present(nineAlert, animated: true)
    }

    @objc private func findHistoryAction() {
        let nineVC = FeedbackHistoryViewController()
        navigationController?.pushViewController(nineVC, animated: true)
    }
}

// MARK: - UITextViewDelegate

extension FeedbackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        ninePlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}
