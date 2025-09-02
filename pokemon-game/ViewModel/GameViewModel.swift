//
//  GameViewModel.swift
//  pokemon-game
//
//  Created by karwan Syborg on 02/09/2025.
//

import Foundation
import RxSwift
import RxCocoa

class GameViewModel {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var currentPokemonIndex = 0 
    private let pokemons = Pokemon.mockPokemons
    
    // MARK: - Inputs
    let answerSelected = PublishSubject<String>()
    let newGameTapped = PublishSubject<Void>()
    
    // MARK: - Outputs
    let currentPokemon = BehaviorRelay<Pokemon?>(value: nil)
    let remainingTries = BehaviorRelay<Int>(value: 3)
    let score = BehaviorRelay<Int>(value: 0)
    let gameState = BehaviorRelay<GameState>(value: .playing)
    let message = BehaviorRelay<String>(value: "Who's that Pokemon?")
    let isGameOver = BehaviorRelay<Bool>(value: false)
    
    enum GameState {
        case playing
        case correct
        case wrong
        case gameOver
    }
    
    init() {
        setupBindings()
        startNewGame()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Handle answer selection
        answerSelected
            .subscribe(onNext: { [weak self] answer in
                self?.checkAnswer(answer)
            })
            .disposed(by: disposeBag)
        
        // Handle new game
        newGameTapped
            .subscribe(onNext: { [weak self] in
                self?.startNewGame()
            })
            .disposed(by: disposeBag)
    }
    
    private func startNewGame() {
        currentPokemonIndex = 0
        score.accept(0)
        remainingTries.accept(3)
        gameState.accept(.playing)
        isGameOver.accept(false)
        message.accept("Who's that Pokemon?")
        loadNextPokemon()
    }
    
    private func loadNextPokemon() {
        guard currentPokemonIndex < pokemons.count else {
            endGame()
            return
        }
        
        let pokemon = pokemons[currentPokemonIndex]
        currentPokemon.accept(pokemon)
        remainingTries.accept(3)
        gameState.accept(.playing)
        message.accept("Who's that Pokemon?")
    }
    
    private func checkAnswer(_ answer: String) {
        guard let pokemon = currentPokemon.value,
              gameState.value == .playing else { return }
        
        if answer.lowercased() == pokemon.name.lowercased() {
            // Correct answer
            let newScore = score.value + 10
            score.accept(newScore)
            gameState.accept(.correct)
            message.accept("Correct! It's \(pokemon.name.capitalized)!")
            
            // Move to next Pokemon after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.currentPokemonIndex += 1
                self.loadNextPokemon()
            }
        } else {
            // Wrong answer
            let newTries = remainingTries.value - 1
            remainingTries.accept(newTries)
            
            if newTries <= 0 {
                gameState.accept(.wrong)
                message.accept("Game Over! It was \(pokemon.name.capitalized)")
                isGameOver.accept(true)
            } else {
                gameState.accept(.wrong)
                message.accept("Wrong! \(newTries) tries left")
                
                // Reset to playing state after showing wrong message
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if self.remainingTries.value > 0 {
                        self.gameState.accept(.playing)
                        self.message.accept("Who's that Pokemon?")
                    }
                }
            }
        }
    }
    
    private func endGame() {
        gameState.accept(.gameOver)
        message.accept("Game Complete! Final Score: \(score.value)")
        isGameOver.accept(true)
    }
} 