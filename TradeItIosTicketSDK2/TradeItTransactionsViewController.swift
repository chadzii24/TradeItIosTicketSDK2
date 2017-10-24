import UIKit
import MBProgressHUD
import PromiseKit

class TradeItTransactionsViewController: TradeItViewController, TradeItTransactionsTableDelegate {
    
    let alertManager = TradeItAlertManager()
    var transactionsTableViewManager = TradeItTransactionsTableViewManager()
    
    @IBOutlet weak var transactionsTable: UITableView!
    
    var linkedBrokerAccount: TradeItLinkedBrokerAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionsTableViewManager.transactionsTable = transactionsTable
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTransactions()
    }
    
    // MARK: TradeItTransactionsTableDelegate
    func refreshRequested(onRefreshComplete: @escaping () -> Void) {
        guard let linkedBrokerAccount = self.linkedBrokerAccount
            , let linkedBroker = linkedBrokerAccount.linkedBroker else {
                preconditionFailure("TradeItIosTicketSDK ERROR: TradeItTransactionsViewController loaded without setting linkedBrokerAccount.")
        }
        func authenticatePromise() -> Promise<Void>{
            return Promise<Void> { fulfill, reject in
                linkedBroker.authenticateIfNeeded(
                    onSuccess: fulfill,
                    onSecurityQuestion: { securityQuestion, answerSecurityQuestion, cancelSecurityQuestion in
                        self.alertManager.promptUserToAnswerSecurityQuestion(
                            securityQuestion,
                            onViewController: self,
                            onAnswerSecurityQuestion: answerSecurityQuestion,
                            onCancelSecurityQuestion: cancelSecurityQuestion
                        )
                },
                    onFailure: reject
                )
            }
        }
        
        func transactionsPromise() -> Promise<[TradeItTransaction]> {
            return Promise<[TradeItTransaction]> { fulfill, reject in
                linkedBrokerAccount.getTransactionsHistory(
                    onSuccess: fulfill,
                    onFailure: reject
                )
            }
        }
        
        authenticatePromise().then { _ in
            return transactionsPromise()
            }.then { transactions in
                self.transactionsTableViewManager.updateTransactions(transactions)
            }.always {
                onRefreshComplete()
            }.catch { error in
                let error = error as? TradeItErrorResult ??
                    TradeItErrorResult(
                        title: "Fetching transactions failed",
                        message: "Could not fetch transactions. Please try again."
                )
                self.alertManager.showAlertWithAction(
                    error: error,
                    withLinkedBroker: self.linkedBrokerAccount?.linkedBroker,
                    onViewController: self
                )
        }
    }

    // MARK: private
    
    private func loadTransactions() {
        let activityView = MBProgressHUD.showAdded(to: self.view, animated: true)
        activityView.label.text = "Loading transactions"
        self.refreshRequested {
            activityView.hide(animated: true)
        }
    }
}
