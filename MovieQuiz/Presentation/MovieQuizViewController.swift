import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterProtocol {
    // MARK: - Lifecycle
    @IBOutlet weak  var imageView: UIImageView!
    @IBOutlet weak  var textLabel: UILabel!
    @IBOutlet weak  var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    private var currentQuestion: QuizQuestion?
    private var delegate: AlertPresenterDelegate?
    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        presenter = MovieQuizPresenter(movieViewController: self)
        delegate = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
    }
    
    // MARK: - AlertPresenterDelegate
    func resetGame() {
        
    }
    
     func show(quiz result: QuizResultsViewModel) {
        guard let statisticService = statisticService else {return}
        self.statisticService?.gamesCount += 1
        self.statisticService?.allTimeQuestions +=  presenter.questionsAmount
         self.statisticService?.allTimeCorrectAnswers += presenter.correctAnswers
         self.statisticService?.store(correct: presenter.correctAnswers,
                                      total: presenter.questionsAmount)
        
        let alertModel = AlertModel(title: result.title,
                                    message: """
                                    Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)
                                    Количество сыгранных квизов: \(statisticService.gamesCount)
                                    Рекорд: \(statisticService.bestGame.correct)/\(presenter.questionsAmount) (\(statisticService.bestGame.date.dateTimeString))
                                    Средняя точнось: \(String(format: "%.2f", statisticService.totalAccuracy))%"
                                    """,
                                    buttonText: result.buttonText)
        
        guard let alert = delegate?.showAlert(alertModel: alertModel) else { return }
        present(alert, animated: true)
        
    }
    
    // MARK: - Activity Indicator and error Alert
    
     func showLoadingIndicator() {
        activityIndicator.isHidden = false // индикатор загрузки не скрыт
        activityIndicator.startAnimating() // запуск анимации
    }
    
     func hideLoadingIndicator() {
        activityIndicator.isHidden = false // индикатор загруски скрыт
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            
            guard let self = self else { return }
            self.presenter.resetGame()
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
         presenter.didAnswer(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
}
