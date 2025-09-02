//
//  ViewController.swift
//  pokemon-game
//
//  Created by karwan Syborg on 02/09/2025.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = GameViewModel()
    
    // MARK: - UI Components,all are inside the closure and immediately called by {...}() , remmember it.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pokemon Guess Game"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let triesLabel: UILabel = {
        let label = UILabel()
        label.text = "Tries: 3"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 20
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowRadius = 8
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Who's that Pokemon?"
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let newGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New Game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // hide the button until the game is over
        return button
    }()
    
    private var optionButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(triesLabel)
        view.addSubview(pokemonImageView)
        view.addSubview(messageLabel)
        view.addSubview(optionsStackView)
        view.addSubview(newGameButton)
        
        // Create option buttons
        createOptionButtons()
        
        // Setup constraints
        setupConstraints()
    }
    
    private func createOptionButtons() {
        for i in 0..<4 {
            let button = UIButton(type: .system)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.backgroundColor = .systemGray6
            button.setTitleColor(.label, for: .normal)
            button.layer.cornerRadius = 25
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.tag = i
            
            // Add subtle shadow
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.1
            button.layer.shadowRadius = 4
            
            optionButtons.append(button)
            optionsStackView.addArrangedSubview(button)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Score and Tries
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoreLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            triesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            triesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            triesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            // Pokemon Image
            pokemonImageView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 30),
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 200),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Message
            messageLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Options Stack View
            optionsStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            optionsStackView.heightAnchor.constraint(equalToConstant: 200),
            
            // New Game Button
            newGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.widthAnchor.constraint(equalToConstant: 150),
            newGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - RxSwift Bindings
    private func setupBindings() {
        // Bind score
        viewModel.score
            .map { "Score: \($0)" }
            .bind(to: scoreLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Bind tries
        viewModel.remainingTries
            .map { "Tries: \($0)" }
            .bind(to: triesLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Bind message
        viewModel.message
            .bind(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Bind game over state
        viewModel.isGameOver
            .map { !$0 }
            .bind(to: newGameButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        // Bind current pokemon
        viewModel.currentPokemon
            .subscribe(onNext: { [weak self] pokemon in
                self?.updateUI(with: pokemon)
            })
            .disposed(by: disposeBag)
        
        // Bind game state for visual feedback
        viewModel.gameState
            .subscribe(onNext: { [weak self] state in
                self?.updateButtonState(for: state)
            })
            .disposed(by: disposeBag)
        
        // Bind option button taps
        for (index, button) in optionButtons.enumerated() {
            button.rx.tap
                .withLatestFrom(viewModel.currentPokemon)
                .compactMap { pokemon in
                    return pokemon?.options[safe: index]
                }
                .bind(to: viewModel.answerSelected)
                .disposed(by: disposeBag)
        }
        
        // Bind new game button
        newGameButton.rx.tap
            .bind(to: viewModel.newGameTapped)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Updates
    private func updateUI(with pokemon: Pokemon?) {
        guard let pokemon = pokemon else { return }
        
        // Load image
        loadImage(from: pokemon.imageURL)
        
        // Update option buttons
        for (index, option) in pokemon.options.enumerated() {
            if index < optionButtons.count {
                optionButtons[index].setTitle(option.capitalized, for: .normal)
                optionButtons[index].isHidden = false
            }
        }
        
        // Hide extra buttons if needed
        for i in pokemon.options.count..<optionButtons.count {
            optionButtons[i].isHidden = true
        }
    }
    
    private func updateButtonState(for gameState: GameViewModel.GameState) {
        switch gameState {
        case .playing:
            for button in optionButtons {
                button.backgroundColor = .systemGray6
                button.layer.borderColor = UIColor.systemGray4.cgColor
                button.isEnabled = true
            }
        case .correct:
            for button in optionButtons {
                button.backgroundColor = .systemGreen.withAlphaComponent(0.3)
                button.layer.borderColor = UIColor.systemGreen.cgColor
                button.isEnabled = false
            }
        case .wrong:
            for button in optionButtons {
                button.backgroundColor = .systemRed.withAlphaComponent(0.3)
                button.layer.borderColor = UIColor.systemRed.cgColor
                button.isEnabled = false
            }
        case .gameOver:
            for button in optionButtons {
                button.isEnabled = false
            }
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Show loading placeholder
        pokemonImageView.image = UIImage(systemName: "photo")
        pokemonImageView.tintColor = .systemGray3
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.pokemonImageView.image = image
                self?.pokemonImageView.tintColor = nil
            }
        }.resume()
    }
}

// MARK: - Array Extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

