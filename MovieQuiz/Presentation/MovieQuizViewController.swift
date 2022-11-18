import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterProtocol {
    // MARK: - Lifecycle
    @IBOutlet weak  var imageView: UIImageView!
    @IBOutlet weak  var textLabel: UILabel!
    @IBOutlet weak  var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
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
        presenter.resetGame()
    }
    
     func show(quiz result: QuizResultsViewModel) {

         let message = presenter.makeResultsMessage()
         
        let alertModel = AlertModel(title: result.title,
                                    message: message,
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
         self.imageView.layer.cornerRadius = 20
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
    }

    @IBAction private func noButton(_ sender: Any) {
        presenter.noButton()
    }
    
    @IBAction private func yesButton(_ sender: Any) {
        presenter.yesButton()
    }
    
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.YPGreen.cgColor : UIColor.YPRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
    }
    
    func disableImageBorder() {
        imageView.layer.borderWidth = 0
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
}
