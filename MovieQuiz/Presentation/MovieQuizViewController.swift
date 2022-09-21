import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
    // MARK: - Question Model
struct QuizQuestion {
    let image: String
    let qustion: String
    let rating: String
    let correctAnswer: Bool
}
    // MARK: - MOK Data
let theGodfather = QuizQuestion(image: "The Godfather",
                                qustion: "Рейтинг этого фильма больше чем 6?",
                                rating: "9,2" ,
                                correctAnswer: true)
let theDarkKnight = QuizQuestion(image: "The Dark Knight",
                                 qustion: "Рейтинг этого фильма больше чем 6?",
                                 rating: "9",
                                 correctAnswer: true)
let killBill = QuizQuestion(image: "Kill Bill" ,
                            qustion: "Рейтинг этого фильма больше чем 6?",
                            rating: "8,1",
                            correctAnswer: true)
let theAvengers = QuizQuestion(image: "The Avengers",
                               qustion: "Рейтинг этого фильма больше чем 6?",
                               rating: "8",
                               correctAnswer: true)
let deadpool = QuizQuestion(image: "Deadpool",
                            qustion: "Рейтинг этого фильма больше чем 6?",
                            rating: "8",
                            correctAnswer: true)
let theGreenKnight = QuizQuestion(image: "The Green Knight",
                                  qustion: "Рейтинг этого фильма больше чем 6?",
                                  rating: "6,6",
                                  correctAnswer: true)
let old = QuizQuestion(image: "Old",
                       qustion: "Рейтинг этого фильма больше чем 6?",
                       rating: "5,8",
                       correctAnswer: false)
let theIceAgeAdventuresofBuckWild = QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                                                 qustion: "Рейтинг этого фильма больше чем 6?",
                                                 rating: "4,3",
                                                 correctAnswer: false)
let tesla = QuizQuestion(image: "Tesla",
                         qustion: "Рейтинг этого фильма больше чем 6?",
                         rating: "5,1",
                         correctAnswer: false)
let vivarium = QuizQuestion(image: "Vivarium",
                            qustion: "Рейтинг этого фильма больше чем 6?",
                            rating: "5,8",
                            correctAnswer: false)


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
