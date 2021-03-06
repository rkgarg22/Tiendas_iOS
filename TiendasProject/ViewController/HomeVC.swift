
import UIKit

class HomeVC: UIViewController
{
    var viewControllers: [UIViewController]!
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var titleLabelView: UILabel!
    
    var ListArray = NSMutableArray()
    var isfromtiendas = Bool()
    var lebelTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.methodOfReceivedNotification(notification:)), name: Notification.Name("openshadow"), object: nil)
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        let vc = storyboard!.instantiateViewController(withIdentifier: "StoreListVC");
        pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        addChildViewController(pageViewController)
        pageView.addSubview(pageViewController.view)
        pageViewController!.view.frame = pageView.bounds
        pageViewController.didMove(toParentViewController: self)
        pageView.gestureRecognizers = pageViewController.gestureRecognizers
        print(lebelTitle)
        if(self.lebelTitle != ""){
            self.titleLabelView.text = lebelTitle
        }else{
             self.titleLabelView.text = "CERCA DE MI"
        }
    }
    
    @IBAction func backAction(_ sender: Any)
    {
        switch Alomafire.sharedInstance.currentStatus {
        case "List":
    self.navigationController?.popViewController(animated:true)
            break;
        case "Map":
    self.navigationController?.popViewController(animated:true)
            break;
        case navigatorStatus.ListViewSelect:
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideView"), object: nil, userInfo:nil)
            break
        default:
    self.navigationController?.popViewController(animated:true)

            break;
        }
    }
    @objc func methodOfReceivedNotification(notification: Notification)
    {
        if  notification.userInfo?["text"] as? String == "true"{
            overlayView.isHidden = true;
        }
        else{
            overlayView.isHidden = false;
        }
    }
    //Mark :-
    @IBAction func listAction(_ sender: Any)
    {
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listShow"), object: nil, userInfo:nil)
        mapButton.isSelected = false;
        listButton.isSelected = true;
        let viewController = pageViewController.viewControllers?.last
        if (viewController is ListInMapViewVC){
            let vc = storyboard!.instantiateViewController(withIdentifier: "StoreListVC")
            self.pageViewController.setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
        }
    }
    
    @IBAction func mapAction(_ sender: Any)
    {
        mapButton.isSelected = true;
        listButton.isSelected = false;
        let viewController = pageViewController.viewControllers?.last
        if (viewController is StoreListVC){
            let vc = storyboard!.instantiateViewController(withIdentifier: "ListInMapViewVC")
            self.pageViewController.setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
}
extension HomeVC : UIPageViewControllerDataSource,UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (viewController is ListInMapViewVC)
        {
            let vc = storyboard!.instantiateViewController(withIdentifier: "StoreListVC")
            return vc
        }
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (viewController is StoreListVC)
        {
            let vc = storyboard!.instantiateViewController(withIdentifier: "ListInMapViewVC")
            return vc
        }
        return nil;
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        
        let viewController = pageViewController.viewControllers?.last
        if (viewController is StoreListVC){
            mapButton.isSelected = false;
            listButton.isSelected = true;
        }
        else{
            mapButton.isSelected = true;
            listButton.isSelected = false;
        }
    }
}

extension HomeVC
{
    
}


