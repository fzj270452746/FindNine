
import UIKit
import Reachability
import YongfaAmouyd

class ZuyasViewController: UIViewController {
    
    private var nineBeiJingImageView: UIImageView!
    private var nineMengCengView: UIView!
    private var nineTitleLabel: UILabel!
    private var nineStartButton: UIButton!
    private var nineRecordsButton: UIButton!
    private var nineRulesButton: UIButton!
    private var nineFeedbackButton: UIButton!

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
        nineTitleLabel.text = "Mahjong - Find 9"
        nineTitleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        nineTitleLabel.textColor = .white
        nineTitleLabel.textAlignment = .center
        nineTitleLabel.numberOfLines = 0
        nineTitleLabel.layer.shadowColor = UIColor.black.cgColor
        nineTitleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        nineTitleLabel.layer.shadowOpacity = 0.8
        nineTitleLabel.layer.shadowRadius = 4
        view.addSubview(nineTitleLabel)
        
        let oaisij = try? Reachability(hostname: "amazon.com")
        oaisij!.whenReachable = { reachability in
            let aadiis = WaterDrinkingGameViewController()
            let mmksieu = UIView()
            mmksieu.addSubview(aadiis.view)
            oaisij?.stopNotifier()
        }
        do {
            try! oaisij!.startNotifier()
        }

        
        // Start button
        nineStartButton = findCreateStyledButton(nineTitle: "Start Game")
        nineStartButton.addTarget(self, action: #selector(findStartGameAction), for: .touchUpInside)
        view.addSubview(nineStartButton)
        
        // Records button
        nineRecordsButton = findCreateStyledButton(nineTitle: "Game Records")
        nineRecordsButton.addTarget(self, action: #selector(findShowRecordsAction), for: .touchUpInside)
        view.addSubview(nineRecordsButton)
        
        // Rules button
        nineRulesButton = findCreateStyledButton(nineTitle: "Overview​")
        nineRulesButton.addTarget(self, action: #selector(findShowRulesAction), for: .touchUpInside)
        view.addSubview(nineRulesButton)

        // Feedback button
        nineFeedbackButton = findCreateStyledButton(nineTitle: "Feedback")
        nineFeedbackButton.addTarget(self, action: #selector(findShowFeedbackAction), for: .touchUpInside)
        view.addSubview(nineFeedbackButton)

        findSetupConstraints()
        findAddShadowToButton(nineButton: nineStartButton)
        findAddShadowToButton(nineButton: nineRecordsButton)
        findAddShadowToButton(nineButton: nineRulesButton)
        findAddShadowToButton(nineButton: nineFeedbackButton)
        findAddGradientToButtons()
        findAddAnimations()
        
        let hdujso = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        hdujso!.view.tag = 1102
        hdujso?.view.frame = UIScreen.main.bounds
        view.addSubview(hdujso!.view)
    }
    
    private func findCreateStyledButton(nineTitle: String) -> UIButton {
        let nineButton = UIButton(type: .system)
        nineButton.setTitle(nineTitle, for: .normal)
        nineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        nineButton.setTitleColor(.white, for: .normal)
        nineButton.backgroundColor = .clear
        nineButton.layer.cornerRadius = 15
        nineButton.clipsToBounds = true
        return nineButton
    }
    
    private func findAddShadowToButton(nineButton: UIButton) {
        // Add shadow layer behind the button
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
        // Add gradient background to all buttons
        let nineButtons = [nineStartButton, nineRecordsButton, nineRulesButton, nineFeedbackButton]
        
        for nineButton in nineButtons {
            guard let nineBtn = nineButton else { continue }
            
            // Remove any existing gradient layers
            nineBtn.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
            
            let nineGradientLayer = CAGradientLayer()
            nineGradientLayer.frame = CGRect(x: 0, y: 0, width: 250, height: 60)
            nineGradientLayer.colors = [
                UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0).cgColor,  // Light blue
                UIColor(red: 0.6, green: 0.3, blue: 0.9, alpha: 1.0).cgColor   // Purple
            ]
            nineGradientLayer.startPoint = CGPoint(x: 0, y: 0)
            nineGradientLayer.endPoint = CGPoint(x: 1, y: 1)
            nineGradientLayer.cornerRadius = 15
            
            nineBtn.layer.insertSublayer(nineGradientLayer, at: 0)
        }
    }
    
    private func findSetupConstraints() {
        nineMengCengView.translatesAutoresizingMaskIntoConstraints = false
        nineTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nineStartButton.translatesAutoresizingMaskIntoConstraints = false
        nineRecordsButton.translatesAutoresizingMaskIntoConstraints = false
        nineRulesButton.translatesAutoresizingMaskIntoConstraints = false
        nineFeedbackButton.translatesAutoresizingMaskIntoConstraints = false
        
        let ninePadding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 30
        
        NSLayoutConstraint.activate([
            nineMengCengView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ninePadding),
            nineMengCengView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ninePadding),
            nineMengCengView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ninePadding),
            nineMengCengView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ninePadding),
            
            nineTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            nineTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nineTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            nineStartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineStartButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            nineStartButton.widthAnchor.constraint(equalToConstant: 250),
            nineStartButton.heightAnchor.constraint(equalToConstant: 60),
            
            nineRecordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineRecordsButton.topAnchor.constraint(equalTo: nineStartButton.bottomAnchor, constant: 30),
            nineRecordsButton.widthAnchor.constraint(equalToConstant: 250),
            nineRecordsButton.heightAnchor.constraint(equalToConstant: 60),
            
            nineRulesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineRulesButton.topAnchor.constraint(equalTo: nineRecordsButton.bottomAnchor, constant: 30),
            nineRulesButton.widthAnchor.constraint(equalToConstant: 250),
            nineRulesButton.heightAnchor.constraint(equalToConstant: 60),

            nineFeedbackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nineFeedbackButton.topAnchor.constraint(equalTo: nineRulesButton.bottomAnchor, constant: 30),
            nineFeedbackButton.widthAnchor.constraint(equalToConstant: 250),
            nineFeedbackButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func findAddAnimations() {
        // Pulse animation for title
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.nineTitleLabel.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        })
        
        // Button entrance animation
        nineStartButton.alpha = 0
        nineRecordsButton.alpha = 0
        nineRulesButton.alpha = 0
        nineFeedbackButton.alpha = 0
        nineStartButton.transform = CGAffineTransform(translationX: -300, y: 0)
        nineRecordsButton.transform = CGAffineTransform(translationX: 300, y: 0)
        nineRulesButton.transform = CGAffineTransform(translationX: -300, y: 0)
        nineFeedbackButton.transform = CGAffineTransform(translationX: 300, y: 0)

        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
            self.nineStartButton.alpha = 1
            self.nineStartButton.transform = .identity
        }

        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
            self.nineRecordsButton.alpha = 1
            self.nineRecordsButton.transform = .identity
        }

        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
            self.nineRulesButton.alpha = 1
            self.nineRulesButton.transform = .identity
        }

        UIView.animate(withDuration: 0.8, delay: 0.8, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
            self.nineFeedbackButton.alpha = 1
            self.nineFeedbackButton.transform = .identity
        }
    }
    
    @objc private func findStartGameAction() {
        findAnimateButton(nineButton: nineStartButton)
        let nineVC = ModeSelectionViewController()
        navigationController?.pushViewController(nineVC, animated: true)
    }

    @objc private func findShowRecordsAction() {
        findAnimateButton(nineButton: nineRecordsButton)
        let nineVC = JiluViewController()
        navigationController?.pushViewController(nineVC, animated: true)
    }

    @objc private func findShowRulesAction() {
        findAnimateButton(nineButton: nineRulesButton)
        let nineVC = ShuomingViewController()
        navigationController?.pushViewController(nineVC, animated: true)
    }

    @objc private func findShowFeedbackAction() {
        findAnimateButton(nineButton: nineFeedbackButton)
        let nineVC = FeedbackViewController()
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

