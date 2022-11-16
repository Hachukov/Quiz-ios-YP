import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterProtocol {
    // MARK: - Lifecycle
    @IBOutlet weak  var imageView: UIImageView!
    @IBOutlet weak  var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var delegate: AlertPresenterDelegate?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.requestNextQuestion()
        questionFactory?.loadData()
        delegate = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        presenter.movieQuizViewComtroller = self
    }
    
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        imageView.layer.cornerRadius = 20
        presenter.didRecieveNextQuestion(question: question)
    }
    
    // MARK: - AlertPresenterDelegate
    func resetGame() {
        //Обнуляем счетчик вопросов
        presenter.resetQuestionIndex()
        // Обнуляем счетчик правельных ответов
        correctAnswers = 0
        counterLabel.text = "\(self.correctAnswers)/\(presenter.questionsAmount)"
        // заново показываем первый вопрос
        questionFactory?.requestNextQuestion()
        
    }
    
     func show(quiz result: QuizResultsViewModel) {
        guard let statisticService = statisticService else {return}
        self.statisticService?.gamesCount += 1
        self.statisticService?.allTimeQuestions +=  presenter.questionsAmount
        self.statisticService?.allTimeCorrectAnswers += correctAnswers
        self.statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
        
        let alertModel = AlertModel(title: result.title,
                                    message: """
                                    Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
                                    Количество сыгранных квизов: \(statisticService.gamesCount)
                                    Рекорд: \(statisticService.bestGame.correct)/\(presenter.questionsAmount) (\(statisticService.bestGame.date.dateTimeString))
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
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            
            guard let self = self else { return }
            self.resetGame()
        }
        
        guard let alert =  delegate?.showAlert(alertModel: alert) else { return }
        alert.view.accessibilityIdentifier = "Game results"
        present(alert, animated: true)
    }
    
    // MARK: - AlertPresenterProtocol
     func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
    }
    
//        private func convert(model: QuizQuestion) -> QuizStepViewModel {
//            self.textLabel.text = model.text
//            self.currentQuestion = model // тут мы сохроняем текущий вопрос
//            return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
//                                     question: model.text,
//                                     questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//        }
    @IBAction private func noButton(_ sender: Any) {
        presenter.noButton()
    }
    
    @IBAction private func yesButton(_ sender: Any) {
        presenter.yesButton()
    }
    
     func showAnswerResult(isCorrect: Bool) {
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
            guard let self = self else { return }
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
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
