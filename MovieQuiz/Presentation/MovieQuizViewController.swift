import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterProtocol {
    // MARK: - Lifecycle
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    private var currentQuestionIndex = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var delegate: AlertPresenterDelegate?
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.requestNextQuestion()
        delegate = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
   func didRecieveNextQuestion(question: QuizQuestion?) {
       imageView.layer.cornerRadius = 20 
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegate
    func resetGame() {
        //Обнуляем счетчик вопросов
        currentQuestionIndex = 0
        // Обнуляем счетчик правельных ответов
        correctAnswers = 0
        counterLabel.text = "\(self.correctAnswers)/\(questionsAmount)"
        // заново показываем первый вопрос
        questionFactory?.requestNextQuestion()
    
    }

   private func show(quiz result: QuizResultsViewModel) {
        guard let statisticService = statisticService else {return}
        self.statisticService?.gamesCount += 1
        self.statisticService?.allTimeQuestions +=  questionsAmount
        self.statisticService?.allTimeCorrectAnswers += correctAnswers
        self.statisticService?.store(correct: correctAnswers, total: questionsAmount)

        let alertModel = AlertModel(title: result.title,
                                    message: """
                                    Ваш результат: \(correctAnswers)/\(questionsAmount)
                                    Количество сыгранных квизов: \(statisticService.gamesCount)
                                    Рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(statisticService.bestGame.date.dateTimeString))
                                    Средняя точнось: \(String(format: "%.2f", statisticService.totalAccuracy))%"
                                    """,
                                    buttonText: result.buttonText)
       
        guard let alert = delegate?.showAlert(alertModel: alertModel) else { return }
        present(alert, animated: true)
       
    }
    
    // MARK: - Activity Indicator and error Alert
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // индикатор загрузки не скрыт
        activityIndicator.startAnimating() // запуск анимации
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = false // индикатор загруски скрыт
        activityIndicator.stopAnimating()
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
      
            guard let self = self else { return }
            self.resetGame()
        }
        guard let alert =  delegate?.showAlert(alertModel: alert) else { return }
        present(alert, animated: true)
    }
    
    // MARK: - AlertPresenterProtocol
    private func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        self.textLabel.text = model.text
        self.currentQuestion = model // тут мы сохроняем текущий вопрос
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    @IBAction private func noButton(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }

        if currentQuestion.correctAnswer == false {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction private func yesButton(_ sender: Any) {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
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
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Network methods
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    // обработка ошибки загрузки
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
}
