import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    private var currentQuestionIndex = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private let questionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questionFactory.requestNextQuestion()!))
    }
    
    private func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText,
                                   style: .cancel) {[weak self] _ in
            guard let self = self else {return}
            // Обнуляем счетчик вопросов
            self.currentQuestionIndex = 0
            // Обнуляем счетчик правельных ответов
            self.correctAnswers = 0
            self.counterLabel.text = "\(self.correctAnswers + 1)/10"
            
            // заново показываем первый вопрос
            if let firstQuestion = self.questionFactory.requestNextQuestion() {
                self.currentQuestion = firstQuestion
                let viewModel = self.convert(model: firstQuestion)
                self.show(quiz: viewModel)
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        self.textLabel.text = model.text
        self.currentQuestion = model // тут мы сохроняем текущий вопрос
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    @IBAction func noButton(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }

        if currentQuestion.correctAnswer == false {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction func yesButton(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            print("error")
            return
        }
        
        if currentQuestion.correctAnswer == true {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // разрешение на рисование
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругление углов
        // отключение кликабельности кнопок
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect {
            imageView.layer.borderColor = UIColor.YPGreen.cgColor// цвет рамки
            correctAnswers += 1
            
        } else {
            imageView.layer.borderColor = UIColor.YPRed.cgColor // цвет рамки
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        // включение кликабельности кнопок 
        yesButton.isEnabled = true
        noButton.isEnabled = true

        if currentQuestionIndex == questionsAmount - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(title: "Раунд окончен",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            if let nextQuestion = questionFactory.requestNextQuestion() {
                self.currentQuestion = nextQuestion
                let viewModel = convert(model: nextQuestion)
                self.show(quiz: viewModel)
            }
        }
    }
}

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
