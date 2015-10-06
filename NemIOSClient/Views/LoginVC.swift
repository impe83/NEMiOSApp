import UIKit

class LoginVC: AbstractViewController, UITableViewDelegate, APIManagerDelegate, EditableTableViewCellDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addWallet: UIButton!
    
    //MARK: - Variables
    
    let observer :NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    var dataManager :CoreDataManager = CoreDataManager()
    var apiManager :APIManager = APIManager()
    
    var wallets :[Wallet] = [Wallet]()
    var selectedIndex :Int  = -1
    
    private var _isEditing = false
    
    //MARK: - Load Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        State.fromVC = SegueToLoginVC
        State.currentVC = SegueToLoginVC
        
        apiManager.delegate = self
        
        wallets  = dataManager.getWallets()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.layer.cornerRadius = 5

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction
    
    @IBAction func addNewWallet(sender: AnyObject) {
        
        if self.delegate != nil && self.delegate!.respondsToSelector("pageSelected:") {
            (self.delegate as! MainVCDelegate).pageSelected(SegueToAddAccountVC)
        }
    }
    
    @IBAction func editButtonTouchUpInside(sender: AnyObject) {
        
        for cell in self.tableView.visibleCells {
            (cell as! WalletCell).isEditable = _isEditing
        }
        
        _isEditing = !_isEditing
    }
    
    //MARK: - TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : WalletCell = self.tableView.dequeueReusableCellWithIdentifier("walletCell") as! WalletCell
        cell.isEditable = !_isEditing
        cell.editDelegate = self
        let cellData  :Wallet = wallets[indexPath.row]
        
        cell.infoLabel.attributedText = NSMutableAttributedString(string: cellData.login as String , attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 16)!])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !_isEditing {
            if State.currentServer != nil {
                State.currentWallet = wallets[indexPath.row]
                apiManager.heartbeat(State.currentServer!)
            }
            else {
                State.toVC = SegueToServerVC
                
                if self.delegate != nil && self.delegate!.respondsToSelector("pageSelected:") {
                    (self.delegate as! MainVCDelegate).pageSelected(SegueToServerVC)
                }
            }
        }
    }
    
    //MARK: - EditableTableViewCellDelegate Delegate
    
    func deleteCell(cell: EditableTableViewCell){
        let index :NSIndexPath = tableView.indexPathForCell(cell)!
        
        if index.row < wallets.count {
            dataManager.deleteWallet(wallet: wallets[index.row])
            wallets.removeAtIndex(index.row)
            
            tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    //MARK: - APIManagerDelegate Methods
    
    final func heartbeatResponceFromServer(server :Server ,successed :Bool) {
        if successed {
            APIManager().timeSynchronize(server)
            
            State.toVC = SegueToMessages
            
            if self.delegate != nil && self.delegate!.respondsToSelector("pageSelected:") {
                (self.delegate as! MainVCDelegate).pageSelected(SegueToDashboard)
            }
        } else {
            
            State.currentServer = nil
            State.toVC = SegueToServerVC
            
            if self.delegate != nil && self.delegate!.respondsToSelector("pageSelected:") {
                (self.delegate as! MainVCDelegate).pageSelected(SegueToServerVC)
            }
        }
    }
}
