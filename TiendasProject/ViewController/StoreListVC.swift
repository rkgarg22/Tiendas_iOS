
import UIKit

class StoreListVC: UIViewController {

    @IBOutlet weak var backButtonPosition: NSLayoutConstraint!
    @IBOutlet weak var storeListTableView: UITableView!
    var controllerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self .setupTrackMapView()
    }
 
    //MARK:- Button's Action
    @IBAction func backAction(_ sender: Any)
    {
        showTrackView(hidestatus: true)
    }
    //MARK:- Helping Methpd's
    func setupTrackMapView()
    {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListInMapViewVC")
        addChildViewController(controller!)
        controllerView =  (controller?.view)!
        controllerView.frame = CGRect(x: self.view.frame.size.width+20, y: 0, width:self.view.frame.size.width , height: self.view.frame.size.height)
        view.addSubview((controller?.view)!)
        controller?.didMove(toParentViewController: self)
    }
    
    func showTrackView(hidestatus:Bool)
    {
        if ( hidestatus == true)
        {
            UIView .animate(withDuration: 0.3, animations: {
                self.backButtonPosition.constant = -30; self.controllerView.frame = CGRect(x: self.view.frame.size.width+20, y: 0, width:self.view.frame.size.width , height: self.view.frame.size.height)
            })
        }
        else
        {
             UIView .animate(withDuration: 0.3, animations: {
                self.backButtonPosition.constant = 12; self.controllerView.frame = CGRect(x: 0, y:30, width:self.view.frame.size.width , height: self.view.frame.size.height)
 })
    }
    }
    
}

//MARK:- TableView Datasource and AppDelegate
extension StoreListVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellReuseIdentifier = "listCell"
        let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTrackView(hidestatus: false)
    }
    
}
